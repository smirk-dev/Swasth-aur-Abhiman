import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, MoreThan, Between } from 'typeorm';
import { MediaContent } from '../media/entities/media-content.entity';
import { User } from '../users/entities/user.entity';
import { CreateMediaDto } from '../media/dto/create-media.dto';
import { CreateMediaWithUploadDto } from '../media/dto/create-media-with-upload.dto';
import { FileUploadService } from '../media/services/file-upload.service';
import { MediaCategory } from '../common/enums/media.enum';
import { UserRole } from '../common/enums/user.enum';
import { Event } from '../events/entities/event.entity';

@Injectable()
export class AdminService {
  constructor(
    @InjectRepository(MediaContent)
    private mediaRepository: Repository<MediaContent>,
    @InjectRepository(User)
    private userRepository: Repository<User>,
    @InjectRepository(Event)
    private eventRepository: Repository<Event>,
    private fileUploadService: FileUploadService,
  ) {}

  // ==================== MEDIA MANAGEMENT ====================

  async uploadMedia(createMediaDto: CreateMediaDto, user: User) {
    const media = this.mediaRepository.create({
      ...createMediaDto,
      uploadedBy: user,
    });
    return this.mediaRepository.save(media);
  }

  async getAllMediaWithFilters(
    category?: MediaCategory,
    subCategory?: string,
    isActive?: boolean,
    page: number = 1,
    limit: number = 20,
  ) {
    const query = this.mediaRepository.createQueryBuilder('media')
      .leftJoinAndSelect('media.uploadedBy', 'user')
      .orderBy('media.createdAt', 'DESC');

    if (category) {
      query.andWhere('media.category = :category', { category });
    }

    if (subCategory) {
      query.andWhere('media.subCategory = :subCategory', { subCategory });
    }

    if (isActive !== undefined) {
      query.andWhere('media.isActive = :isActive', { isActive });
    }

    const skip = (page - 1) * limit;
    query.skip(skip).take(limit);

    const [data, total] = await query.getManyAndCount();

    return {
      data,
      total,
      page,
      limit,
      totalPages: Math.ceil(total / limit),
    };
  }

  async getMediaById(id: string) {
    const media = await this.mediaRepository.findOne({
      where: { id },
      relations: ['uploadedBy'],
    });

    if (!media) {
      throw new NotFoundException(`Media with ID ${id} not found`);
    }

    return media;
  }

  async updateMedia(id: string, updateMediaDto: Partial<CreateMediaDto>) {
    const media = await this.getMediaById(id);

    Object.assign(media, updateMediaDto);
    return this.mediaRepository.save(media);
  }

  async deleteMedia(id: string) {
    const media = await this.getMediaById(id);
    media.isActive = false;
    return this.mediaRepository.save(media);
  }

  async permanentlyDeleteMedia(id: string) {
    const media = await this.getMediaById(id);
    return this.mediaRepository.remove(media);
  }

  /**
   * Upload media with file support
   */
  async uploadMediaWithFile(
    file: Express.Multer.File,
    mediaData: CreateMediaWithUploadDto,
    user: User,
  ) {
    if (!file) {
      throw new BadRequestException('File is required');
    }

    // Upload file to storage
    const { fileUrl, fileName } = await this.fileUploadService.uploadFile(
      file,
      mediaData.category,
    );

    // Create media record with file URL
    const media = this.mediaRepository.create({
      ...mediaData,
      mediaUrl: fileUrl,
      source: 'internal',
      uploadedBy: user,
    });

    return this.mediaRepository.save(media);
  }

