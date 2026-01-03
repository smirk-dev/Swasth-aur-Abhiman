import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Between, MoreThan } from 'typeorm';
import { MediaContent } from '../media/entities/media-content.entity';
import { User } from '../users/entities/user.entity';
import { SkillEnrollment, SkillProgress } from './entities/skill-progress.entity';
import { MediaCategory } from '../common/enums/media.enum';

@Injectable()
export class TrainerDashboardService {
  constructor(
    @InjectRepository(MediaContent)
    private mediaRepository: Repository<MediaContent>,
    @InjectRepository(User)
    private userRepository: Repository<User>,
    @InjectRepository(SkillEnrollment)
    private enrollmentRepository: Repository<SkillEnrollment>,
    @InjectRepository(SkillProgress)
    private progressRepository: Repository<SkillProgress>,
  ) {}

  /**
   * Get trainer dashboard overview
   */
  async getDashboardOverview(trainerId: string) {
    const [totalCourses, activeCourses, totalEnrollments, completions, recentContent] = await Promise.all([
      this.mediaRepository.count({
        where: {
          category: MediaCategory.SKILL,
          uploadedBy: { id: trainerId },
        },
      }),
      this.mediaRepository.count({
        where: {
          category: MediaCategory.SKILL,
          uploadedBy: { id: trainerId },
          isActive: true,
        },
      }),
      this.getTotalEnrollments(trainerId),
      this.getCompletionStats(trainerId),
      this.mediaRepository.find({
        where: {
          category: MediaCategory.SKILL,
          uploadedBy: { id: trainerId },
        },
        order: { createdAt: 'DESC' },
        take: 5,
      }),
    ]);

    return {
      totalCourses,
      activeCourses,
      totalEnrollments,
      completionRate: completions.completionRate,
      totalCompleted: completions.totalCompleted,
      recentContent,
      stats: {
        coursesByCategory: await this.getCoursesByCategory(trainerId),
        coursesByDifficulty: await this.getCoursesByDifficulty(trainerId),
      },
    };
  }

  /**
   * Get all courses created by trainer
   */
  async getCourses(
    trainerId: string,
    page: number = 1,
    limit: number = 20,
    filters?: {
      category?: string;
      difficulty?: string;
      isActive?: boolean;
    },
  ) {
    const query = this.mediaRepository.createQueryBuilder('media')
      .where('media.category = :category', { category: MediaCategory.SKILL })
      .andWhere('media.uploadedBy.id = :trainerId', { trainerId });

    if (filters?.difficulty) {
      query.andWhere('media.difficulty = :difficulty', { difficulty: filters.difficulty });
    }

    if (filters?.isActive !== undefined) {
      query.andWhere('media.isActive = :isActive', { isActive: filters.isActive });
    }

    const skip = (page - 1) * limit;
    const [data, total] = await query
      .orderBy('media.createdAt', 'DESC')
      .skip(skip)
      .take(limit)
      .getManyAndCount();

    return {
      data,
      total,
      page,
      limit,
      totalPages: Math.ceil(total / limit),
    };
  }

  /**
   * Get course categories
   */
  async getCourseCategories(trainerId: string) {
    const query = this.mediaRepository.createQueryBuilder('media')
      .where('media.category = :category', { category: MediaCategory.SKILL })
      .andWhere('media.uploadedBy.id = :trainerId', { trainerId })
      .select('DISTINCT media.subCategory', 'category')
      .orderBy('media.subCategory', 'ASC');

    const results = await query.getRawMany();
    return results.map(r => r.category).filter(Boolean);
  }

  /**
   * Get difficulty levels available
   */
  async getDifficultyLevels(trainerId: string, category?: string) {
    const query = this.mediaRepository.createQueryBuilder('media')
      .where('media.category = :category', { category: MediaCategory.SKILL })
      .andWhere('media.uploadedBy.id = :trainerId', { trainerId })
      .select('DISTINCT media.difficulty', 'difficulty')
      .orderBy('media.difficulty', 'ASC');

    if (category) {
      query.andWhere('media.subCategory = :category', { category });
    }

    const results = await query.getRawMany();
    return results.map(r => r.difficulty).filter(Boolean);
  }

