import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Between, MoreThan, In } from 'typeorm';
import { MediaContent } from '../media/entities/media-content.entity';
import { User } from '../users/entities/user.entity';
import { MediaCategory } from '../common/enums/media.enum';

@Injectable()
export class TeacherDashboardService {
  constructor(
    @InjectRepository(MediaContent)
    private mediaRepository: Repository<MediaContent>,
    @InjectRepository(User)
    private userRepository: Repository<User>,
  ) {}

  /**
   * Get dashboard overview for teacher
   */
  async getDashboardOverview(teacherId: string) {
    const [totalClasses, totalContent, totalViews, recentContent] = await Promise.all([
      this.mediaRepository.count({
        where: {
          category: MediaCategory.EDUCATION,
          uploadedBy: { id: teacherId },
        },
      }),
      this.mediaRepository.count({
        where: {
          category: MediaCategory.EDUCATION,
          uploadedBy: { id: teacherId },
          isActive: true,
        },
      }),
      this.getContentViewStats(teacherId),
      this.mediaRepository.find({
        where: {
          category: MediaCategory.EDUCATION,
          uploadedBy: { id: teacherId },
        },
        order: { createdAt: 'DESC' },
        take: 5,
      }),
    ]);

    return {
      totalClasses,
      activeContent: totalContent,
      totalViews,
      recentContent,
      stats: {
        contentByClass: await this.getContentByClass(teacherId),
        contentBySubject: await this.getContentBySubject(teacherId),
      },
    };
  }

  /**
   * Get all classes managed by teacher
   */
  async getClasses(teacherId: string, page: number = 1, limit: number = 20) {
    const query = this.mediaRepository.createQueryBuilder('media')
      .where('media.category = :category', { category: MediaCategory.EDUCATION })
      .andWhere('media.uploadedBy.id = :teacherId', { teacherId })
      .select('DISTINCT media.ageGroup', 'classLevel')
      .orderBy('media.ageGroup', 'ASC');

    const results = await query.getRawMany();

    return {
      classes: results.map(r => r.classLevel).filter(Boolean),
      total: results.length,
    };
  }

  /**
   * Get all subjects for a class
   */
  async getSubjectsForClass(teacherId: string, classLevel: string) {
    const query = this.mediaRepository.createQueryBuilder('media')
      .where('media.category = :category', { category: MediaCategory.EDUCATION })
      .andWhere('media.uploadedBy.id = :teacherId', { teacherId })
      .andWhere('media.ageGroup = :classLevel', { classLevel })
      .select('DISTINCT media.subject', 'subject')
      .orderBy('media.subject', 'ASC');

    const results = await query.getRawMany();

    return {
      subjects: results.map(r => r.subject).filter(Boolean),
      classLevel,
    };
  }

  /**
   * Get chapters for a subject in a class
   */
  async getChaptersForSubject(
    teacherId: string,
    classLevel: string,
    subject: string,
  ) {
    const content = await this.mediaRepository.find({
      where: {
        category: MediaCategory.EDUCATION,
        uploadedBy: { id: teacherId },
        ageGroup: classLevel,
        subject,
      },
      select: ['id', 'title', 'chapter', 'description', 'createdAt'],
      order: { createdAt: 'DESC' },
    });

    const chapters = Array.from(
      new Set(content.map(c => c.chapter).filter(Boolean)),
    );

    return {
      classLevel,
      subject,
      chapters,
      contentCount: content.length,
      content,
    };
  }

  /**
   * Get content by class
   */
  async getContentByClass(teacherId: string) {
    const query = this.mediaRepository.createQueryBuilder('media')
      .where('media.category = :category', { category: MediaCategory.EDUCATION })
      .andWhere('media.uploadedBy.id = :teacherId', { teacherId })
      .select('media.ageGroup', 'classLevel')
      .addSelect('COUNT(media.id)', 'count')
      .groupBy('media.ageGroup')
      .orderBy('media.ageGroup', 'ASC');

    return query.getRawMany();
  }

