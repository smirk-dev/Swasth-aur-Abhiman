import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, MoreThan } from 'typeorm';
import { MediaContent } from './entities/media-content.entity';
import { CreateMediaDto } from './dto/create-media.dto';
import { MediaCategory } from '../common/enums/media.enum';
import { User } from '../users/entities/user.entity';
import { AnalyticsService } from '../analytics/analytics.service';

@Injectable()
export class MediaService {
  constructor(
    @InjectRepository(MediaContent)
    private mediaRepository: Repository<MediaContent>,
    private analyticsService: AnalyticsService,
  ) {}

  async createMedia(createMediaDto: CreateMediaDto, user: User) {
    const media = this.mediaRepository.create({
      ...createMediaDto,
      uploadedBy: user,
    });

    return this.mediaRepository.save(media);
  }

  async getAllMedia(category?: MediaCategory) {
    const query = this.mediaRepository.createQueryBuilder('media')
      .where('media.isActive = :isActive', { isActive: true })
      .orderBy('media.createdAt', 'DESC');

    if (category) {
      query.andWhere('media.category = :category', { category });
    }

    return query.getMany();
  }

  async getMediaBySubCategory(category: MediaCategory, subCategory: string) {
    return this.mediaRepository.find({
      where: { category, subCategory, isActive: true },
      order: { createdAt: 'DESC' },
    });
  }

  async incrementViewCount(mediaId: string) {
    const media = await this.mediaRepository.findOne({ where: { id: mediaId } });
    if (media) {
      media.viewCount += 1;
      return this.mediaRepository.save(media);
    }
    return null;
  }

  async findByClass(classNumber: number) {
    return this.mediaRepository.find({
      where: {
        ageGroup: `Class ${classNumber}`,
        category: 'EDUCATION',
      },
      order: { viewCount: 'DESC' },
    });
  }

  async findByClassAndSubject(classNumber: number, subject: string) {
    return this.mediaRepository.find({
      where: {
        ageGroup: `Class ${classNumber}`,
        subject: subject,
        category: 'EDUCATION',
      },
      order: { createdAt: 'DESC' },
    });
  }

  async getTrending() {
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

    return this.mediaRepository.find({
      where: {
        createdAt: MoreThan(thirtyDaysAgo),
      },
      order: { viewCount: 'DESC' },
      take: 20,
    });
  }

  async getRecommended(userId: number) {
    // Simple recommendation based on watch history
    // TODO: Implement more sophisticated algorithm
    return this.mediaRepository.find({
      order: { viewCount: 'DESC', rating: 'DESC' },
      take: 10,
    });
  }

  async trackView(mediaId: number, userId: number, watchTime: number) {
    // Increment view count
    await this.mediaRepository.increment({ id: String(mediaId) }, 'viewCount', 1);

    // Save analytics
    await this.analyticsService.trackWatch(mediaId, userId, watchTime);

    return { success: true };
  }

  async rateVideo(mediaId: number, userId: number, rating: number) {
    // Calculate new average rating
    const media = await this.mediaRepository.findOne({ where: { id: String(mediaId) } });
    if (!media) return { success: false, message: 'Media not found' };

    if (!media.rating) {
      media.rating = rating;
    } else {
      media.rating = Number(((media.rating + rating) / 2).toFixed(1));
    }

    await this.mediaRepository.save(media);
    return { success: true };
  }

  async addBookmark(mediaId: number, data: any) {
    // Save bookmark using analytics service
    const { userId, timestamp, note } = data;
    await this.analyticsService.addBookmark(userId, mediaId, timestamp, note);
    return { success: true };
  }

  async getBookmarks(mediaId: number, userId: number) {
    return this.analyticsService.getBookmarksForUserMedia(userId, mediaId);
  }
}
