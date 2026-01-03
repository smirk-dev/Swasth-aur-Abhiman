import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Between, LessThanOrEqual, MoreThanOrEqual } from 'typeorm';
import { HealthMetric, HealthMetricSession } from './entities/health-metric.entity';
import { User } from '../users/entities/user.entity';
import {
  CreateHealthMetricDto,
  CreateHealthMetricSessionDto,
  GetHealthMetricsFilterDto,
  HealthMetricsSummaryDto,
} from './dto/create-health-metric.dto';

@Injectable()
export class HealthService {
  constructor(
    @InjectRepository(HealthMetric)
    private healthMetricRepository: Repository<HealthMetric>,
    @InjectRepository(HealthMetricSession)
    private healthSessionRepository: Repository<HealthMetricSession>,
  ) {}

  // ==================== INDIVIDUAL METRICS ====================

  /**
   * Record a single health metric
   */
  async recordMetric(
    user: User,
    createHealthMetricDto: CreateHealthMetricDto,
  ) {
    const metric = this.healthMetricRepository.create({
      user,
      metricType: createHealthMetricDto.metricType,
      value: createHealthMetricDto.value,
      unit: createHealthMetricDto.unit || this.getDefaultUnit(createHealthMetricDto.metricType),
      notes: createHealthMetricDto.notes,
      recordedAt: createHealthMetricDto.recordedAt || new Date(),
      condition: this.evaluateCondition(
        createHealthMetricDto.metricType,
        createHealthMetricDto.value,
      ),
    });

    return this.healthMetricRepository.save(metric);
  }

  /**
   * Get user's health metrics with filters
   */
  async getMetrics(
    user: User,
    filters: GetHealthMetricsFilterDto,
  ) {
    const query = this.healthMetricRepository.createQueryBuilder('metric')
      .where('metric.userId = :userId', { userId: user.id })
      .orderBy('metric.recordedAt', 'DESC');

    if (filters.metricType) {
      query.andWhere('metric.metricType = :metricType', {
        metricType: filters.metricType,
      });
    }

    if (filters.startDate && filters.endDate) {
      query.andWhere(
        'metric.recordedAt BETWEEN :startDate AND :endDate',
        {
          startDate: filters.startDate,
          endDate: filters.endDate,
        },
      );
    }

    const limit = filters.limit || 100;
    const offset = filters.offset || 0;

    const [metrics, total] = await query
      .take(limit)
      .skip(offset)
      .getManyAndCount();

    return {
      data: metrics,
      total,
      limit,
      offset,
    };
  }

  /**
   * Get latest metrics for each type
   */
  async getLatestMetrics(user: User) {
    const metricTypes = [
      'BP_SYSTOLIC',
      'BP_DIASTOLIC',
      'BLOOD_SUGAR',
      'BMI',
      'WEIGHT',
      'HEIGHT',
      'TEMPERATURE',
      'PULSE',
    ];

    const latestMetrics = {};

    for (const type of metricTypes) {
      const metric = await this.healthMetricRepository.findOne({
        where: { user, metricType: type },
        order: { recordedAt: 'DESC' },
      });

      if (metric) {
        latestMetrics[type] = {
          value: metric.value,
          unit: metric.unit,
          recordedAt: metric.recordedAt,
          condition: metric.condition,
        };
      }
    }

    return latestMetrics;
  }

  /**
   * Get health metrics summary with trends
   */
  async getHealthSummary(user: User): Promise<HealthMetricsSummaryDto> {
    const latestMetrics = await this.getLatestMetrics(user);

    // Get metrics from last 30 days for trend analysis
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

    const recentMetrics = await this.healthMetricRepository.find({
      where: {
        user,
        recordedAt: MoreThanOrEqual(thirtyDaysAgo),
      },
      order: { recordedAt: 'DESC' },
    });

    // Calculate trends and averages
    const trends = {};
    const averages = {};

    const metricTypes = [
      'BP_SYSTOLIC',
      'BP_DIASTOLIC',
      'BLOOD_SUGAR',
      'BMI',
      'WEIGHT',
      'HEIGHT',
      'TEMPERATURE',
      'PULSE',
    ];

    for (const type of metricTypes) {
      const typeMetrics = recentMetrics.filter(m => m.metricType === type);

      if (typeMetrics.length > 1) {
        const current = typeMetrics[0].value;
        const previous = typeMetrics[typeMetrics.length - 1].value;
        const change = current - previous;
        const changePercent = (change / previous) * 100;

        trends[type] = {
          current,
          previous,
          change,
          changePercent,
        };
      }

      if (typeMetrics.length > 0) {
        const sum = typeMetrics.reduce((acc, m) => acc + parseFloat(m.value.toString()), 0);
        averages[type] = sum / typeMetrics.length;
      }
    }

    return {
      latestMetrics,
      trends,
      averages,
    };
  }

