import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Query,
  UseGuards,
} from '@nestjs/common';
import { MediaService } from './media.service';
import { CreateMediaDto } from './dto/create-media.dto';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { RolesGuard } from '../common/guards/roles.guard';
import { Roles } from '../common/decorators/roles.decorator';
import { GetUser } from '../common/decorators/get-user.decorator';
import { UserRole } from '../common/enums/user.enum';
import { MediaCategory } from '../common/enums/media.enum';
import { User } from '../users/entities/user.entity';

@Controller('media')
@UseGuards(JwtAuthGuard, RolesGuard)
export class MediaController {
  constructor(private mediaService: MediaService) {}

  @Post()
  @Roles(UserRole.ADMIN)
  async createMedia(
    @Body() createMediaDto: CreateMediaDto,
    @GetUser() user: User,
  ) {
    return this.mediaService.createMedia(createMediaDto, user);
  }

  @Get()
  async getAllMedia(@Query('category') category?: MediaCategory) {
    return this.mediaService.getAllMedia(category);
  }

  @Get(':category/:subCategory')
  async getMediaBySubCategory(
    @Param('category') category: MediaCategory,
    @Param('subCategory') subCategory: string,
  ) {
    return this.mediaService.getMediaBySubCategory(category, subCategory);
  }

  @Post(':id/view')
  async incrementViewCount(@Param('id') id: string) {
    return this.mediaService.incrementViewCount(id);
  }

  @Get('education/class/:classNumber')
  async getByClass(@Param('classNumber') classNumber: number) {
    return this.mediaService.findByClass(Number(classNumber));
  }

  @Get('education/class/:classNumber/subject/:subject')
  async getByClassAndSubject(
    @Param('classNumber') classNumber: number,
    @Param('subject') subject: string,
  ) {
    return this.mediaService.findByClassAndSubject(Number(classNumber), subject);
  }

  @Get('trending')
  async getTrending() {
    return this.mediaService.getTrending();
  }

  @Get('recommended/:userId')
  async getRecommended(@Param('userId') userId: number) {
    return this.mediaService.getRecommended(Number(userId));
  }

  @Post(':mediaId/track-view')
  async trackView(
    @Param('mediaId') mediaId: number,
    @Body() data: { userId: number; watchTime: number },
  ) {
    return this.mediaService.trackView(Number(mediaId), data.userId, data.watchTime);
  }

  @Post(':mediaId/rate')
  async rateVideo(
    @Param('mediaId') mediaId: number,
    @Body() data: { userId: number; rating: number },
  ) {
    return this.mediaService.rateVideo(Number(mediaId), data.userId, data.rating);
  }

  @Post(':mediaId/bookmark')
  async addBookmark(
    @Param('mediaId') mediaId: number,
    @Body() data: { userId: number; timestamp: number; note?: string },
  ) {
    return this.mediaService.addBookmark(Number(mediaId), data);
  }

  @Get(':mediaId/bookmarks')
  async getBookmarks(
    @Param('mediaId') mediaId: number,
    @Query('userId') userId: number,
  ) {
    return this.mediaService.getBookmarks(Number(mediaId), Number(userId));
  }
}