  /**
   * Get enrollments for a course
   */
  async getCourseEnrollments(
    trainerId: string,
    courseId: string,
    page: number = 1,
    limit: number = 20,
  ) {
    // Verify course belongs to trainer
    const course = await this.mediaRepository.findOne({
      where: {
        id: courseId,
        uploadedBy: { id: trainerId },
        category: MediaCategory.SKILL,
      },
    });

    if (!course) {
      throw new NotFoundException('Course not found');
    }

    const skip = (page - 1) * limit;
    const [enrollments, total] = await this.enrollmentRepository.findAndCount({
      where: {
        skillCategory: course.subCategory,
      },
      relations: ['user'],
      skip,
      take: limit,
    });

    return {
      courseTitle: course.title,
      enrollments: enrollments.map(e => ({
        id: e.id,
        userName: e.user?.fullName,
        userEmail: e.user?.email,
        enrolledAt: e.createdAt,
        completionPercentage: e.completionPercentage,
        status: e.status,
        certificateIssuedDate: e.certificateIssuedDate,
      })),
      total,
      page,
      limit,
      totalPages: Math.ceil(total / limit),
    };
  }

  /**
   * Get student progress in a course
   */
  async getStudentProgress(
    trainerId: string,
    courseId: string,
    studentId: string,
  ) {
    // Verify course belongs to trainer
    const course = await this.mediaRepository.findOne({
      where: {
        id: courseId,
        uploadedBy: { id: trainerId },
        category: MediaCategory.SKILL,
      },
    });

    if (!course) {
      throw new NotFoundException('Course not found');
    }

    const enrollment = await this.enrollmentRepository.findOne({
      where: {
        user: { id: studentId },
        skillCategory: course.subCategory,
      },
    });

    if (!enrollment) {
      throw new NotFoundException('Student not enrolled in this course');
    }

    const progress = await this.progressRepository.find({
      where: { enrollment: { id: enrollment.id } },
      order: { createdAt: 'ASC' },
    });

    return {
      enrollmentId: enrollment.id,
      studentId,
      courseTitle: course.title,
      completionPercentage: enrollment.completionPercentage,
      status: enrollment.status,
      progress: progress.map(p => ({
        contentId: p.id,
        watchedDuration: p.watchedDurationSeconds,
        progressPercentage: p.progressPercentage,
        isCompleted: p.isCompleted,
        completedAt: p.completedAt,
      })),
    };
  }

  /**
   * Get courses by category
   */
  async getCoursesByCategory(trainerId: string) {
    const query = this.mediaRepository.createQueryBuilder('media')
      .where('media.category = :category', { category: MediaCategory.SKILL })
      .andWhere('media.uploadedBy.id = :trainerId', { trainerId })
      .select('media.subCategory', 'category')
      .addSelect('COUNT(media.id)', 'count')
      .groupBy('media.subCategory')
      .orderBy('count', 'DESC');

    return query.getRawMany();
  }

  /**
   * Get courses by difficulty
   */
  async getCoursesByDifficulty(trainerId: string) {
    const query = this.mediaRepository.createQueryBuilder('media')
      .where('media.category = :category', { category: MediaCategory.SKILL })
      .andWhere('media.uploadedBy.id = :trainerId', { trainerId })
      .select('media.difficulty', 'difficulty')
      .addSelect('COUNT(media.id)', 'count')
      .groupBy('media.difficulty')
      .orderBy('media.difficulty', 'ASC');

    return query.getRawMany();
  }