  /**
   * Get metrics for a specific date range with grouping
   */
  async getMetricsRange(
    user: User,
    startDate: Date,
    endDate: Date,
    metricType?: string,
  ) {
    const query = this.healthMetricRepository.createQueryBuilder('metric')
      .where('metric.userId = :userId', { userId: user.id })
      .andWhere(
        'metric.recordedAt BETWEEN :startDate AND :endDate',
        { startDate, endDate },
      )
      .orderBy('metric.recordedAt', 'ASC');

    if (metricType) {
      query.andWhere('metric.metricType = :metricType', { metricType });
    }

    return query.getMany();
  }

  // ==================== METRIC SESSIONS ====================

  /**
   * Record a complete health check session
   */
  async recordSession(
    user: User,
    createSessionDto: CreateHealthMetricSessionDto,
  ) {
    const session = this.healthSessionRepository.create({
      user,
      ...createSessionDto,
    });

    return this.healthSessionRepository.save(session);
  }

  /**
   * Get user's health sessions
   */
  async getSessions(user: User, limit: number = 30) {
    return this.healthSessionRepository.find({
      where: { user },
      order: { date: 'DESC' },
      take: limit,
    });
  }

  /**
   * Get session by date
   */
  async getSessionByDate(user: User, date: string) {
    return this.healthSessionRepository.findOne({
      where: { user, date },
    });
  }

  // ==================== HEALTH ANALYSIS ====================

  /**
   * Evaluate BP condition
   */
  evaluateBPCondition(systolic: number, diastolic: number): string {
    if (systolic < 90 || diastolic < 60) return 'low';
    if (systolic < 120 && diastolic < 80) return 'normal';
    if (systolic < 130 && diastolic < 80) return 'elevated';
    if (systolic < 140 || diastolic < 90) return 'high';
    return 'critical';
  }

  /**
   * Evaluate blood sugar condition
   */
  evaluateBloodSugarCondition(value: number): string {
    if (value < 70) return 'low';
    if (value <= 100) return 'normal';
    if (value <= 125) return 'elevated';
    if (value <= 200) return 'high';
    return 'critical';
  }

  /**
   * Evaluate BMI condition
   */
  evaluateBMICondition(value: number): string {
    if (value < 18.5) return 'underweight';
    if (value < 25) return 'normal';
    if (value < 30) return 'overweight';
    return 'obese';
  }

  /**
   * Get health recommendations based on metrics
   */
  async getHealthRecommendations(user: User): Promise<string[]> {
    const summary = await this.getHealthSummary(user);
    const recommendations: string[] = [];

    // BP recommendations
    if (summary.latestMetrics['BP_SYSTOLIC']) {
      const bpSystolic = summary.latestMetrics['BP_SYSTOLIC'].value;
      const bpDiastolic = summary.latestMetrics['BP_DIASTOLIC'].value;
      const bpCondition = this.evaluateBPCondition(bpSystolic, bpDiastolic);

      if (bpCondition === 'high') {
        recommendations.push(
          'Your blood pressure is elevated. Reduce salt intake and increase physical activity.',
        );
      } else if (bpCondition === 'critical') {
        recommendations.push(
          'Your blood pressure is critically high. Please consult a doctor immediately.',
        );
      }
    }

    // Blood sugar recommendations
    if (summary.latestMetrics['BLOOD_SUGAR']) {
      const bloodSugar = summary.latestMetrics['BLOOD_SUGAR'].value;
      const condition = this.evaluateBloodSugarCondition(bloodSugar);

      if (condition === 'high') {
        recommendations.push(
          'Your blood sugar levels are elevated. Monitor your diet and consult a healthcare provider.',
        );
      } else if (condition === 'low') {
        recommendations.push(
          'Your blood sugar levels are low. Consider eating a balanced meal with carbohydrates.',
        );
      }
    }

    // BMI recommendations
    if (summary.latestMetrics['BMI']) {
      const bmi = summary.latestMetrics['BMI'].value;
      const condition = this.evaluateBMICondition(bmi);

      if (condition === 'overweight' || condition === 'obese') {
        recommendations.push(
          'Maintain a healthy diet and regular exercise. Consider consulting a nutritionist.',
        );
      }
    }

    if (recommendations.length === 0) {
      recommendations.push(
        'Keep up the good work! Continue monitoring your health regularly.',
      );
    }

    return recommendations;
  }

  // ==================== HELPER METHODS ====================

  private getDefaultUnit(metricType: string): string {
    const units = {
      BP_SYSTOLIC: 'mmHg',
      BP_DIASTOLIC: 'mmHg',
      BLOOD_SUGAR: 'mg/dL',
      BMI: 'kg/m²',
      WEIGHT: 'kg',
      HEIGHT: 'cm',
      TEMPERATURE: '°F',
      PULSE: 'bpm',
    };
    return units[metricType] || '';
  }

  private evaluateCondition(metricType: string, value: number): string {
    switch (metricType) {
      case 'BP_SYSTOLIC':
        return value < 120 ? 'normal' : value < 130 ? 'elevated' : 'high';
      case 'BLOOD_SUGAR':
        return this.evaluateBloodSugarCondition(value);
      case 'BMI':
        return this.evaluateBMICondition(value);
      case 'TEMPERATURE':
        return value >= 98.6 && value <= 99.5 ? 'normal' : 'abnormal';
      default:
        return 'normal';
    }
  }
}