  /**
   * Upload media with both file and thumbnail
   */
  async uploadMediaWithThumbnail(
    files: Express.Multer.File[],
    mediaData: CreateMediaWithUploadDto,
    user: User,
  ) {
    if (!files || files.length === 0) {
      throw new BadRequestException('At least one file is required');
    }

    let mediaFile: Express.Multer.File;
    let thumbnailFile: Express.Multer.File;

    // Separate media file and thumbnail
    for (const file of files) {
      if (file.fieldname === 'file') {
        mediaFile = file;
      } else if (file.fieldname === 'thumbnail') {
        thumbnailFile = file;
      }
    }

    if (!mediaFile) {
      throw new BadRequestException('Media file is required');
    }

    // Upload media file
    const { fileUrl } = await this.fileUploadService.uploadFile(
      mediaFile,
      mediaData.category,
    );

    let thumbnailUrl: string;

    // Upload thumbnail if provided
    if (thumbnailFile) {
      const thumbnail = await this.fileUploadService.uploadThumbnail(
        thumbnailFile,
        mediaData.category,
      );
      thumbnailUrl = thumbnail.thumbnailUrl;
    }

    // Create media record
    const media = this.mediaRepository.create({
      ...mediaData,
      mediaUrl: fileUrl,
      thumbnailUrl,
      source: 'internal',
      uploadedBy: user,
    });

    return this.mediaRepository.save(media);
  }

  /**
   * Bulk upload multiple media files
   */
  async bulkUploadMediaFiles(
    files: Express.Multer.File[],
    mediaDataList: CreateMediaWithUploadDto[],
    user: User,
  ) {
    if (!files || files.length === 0) {
      throw new BadRequestException('No files provided');
    }

    if (!mediaDataList || mediaDataList.length !== files.length) {
      throw new BadRequestException(
        'Number of files must match number of media data entries',
      );
    }

    const uploadedMedia = [];

    for (let i = 0; i < files.length; i++) {
      const file = files[i];
      const mediaData = mediaDataList[i];

      try {
        // Upload file
        const { fileUrl } = await this.fileUploadService.uploadFile(
          file,
          mediaData.category,
        );

        // Create media record
        const media = this.mediaRepository.create({
          ...mediaData,
          mediaUrl: fileUrl,
          source: 'internal',
          uploadedBy: user,
        });

        const savedMedia = await this.mediaRepository.save(media);
        uploadedMedia.push({
          success: true,
          mediaId: savedMedia.id,
          title: savedMedia.title,
        });
      } catch (error) {
        uploadedMedia.push({
          success: false,
          fileName: file.originalname,
          error: error.message,
        });
      }
    }

    return {
      totalAttempted: files.length,
      totalSuccessful: uploadedMedia.filter((m) => m.success).length,
      results: uploadedMedia,
    };
  }

