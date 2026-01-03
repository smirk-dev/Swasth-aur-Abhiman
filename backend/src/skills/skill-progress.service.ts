import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, MoreThan } from 'typeorm';
import { SkillEnrollment, SkillProgress } from './entities/skill-progress.entity';
import { User } from '../users/entities/user.entity';

@Injectable()
export class SkillProgressService {
  constructor(
    @InjectRepository(SkillEnrollment)
    private enrollmentRepo: Repository<SkillEnrollment>,
    @InjectRepository(SkillProgress)
    private progressRepo: Repository<SkillProgress>,
  ) {}

  async enrollUserInSkill(
    user: User,
    skillCategory: string,
    totalCoursesCount: number,
  ): Promise<SkillEnrollment> {
    const existingEnrollment = await this.enrollmentRepo.findOne({
      where: { user: { id: user.id }, skillCategory },
    });

    if (existingEnrollment) {
      return existingEnrollment;
    }

    const enrollment = this.enrollmentRepo.create({
      user,
      skillCategory,
      totalCoursesCount,
      completedCoursesCount: 0,
      completionPercentage: 0,
      status: 'ENROLLED',
    });

    return this.enrollmentRepo.save(enrollment);
  }

  async recordCourseProgress(
    user: User,
    enrollmentId: string,
    courseId: string,
    courseTitle: string,
    videoUrl: string,
    watchedDurationSeconds: number,
    totalDurationSeconds: number,
  ): Promise<SkillProgress> {
    let progress = await this.progressRepo.findOne({
      where: {
        user: { id: user.id },
        enrollment: { id: enrollmentId },
        courseId,
      },
    });

    const progressPercentage =
      totalDurationSeconds > 0
        ? Math.round(
            (watchedDurationSeconds / totalDurationSeconds) * 100,
          )
        : 0;

    const isCompleted = progressPercentage >= 80; // 80% watched = completed

    if (!progress) {
      progress = this.progressRepo.create({
        user,
        enrollment: { id: enrollmentId } as any,
        courseId,
        courseTitle,
        videoUrl,
        watchedDurationSeconds,
        totalDurationSeconds,
        progressPercentage,
        isCompleted,
        viewCount: 1,
        lastWatchedAt: new Date(),
        completedAt: isCompleted ? new Date() : null,
      });
    } else {
      progress.watchedDurationSeconds = watchedDurationSeconds;
      progress.progressPercentage = progressPercentage;
      progress.viewCount += 1;
      progress.lastWatchedAt = new Date();
      if (isCompleted && !progress.isCompleted) {
        progress.isCompleted = true;
        progress.completedAt = new Date();
      }
    }

    const savedProgress = await this.progressRepo.save(progress);

    // Update enrollment completion percentage
    await this.updateEnrollmentProgress(enrollmentId);

    return savedProgress;
  }

  private async updateEnrollmentProgress(
    enrollmentId: string,
  ): Promise<void> {
    const enrollment = await this.enrollmentRepo.findOne({
      where: { id: enrollmentId },
      relations: ['user'],
    });

    if (!enrollment) return;

    const completedCourses = await this.progressRepo.count({
      where: {
        enrollment: { id: enrollmentId },
        isCompleted: true,
      },
    });

    const totalCourses = enrollment.totalCoursesCount;
    const completionPercentage =
      totalCourses > 0 ? Math.round((completedCourses / totalCourses) * 100) : 0;

    enrollment.completedCoursesCount = completedCourses;
    enrollment.completionPercentage = completionPercentage;

    // Award certificate when 100% complete
    if (completionPercentage === 100 && !enrollment.certificateIssuedDate) {
      enrollment.certificateIssuedDate = new Date();
      enrollment.status = 'COMPLETED';
    }

    await this.enrollmentRepo.save(enrollment);
  }

  async getUserEnrollments(userId: string): Promise<SkillEnrollment[]> {
    return this.enrollmentRepo.find({
      where: { user: { id: userId } },
      order: { createdAt: 'DESC' },
    });
  }

  async getEnrollmentProgress(
    enrollmentId: string,
  ): Promise<{
    enrollment: SkillEnrollment;
    courses: SkillProgress[];
    nextRecommendedCourse: SkillProgress | null;
  }> {
    const enrollment = await this.enrollmentRepo.findOne({
      where: { id: enrollmentId },
    });

    if (!enrollment) {
      throw new Error('Enrollment not found');
    }

    const courses = await this.progressRepo.find({
      where: { enrollment: { id: enrollmentId } },
      order: { createdAt: 'ASC' },
    });

    // Find next incomplete course
    const nextCourse = await this.progressRepo.findOne({
      where: {
        enrollment: { id: enrollmentId },
        isCompleted: false,
      },
      order: { createdAt: 'ASC' },
    });

    return {
      enrollment,
      courses,
      nextRecommendedCourse: nextCourse || null,
    };
  }

  async getSkillLeaderboard(
    skillCategory: string,
    limit: number = 10,
  ): Promise<
    Array<{
      rank: number;
      user: { id: string; name: string; avatar?: string };
      completionPercentage: number;
      completedAt?: Date;
    }>
  > {
    const enrollments = await this.enrollmentRepo.find({
      where: {
        skillCategory,
        status: 'COMPLETED',
      },
      relations: ['user'],
      order: { certificateIssuedDate: 'ASC' },
      take: limit,
    });

    return enrollments.map((enrollment, index) => ({
      rank: index + 1,
      user: {
        id: enrollment.user.id,
        name: enrollment.user.fullName,
      },
      completionPercentage: enrollment.completionPercentage,
      completedAt: enrollment.certificateIssuedDate,
    }));
  }

  async getUserCertificates(userId: string): Promise<SkillEnrollment[]> {
    return this.enrollmentRepo.find({
      where: {
        user: { id: userId },
        certificateIssuedDate: MoreThan(new Date('2000-01-01')),
      },
      order: { certificateIssuedDate: 'DESC' },
    });
  }

  async getSkillStats(skillCategory: string): Promise<{
    totalEnrollments: number;
    completedCertificates: number;
    averageCompletionPercentage: number;
    activeEnrollments: number;
  }> {
    const enrollments = await this.enrollmentRepo.find({
      where: { skillCategory },
    });

    const completedCount = enrollments.filter(
      (e) => e.status === 'COMPLETED',
    ).length;
    const avgCompletion =
      enrollments.length > 0
        ? Math.round(
            enrollments.reduce((sum, e) => sum + e.completionPercentage, 0) /
              enrollments.length,
          )
        : 0;

    return {
      totalEnrollments: enrollments.length,
      completedCertificates: completedCount,
      averageCompletionPercentage: avgCompletion,
      activeEnrollments: enrollments.filter(
        (e) => e.status === 'ENROLLED',
      ).length,
    };
  }

  async getRecommendedCourseAfter(
    enrollmentId: string,
  ): Promise<SkillProgress | null> {
    const enrollment = await this.enrollmentRepo.findOne({
      where: { id: enrollmentId },
    });

    if (!enrollment) return null;

    // Get next incomplete course
    return this.progressRepo.findOne({
      where: {
        enrollment: { id: enrollmentId },
        isCompleted: false,
      },
      order: { createdAt: 'ASC' },
    });
  }
}
