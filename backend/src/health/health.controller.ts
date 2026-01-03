import {
  Controller,
  Get,
  Post,
  Body,
  Query,
  UseGuards,
  Param,
} from '@nestjs/common';
import { HealthService } from './health.service';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { GetUser } from '../common/decorators/get-user.decorator';
import { User } from '../users/entities/user.entity';
import {
  CreateHealthMetricDto,
  CreateHealthMetricSessionDto,
  GetHealthMetricsFilterDto,
} from './dto/create-health-metric.dto';

@Controller('health')
@UseGuards(JwtAuthGuard)
export class HealthController {
  constructor(private healthService: HealthService) {}

  // ==================== METRIC ENDPOINTS ====================

  /**
   * Record a single health metric
   * POST /health/metrics
   */
  @Post('metrics')
  async recordMetric(
    @Body() createHealthMetricDto: CreateHealthMetricDto,
    @GetUser() user: User,
  ) {
    return this.healthService.recordMetric(user, createHealthMetricDto);
  }

  /**
   * Get user's health metrics with filters
   * GET /health/metrics?metricType=BLOOD_SUGAR&limit=50
   */
  @Get('metrics')
  async getMetrics(
    @Query() filters: GetHealthMetricsFilterDto,
    @GetUser() user: User,
  ) {
    return this.healthService.getMetrics(user, filters);
  }

  /**
   * Get latest values for all metric types
   * GET /health/metrics/latest
   */
  @Get('metrics/latest')
  async getLatestMetrics(@GetUser() user: User) {
    return this.healthService.getLatestMetrics(user);
  }

  /**
   * Get health summary with trends and averages
   * GET /health/summary
   */
  @Get('summary')
  async getHealthSummary(@GetUser() user: User) {
    return this.healthService.getHealthSummary(user);
  }

  /**
   * Get metrics for a date range
   * GET /health/metrics/range?startDate=2024-01-01&endDate=2024-01-31&metricType=BLOOD_SUGAR
   */
  @Get('metrics/range')
  async getMetricsRange(
    @Query('startDate') startDate: string,
    @Query('endDate') endDate: string,
    @Query('metricType') metricType?: string,
    @GetUser() user?: User,
  ) {
    return this.healthService.getMetricsRange(
      user,
      new Date(startDate),
      new Date(endDate),
      metricType,
    );
  }

  /**
   * Get health recommendations based on current metrics
   * GET /health/recommendations
   */
  @Get('recommendations')
  async getRecommendations(@GetUser() user: User) {
    return this.healthService.getHealthRecommendations(user);
  }

  // ==================== SESSION ENDPOINTS ====================

  /**
   * Record a complete health check session
   * POST /health/sessions
   */
  @Post('sessions')
  async recordSession(
    @Body() createSessionDto: CreateHealthMetricSessionDto,
    @GetUser() user: User,
  ) {
    return this.healthService.recordSession(user, createSessionDto);
  }

  /**
   * Get user's health sessions
   * GET /health/sessions?limit=30
   */
  @Get('sessions')
  async getSessions(
    @Query('limit') limit: number = 30,
    @GetUser() user: User,
  ) {
    return this.healthService.getSessions(user, limit);
  }

  /**
   * Get session by specific date
   * GET /health/sessions/:date (format: YYYY-MM-DD)
   */
  @Get('sessions/:date')
  async getSessionByDate(
    @Param('date') date: string,
    @GetUser() user: User,
  ) {
    return this.healthService.getSessionByDate(user, date);
  }

  // ==================== ANALYSIS ENDPOINTS ====================

  /**
   * Evaluate BP condition
   * POST /health/analyze/bp
   */
  @Post('analyze/bp')
  analyzeBP(
    @Body() { systolic, diastolic }: { systolic: number; diastolic: number },
  ) {
    const condition = this.healthService.evaluateBPCondition(systolic, diastolic);
    return {
      systolic,
      diastolic,
      condition,
      recommendation: this.getBPRecommendation(condition),
    };
  }

  /**
   * Evaluate blood sugar condition
   * POST /health/analyze/blood-sugar
   */
  @Post('analyze/blood-sugar')
  analyzeBloodSugar(@Body() { value }: { value: number }) {
    const condition = this.healthService.evaluateBloodSugarCondition(value);
    return {
      value,
      unit: 'mg/dL',
      condition,
      recommendation: this.getBloodSugarRecommendation(condition),
    };
  }

  /**
   * Evaluate BMI condition
   * POST /health/analyze/bmi
   */
  @Post('analyze/bmi')
  analyzeBMI(@Body() { value }: { value: number }) {
    const condition = this.healthService.evaluateBMICondition(value);
    return {
      value,
      unit: 'kg/m²',
      condition,
      recommendation: this.getBMIRecommendation(condition),
    };
  }

  // ==================== HELPER METHODS ====================

  private getBPRecommendation(condition: string): string {
    const recommendations = {
      normal: 'Your blood pressure is healthy. Maintain your current lifestyle.',
      elevated: 'Your blood pressure is slightly elevated. Reduce stress and exercise regularly.',
      high: 'Your blood pressure is elevated. Consult a doctor and reduce salt intake.',
      critical: 'Your blood pressure is critically high. Seek medical help immediately.',
    };
    return recommendations[condition] || 'Monitor your blood pressure regularly.';
  }

  private getBloodSugarRecommendation(condition: string): string {
    const recommendations = {
      normal: 'Your blood sugar level is healthy.',
      elevated: 'Your blood sugar is slightly elevated. Monitor your diet.',
      high: 'Your blood sugar is high. Consult a healthcare provider and adjust your diet.',
      critical: 'Your blood sugar is critically high. Seek medical help immediately.',
      low: 'Your blood sugar is low. Consume a balanced meal with carbohydrates.',
    };
    return recommendations[condition] || 'Monitor your blood sugar regularly.';
  }

  private getBMIRecommendation(condition: string): string {
    const recommendations = {
      normal: 'Your BMI is in the healthy range.',
      underweight: 'You are underweight. Ensure a balanced diet with adequate calories.',
      overweight: 'You are overweight. Exercise regularly and maintain a balanced diet.',
      obese: 'You are obese. Consult a nutritionist and physician for a weight management plan.',
    };
    return recommendations[condition] || 'Maintain a healthy lifestyle.';
  }
}