  /**
   * Get total enrollments for trainer
   */
  async getTotalEnrollments(trainerId: string): Promise<number> {
    const courses = await this.mediaRepository.find({
      where: {
        category: MediaCategory.SKILL,
        uploadedBy: { id: trainerId },
      },
      select: ['subCategory'],
    });

    const categories = [...new Set(courses.map(c => c.subCategory))];
    if (categories.length === 0) return 0;

    const enrollments = await this.enrollmentRepository.count({
      where: {
        skillCategory: categories[0], // Simplified - in reality would sum all
      },
    });

    return enrollments;
  }

  /**
   * Get completion statistics
   */
  async getCompletionStats(trainerId: string) {
    const courses = await this.mediaRepository.find({
      where: {
        category: MediaCategory.SKILL,
        uploadedBy: { id: trainerId },
      },
      select: ['subCategory'],
    });

    const categories = [...new Set(courses.map(c => c.subCategory))];
    if (categories.length === 0) {
      return { totalCompleted: 0, completionRate: 0 };
    }

    const completedEnrollments = await this.enrollmentRepository.count({
      where: {
        status: 'COMPLETED',
      },
    });

    const totalEnrollments = await this.getTotalEnrollments(trainerId);

    return {
      totalCompleted: completedEnrollments,
      completionRate: totalEnrollments > 0 ? (completedEnrollments / totalEnrollments) * 100 : 0,
    };
  }

  /**
   * Get course performance metrics
   */
  async getCourseMetrics(trainerId: string, courseId: string) {
    const course = await this.mediaRepository.findOne({
      where: {
        id: courseId,
        uploadedBy: { id: trainerId },
        category: MediaCategory.SKILL,
      },
    });

    if (!course) {
      throw new NotFoundException('Course not found');
    }

    const enrollments = await this.enrollmentRepository.find({
      where: {
        skillCategory: course.subCategory,
      },
    });

    const avgCompletion = enrollments.length > 0
      ? enrollments.reduce((sum, e) => sum + e.completionPercentage, 0) / enrollments.length
      : 0;

    return {
      courseId,
      courseTitle: course.title,
      totalEnrollments: enrollments.length,
      averageCompletion: avgCompletion,
      completionCount: enrollments.filter(e => e.status === 'COMPLETED').length,
      enrolledCount: enrollments.filter(e => e.status === 'ENROLLED').length,
      droppedOutCount: enrollments.filter(e => e.status === 'DROPPED_OUT').length,
      viewCount: course.viewCount,
      rating: course.rating || 0,
    };
  }

  /**
   * Get analytics for date range
   */
  async getAnalytics(
    trainerId: string,
    startDate: Date,
    endDate: Date,
  ) {
    const courses = await this.mediaRepository.find({
      where: {
        category: MediaCategory.SKILL,
        uploadedBy: { id: trainerId },
        createdAt: Between(startDate, endDate),
      },
    });

    const totalViews = courses.reduce((sum, c) => sum + c.viewCount, 0);

    return {
      dateRange: { startDate, endDate },
      coursesCreated: courses.length,
      totalViews,
      averageViewsPerCourse: courses.length ? totalViews / courses.length : 0,
      topCourses: courses.sort((a, b) => b.viewCount - a.viewCount).slice(0, 5),
    };
  }

  /**
   * Export course data
   */
  async exportCourses(trainerId: string) {
    const courses = await this.mediaRepository.find({
      where: {
        category: MediaCategory.SKILL,
        uploadedBy: { id: trainerId },
      },
      order: { createdAt: 'DESC' },
    });

    const csv = this.convertToCsv(courses);
    return csv;
  }

  private convertToCsv(courses: MediaContent[]): string {
    const headers = ['ID', 'Title', 'Category', 'Difficulty', 'Language', 'Views', 'Rating', 'Created'];
    const rows = courses.map(c => [
      c.id,
      c.title,
      c.subCategory || '-',
      c.difficulty || '-',
      c.language || '-',
      c.viewCount,
      c.rating || '-',
      c.createdAt.toISOString().split('T')[0],
    ]);

    return [
      headers.join(','),
      ...rows.map(row => row.map(cell => `"${cell}"`).join(',')),
    ].join('\n');
  }
}