  /**
   * Get content by subject
   */
  async getContentBySubject(teacherId: string) {
    const query = this.mediaRepository.createQueryBuilder('media')
      .where('media.category = :category', { category: MediaCategory.EDUCATION })
      .andWhere('media.uploadedBy.id = :teacherId', { teacherId })
      .select('media.subject', 'subject')
      .addSelect('COUNT(media.id)', 'count')
      .groupBy('media.subject')
      .orderBy('count', 'DESC');

    return query.getRawMany();
  }

  /**
   * Get view statistics for teacher content
   */
  async getContentViewStats(teacherId: string) {
    const content = await this.mediaRepository.find({
      where: {
        category: MediaCategory.EDUCATION,
        uploadedBy: { id: teacherId },
      },
      select: ['id', 'viewCount'],
    });

    return content.reduce((sum, c) => sum + c.viewCount, 0);
  }

  /**
   * Get top performing content
   */
  async getTopContent(teacherId: string, limit: number = 10) {
    return this.mediaRepository.find({
      where: {
        category: MediaCategory.EDUCATION,
        uploadedBy: { id: teacherId },
      },
      order: { viewCount: 'DESC' },
      take: limit,
      select: ['id', 'title', 'ageGroup', 'subject', 'viewCount', 'rating', 'createdAt'],
    });
  }

  /**
   * Create lesson plan
   */
  async createLessonPlan(
    teacherId: string,
    lessonData: {
      classLevel: string;
      subject: string;
      chapter: string;
      title: string;
      description: string;
      contentIds: string[];
      duration: number;
      objectives: string[];
    },
  ) {
    // Validate content belongs to teacher
    const content = await this.mediaRepository.find({
      where: {
        id: In(lessonData.contentIds),
        uploadedBy: { id: teacherId },
        category: MediaCategory.EDUCATION,
      },
    });

    if (content.length !== lessonData.contentIds.length) {
      throw new BadRequestException('Some content does not belong to this teacher');
    }

    // Store lesson plan metadata (in real implementation, create LessonPlan entity)
    return {
      id: `lesson-${Date.now()}`,
      teacherId,
      classLevel: lessonData.classLevel,
      subject: lessonData.subject,
      chapter: lessonData.chapter,
      title: lessonData.title,
      description: lessonData.description,
      content,
      duration: lessonData.duration,
      objectives: lessonData.objectives,
      createdAt: new Date(),
    };
  }

  /**
   * Get student progress for content
   */
  async getStudentProgress(teacherId: string, contentId: string) {
    const content = await this.mediaRepository.findOne({
      where: { id: contentId, uploadedBy: { id: teacherId } },
    });

    if (!content) {
      throw new NotFoundException('Content not found');
    }

    // In real implementation, fetch from StudentProgress entity
    return {
      contentId,
      title: content.title,
      totalViews: content.viewCount,
      estimatedStudents: Math.floor(content.viewCount / 3), // Rough estimate
      averageRating: content.rating || 0,
    };
  }

  /**
   * Get analytics for date range
   */
  async getAnalytics(
    teacherId: string,
    startDate: Date,
    endDate: Date,
  ) {
    const content = await this.mediaRepository.find({
      where: {
        category: MediaCategory.EDUCATION,
        uploadedBy: { id: teacherId },
        createdAt: Between(startDate, endDate),
      },
    });

    const totalViews = content.reduce((sum, c) => sum + c.viewCount, 0);

    return {
      dateRange: { startDate, endDate },
      contentCreated: content.length,
      totalViews,
      averageViewsPerContent: content.length ? totalViews / content.length : 0,
      topContent: content.sort((a, b) => b.viewCount - a.viewCount).slice(0, 5),
    };
  }

  /**
   * Export content data
   */
  async exportContent(teacherId: string) {
    const content = await this.mediaRepository.find({
      where: {
        category: MediaCategory.EDUCATION,
        uploadedBy: { id: teacherId },
      },
      order: { createdAt: 'DESC' },
    });

    const csv = this.convertToCsv(content);
    return csv;
  }

  private convertToCsv(content: MediaContent[]): string {
    const headers = ['ID', 'Title', 'Class', 'Subject', 'Chapter', 'Views', 'Rating', 'Created'];
    const rows = content.map(c => [
      c.id,
      c.title,
      c.ageGroup || '-',
      c.subject || '-',
      c.chapter || '-',
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