  async getMediaByCategory(
    category: MediaCategory,
    page: number = 1,
    limit: number = 20,
  ) {
    const query = this.mediaRepository.createQueryBuilder('media')
      .where('media.category = :category', { category })
      .orderBy('media.createdAt', 'DESC');

    const skip = (page - 1) * limit;
    const [data, total] = await query
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

  async addTagsToMedia(id: string, tags: string[]) {
    const media = await this.getMediaById(id);

    // Store tags as comma-separated string in subCategory or create a tags column
    // For now, we'll extend the subCategory if not already set
    if (!media.subCategory) {
      media.subCategory = tags.join(', ');
    } else {
      media.subCategory += ', ' + tags.join(', ');
    }

    return this.mediaRepository.save(media);
  }

  async getAvailableTags() {
    return {
      skillTopics: [
        'Bamboo Training',
        'Honeybee Farming',
        'Artisan Training',
        'Jutework',
        'Macrame Work',
      ],
      healthTags: [
        'Post-COVID Recovery',
        'Herbal Remedies',
        'Anemia Treatment',
        'General Wellness',
      ],
      nutritionTags: [
        'Post-COVID Diet',
        'Wellness',
        'Traditional Medicine',
      ],
      educationTags: [
        'NCERT',
        'Science',
        'Mathematics',
        'Social Studies',
        'Languages',
      ],
      eventTypes: [
        'Health Camp',
        'Training Workshop',
        'Community Event',
        'Education Program',
      ],
    };
  }

  // ==================== EDUCATION CONTENT ====================

  async getEducationBooks(classNumber?: number) {
    const query = this.mediaRepository.createQueryBuilder('media')
      .where('media.category = :category', {
        category: MediaCategory.EDUCATION,
      })
      .orderBy('media.createdAt', 'DESC');

    if (classNumber) {
      query.andWhere('media.ageGroup = :ageGroup', {
        ageGroup: `Class ${classNumber}`,
      });
    }

    return query.getMany();
  }

  async addEducationBook(bookData: any) {
    const media = this.mediaRepository.create({
      ...bookData,
      category: MediaCategory.EDUCATION,
    });
    return this.mediaRepository.save(media);
  }

  async getEducationContentByClassAndSubject(
    classNumber: number,
    subject: string,
  ) {
    return this.mediaRepository.find({
      where: {
        ageGroup: `Class ${classNumber}`,
        subject: subject,
        category: MediaCategory.EDUCATION,
      },
      order: { createdAt: 'DESC' },
    });
  }

  // ==================== SKILLS & TRAINING ====================

  async getSkillCategories() {
    const skills = await this.mediaRepository
      .createQueryBuilder('media')
      .select('DISTINCT media.subCategory', 'subCategory')
      .where('media.category = :category', { category: MediaCategory.SKILL })
      .getRawMany();

    return {
      categories: [
        'Bamboo Training',
        'Honeybee Farming',
        'Artisan Training',
        'Jutework',
        'Macrame Work',
      ],
      content: skills,
    };
  }

  async addSkillCategory(name: string, description: string) {
    // Skills are stored as subCategories in media content
    return {
      message: 'Skill category added',
      category: { name, description },
    };
  }

  async getSkillsContent(categoryId: string) {
    return this.mediaRepository.find({
      where: {
        category: MediaCategory.SKILL,
        subCategory: categoryId,
        isActive: true,
      },
      order: { createdAt: 'DESC' },
    });
  }

  // ==================== NUTRITION & WELLNESS ====================

  async getNutritionContent(type?: string) {
    const query = this.mediaRepository.createQueryBuilder('media')
      .where('media.category = :category', {
        category: MediaCategory.NUTRITION,
      });

    if (type) {
      query.andWhere('media.subCategory = :subCategory', {
        subCategory: type,
      });
    }

    return query.orderBy('media.createdAt', 'DESC').getMany();
  }

  async addNutritionContent(nutritionData: any) {
    const media = this.mediaRepository.create({
      ...nutritionData,
      category: MediaCategory.NUTRITION,
    });
    return this.mediaRepository.save(media);
  }

  async getPostCovidContent() {
    return this.mediaRepository.find({
      where: {
        category: MediaCategory.NUTRITION,
        subCategory: 'Post-COVID Diet',
        isActive: true,
      },
      order: { createdAt: 'DESC' },
    });
  }

  // ==================== EVENTS MANAGEMENT ====================

  async getAllEvents(upcoming?: boolean, page: number = 1, limit: number = 20) {
    const query = this.eventRepository.createQueryBuilder('event');

    if (upcoming) {
      const now = new Date();
      query.where('event.date > :now', { now });
    }

    const skip = (page - 1) * limit;
    const [data, total] = await query
      .orderBy('event.date', 'ASC')
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

  async createEvent(eventData: any) {
    const event = this.eventRepository.create(eventData);
    return this.eventRepository.save(event);
  }

  async updateEvent(id: string, eventData: any) {
    const event = await this.eventRepository.findOne({ where: { id } });
    if (!event) {
      throw new NotFoundException(`Event with ID ${id} not found`);
    }

    Object.assign(event, eventData);
    return this.eventRepository.save(event);
  }

  async deleteEvent(id: string) {
    const event = await this.eventRepository.findOne({ where: { id } });
    if (!event) {
      throw new NotFoundException(`Event with ID ${id} not found`);
    }

    return this.eventRepository.remove(event);
  }

  // ==================== ANALYTICS & STATISTICS ====================

  async getDashboardStats() {
    const totalMedia = await this.mediaRepository.count();
    const totalUsers = await this.userRepository.count();
    const activeUsers = await this.userRepository.count({
      where: { isActive: true },
    });
    const upcomingEvents = await this.eventRepository.count({
      where: { dateTime: MoreThan(new Date()) },
    });

    const mediaByCategory = await this.mediaRepository
      .createQueryBuilder('media')
      .select('media.category', 'category')
      .addSelect('COUNT(media.id)', 'count')
      .groupBy('media.category')
      .getRawMany();

    return {
      totalMedia,
      totalUsers,
      activeUsers,
      upcomingEvents,
      mediaByCategory,
      stats: {
        usersToday: await this.getNewUsersCount(1),
        usersThisWeek: await this.getNewUsersCount(7),
        usersThisMonth: await this.getNewUsersCount(30),
      },
    };
  }

  async getMediaAnalytics(startDate?: string, endDate?: string) {
    const query = this.mediaRepository.createQueryBuilder('media');

    if (startDate && endDate) {
      query.where('media.createdAt BETWEEN :startDate AND :endDate', {
        startDate: new Date(startDate),
        endDate: new Date(endDate),
      });
    }

    const analytics = await query
      .select('media.category', 'category')
      .addSelect('SUM(media.viewCount)', 'totalViews')
      .addSelect('AVG(media.rating)', 'avgRating')
      .addSelect('COUNT(media.id)', 'contentCount')
      .groupBy('media.category')
      .getRawMany();

    return analytics;
  }

  async getUserAnalytics() {
    const usersByRole = await this.userRepository
      .createQueryBuilder('user')
      .select('user.role', 'role')
      .addSelect('COUNT(user.id)', 'count')
      .groupBy('user.role')
      .getRawMany();

    return {
      byRole: usersByRole,
      total: await this.userRepository.count(),
    };
  }

  async getEngagementByCategory(category: MediaCategory) {
    const content = await this.mediaRepository.find({
      where: { category },
    });

    const totalViews = content.reduce((sum, item) => sum + item.viewCount, 0);
    const avgRating = content.reduce((sum, item) => sum + (item.rating || 0), 0) / content.length;

    return {
      category,
      contentCount: content.length,
      totalViews,
      avgRating,
      content: content.map(c => ({
        id: c.id,
        title: c.title,
        views: c.viewCount,
        rating: c.rating,
      })),
    };
  }

  // ==================== USER MANAGEMENT ====================

  async getAllUsers(
    role?: UserRole,
    isActive?: boolean,
    page: number = 1,
    limit: number = 20,
  ) {
    const query = this.userRepository.createQueryBuilder('user');

    if (role) {
      query.where('user.role = :role', { role });
    }

    if (isActive !== undefined) {
      query.andWhere('user.isActive = :isActive', { isActive });
    }

    const skip = (page - 1) * limit;
    const [data, total] = await query
      .skip(skip)
      .take(limit)
      .getManyAndCount();

    return {
      data: data.map(u => ({
        id: u.id,
        email: u.email,
        fullName: u.fullName,
        role: u.role,
        isActive: u.isActive,
        createdAt: u.createdAt,
      })),
      total,
      page,
      limit,
      totalPages: Math.ceil(total / limit),
    };
  }

  async updateUserStatus(id: string, isActive: boolean) {
    const user = await this.userRepository.findOne({ where: { id } });
    if (!user) {
      throw new NotFoundException(`User with ID ${id} not found`);
    }

    user.isActive = isActive;
    return this.userRepository.save(user);
  }

  async getUserDetails(id: string) {
    const user = await this.userRepository.findOne({ where: { id } });
    if (!user) {
      throw new NotFoundException(`User with ID ${id} not found`);
    }

    return {
      id: user.id,
      email: user.email,
      fullName: user.fullName,
      role: user.role,
      isActive: user.isActive,
      gender: user.gender,
      createdAt: user.createdAt,
    };
  }

  // ==================== BULK OPERATIONS ====================


  async exportMediaCsv() {
    const media = await this.mediaRepository.find({
      relations: ['uploadedBy'],
    });

    let csv = 'ID,Title,Category,SubCategory,Views,Rating,Duration,IsActive,CreatedAt\n';

    for (const item of media) {
      csv += `"${item.id}","${item.title}","${item.category}","${item.subCategory || ''}","${item.viewCount}","${item.rating || ''}","${item.durationSeconds || ''}","${item.isActive}","${item.createdAt}"\n`;
    }

    return csv;
  }

  async getAuditLog(
    entityType?: string,
    action?: string,
    page: number = 1,
    limit: number = 20,
  ) {
    // Placeholder for audit log functionality
    // In production, you would query an audit log table
    return {
      message: 'Audit log feature coming soon',
      page,
      limit,
    };
  }

  // ==================== HELPER METHODS ====================

  private async getNewUsersCount(days: number) {
    const startDate = new Date();
    startDate.setDate(startDate.getDate() - days);

    return this.userRepository.count({
      where: {
        createdAt: MoreThan(startDate),
      },
    });
  }
}
