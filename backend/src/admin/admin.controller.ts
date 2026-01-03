import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  Query,
  UseGuards,
  BadRequestException,
  NotFoundException,
  Res,
  UseInterceptors,
  UploadedFile,
  UploadedFiles,
} from '@nestjs/common';
import { FileInterceptor, FilesInterceptor } from '@nestjs/platform-express';
import { Response } from 'express';
import { AdminService } from './admin.service';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { RolesGuard } from '../common/guards/roles.guard';
import { Roles } from '../common/decorators/roles.decorator';
import { GetUser } from '../common/decorators/get-user.decorator';
import { UserRole } from '../common/enums/user.enum';
import { User } from '../users/entities/user.entity';
import { CreateMediaDto } from '../media/dto/create-media.dto';
import { CreateMediaWithUploadDto } from '../media/dto/create-media-with-upload.dto';
import { MediaCategory } from '../common/enums/media.enum';

@Controller('admin')
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(UserRole.ADMIN)
export class AdminController {
  constructor(private adminService: AdminService) {}

  // ==================== MEDIA MANAGEMENT ====================

  /**
   * Upload media content across all 5 domains
   * Domains: MEDICAL, EDUCATION, SKILLS, NUTRITION, EVENTS
   */
  @Post('media/upload')
  async uploadMedia(
    @Body() createMediaDto: CreateMediaDto,
    @GetUser() user: User,
  ) {
    return this.adminService.uploadMedia(createMediaDto, user);
  }

  /**
   * Upload media with file
   * Supports: Video files for all professions (Skills, Health, Nutrition)
   * POST /admin/media/upload-file
   */
  @Post('media/upload-file')
  @UseInterceptors(FileInterceptor('file'))
  async uploadMediaWithFile(
    @UploadedFile() file: Express.Multer.File,
    @Body() mediaData: CreateMediaWithUploadDto,
    @GetUser() user: User,
  ) {
    return this.adminService.uploadMediaWithFile(file, mediaData, user);
  }

  /**
   * Upload media with both file and thumbnail
   * POST /admin/media/upload-with-thumbnail
   */
  @Post('media/upload-with-thumbnail')
  @UseInterceptors(FilesInterceptor('files'))
  async uploadMediaWithThumbnail(
    @UploadedFiles() files: Express.Multer.File[],
    @Body() mediaData: CreateMediaWithUploadDto,
    @GetUser() user: User,
  ) {
    return this.adminService.uploadMediaWithThumbnail(files, mediaData, user);
  }

  /**
   * Bulk upload multiple media files
   * POST /admin/media/bulk-upload
   */
  @Post('media/bulk-upload')
  @UseInterceptors(FilesInterceptor('files', 10))
  async bulkUploadMedia(
    @UploadedFiles() files: Express.Multer.File[],
    @Body() mediaDataList: CreateMediaWithUploadDto[],
    @GetUser() user: User,
  ) {
    return this.adminService.bulkUploadMediaFiles(files, mediaDataList, user);
  }

  /**
   * Get all media content with optional filtering
   */
  @Get('media')
  async getAllMedia(
    @Query('category') category?: MediaCategory,
    @Query('subCategory') subCategory?: string,
    @Query('isActive') isActive?: boolean,
    @Query('page') page: number = 1,
    @Query('limit') limit: number = 20,
  ) {
    return this.adminService.getAllMediaWithFilters(
      category,
      subCategory,
      isActive,
      page,
      limit,
    );
  }

  /**
   * Get media by ID for editing
   */
  @Get('media/:id')
  async getMediaById(@Param('id') id: string) {
    return this.adminService.getMediaById(id);
  }

  /**
   * Update media content
   */
  @Put('media/:id')
  async updateMedia(
    @Param('id') id: string,
    @Body() updateMediaDto: Partial<CreateMediaDto>,
  ) {
    return this.adminService.updateMedia(id, updateMediaDto);
  }

  /**
   * Delete media content (soft delete - sets isActive to false)
   */
  @Delete('media/:id')
  async deleteMedia(@Param('id') id: string) {
    return this.adminService.deleteMedia(id);
  }

  /**
   * Permanently delete media
   */
  @Delete('media/:id/permanent')
  async permanentlyDeleteMedia(@Param('id') id: string) {
    return this.adminService.permanentlyDeleteMedia(id);
  }

  /**
   * Get media by category with pagination
   */
  @Get('media/category/:category')
  async getMediaByCategory(
    @Param('category') category: MediaCategory,
    @Query('page') page: number = 1,
    @Query('limit') limit: number = 20,
  ) {
    return this.adminService.getMediaByCategory(category, page, limit);
  }

  /**
   * Add tags to media (for Post-COVID, Skill topics, etc.)
   */
  @Post('media/:id/tags')
  async addTags(@Param('id') id: string, @Body() { tags }: { tags: string[] }) {
    return this.adminService.addTagsToMedia(id, tags);
  }

  /**
   * Get all tags available for tagging
   */
  @Get('tags/available')
  async getAvailableTags() {
    return this.adminService.getAvailableTags();
  }

  // ==================== EDUCATION CONTENT ====================

  /**
   * Get all NCERT books and resources
   */
  @Get('education/books')
  async getEducationBooks(@Query('classNumber') classNumber?: number) {
    return this.adminService.getEducationBooks(classNumber);
  }

  /**
   * Add NCERT book or resource
   */
  @Post('education/books')
  async addEducationBook(@Body() bookData: any) {
    return this.adminService.addEducationBook(bookData);
  }

  /**
   * Get education content by class and subject
   */
  @Get('education/:classNumber/:subject')
  async getEducationContent(
    @Param('classNumber') classNumber: number,
    @Param('subject') subject: string,
  ) {
    return this.adminService.getEducationContentByClassAndSubject(
      classNumber,
      subject,
    );
  }

  // ==================== SKILLS & TRAINING ====================

  /**
   * Get all skill categories: Bamboo, Honeybee, Artisan, Jutework, Macrame, etc.
   */
  @Get('skills/categories')
  async getSkillCategories() {
    return this.adminService.getSkillCategories();
  }

  /**
   * Add new skill category
   */
  @Post('skills/categories')
  async addSkillCategory(
    @Body() { name, description }: { name: string; description: string },
  ) {
    return this.adminService.addSkillCategory(name, description);
  }

  /**
   * Get skills content
   */
  @Get('skills/:categoryId')
  async getSkillsContent(@Param('categoryId') categoryId: string) {
    return this.adminService.getSkillsContent(categoryId);
  }

  // ==================== NUTRITION & WELLNESS ====================

  /**
   * Get all nutrition content
   */
  @Get('nutrition')
  async getNutritionContent(
    @Query('type') type?: string, // 'diet-plan', 'recipe', 'post-covid', 'wellness'
  ) {
    return this.adminService.getNutritionContent(type);
  }

  /**
   * Add nutrition content
   */
  @Post('nutrition')
  async addNutritionContent(@Body() nutritionData: any) {
    return this.adminService.addNutritionContent(nutritionData);
  }

  /**
   * Get Post-COVID specific content
   */
  @Get('nutrition/post-covid')
  async getPostCovidContent() {
    return this.adminService.getPostCovidContent();
  }

  // ==================== EVENTS MANAGEMENT ====================

  /**
   * Get all events
   */
  @Get('events')
  async getAllEvents(
    @Query('upcoming') upcoming?: boolean,
    @Query('page') page: number = 1,
    @Query('limit') limit: number = 20,
  ) {
    return this.adminService.getAllEvents(upcoming, page, limit);
  }

  /**
   * Create new event
   */
  @Post('events')
  async createEvent(@Body() eventData: any) {
    return this.adminService.createEvent(eventData);
  }

  /**
   * Update event
   */
  @Put('events/:id')
  async updateEvent(@Param('id') id: string, @Body() eventData: any) {
    return this.adminService.updateEvent(id, eventData);
  }

  /**
   * Delete event
   */
  @Delete('events/:id')
  async deleteEvent(@Param('id') id: string) {
    return this.adminService.deleteEvent(id);
  }

  // ==================== ANALYTICS & STATISTICS ====================

  /**
   * Get dashboard statistics
   */
  @Get('dashboard/stats')
  async getDashboardStats() {
    return this.adminService.getDashboardStats();
  }

  /**
   * Get media analytics (views, ratings, engagement)
   */
  @Get('analytics/media')
  async getMediaAnalytics(
    @Query('startDate') startDate?: string,
    @Query('endDate') endDate?: string,
  ) {
    return this.adminService.getMediaAnalytics(startDate, endDate);
  }

  /**
   * Get user activity analytics
   */
  @Get('analytics/users')
  async getUserAnalytics() {
    return this.adminService.getUserAnalytics();
  }

  /**
   * Get content engagement by category
   */
  @Get('analytics/engagement/:category')
  async getEngagementByCategory(@Param('category') category: MediaCategory) {
    return this.adminService.getEngagementByCategory(category);
  }

  // ==================== USER MANAGEMENT ====================

  /**
   * Get all users with role filtering
   */
  @Get('users')
  async getAllUsers(
    @Query('role') role?: UserRole,
    @Query('isActive') isActive?: boolean,
    @Query('page') page: number = 1,
    @Query('limit') limit: number = 20,
  ) {
    return this.adminService.getAllUsers(role, isActive, page, limit);
  }

  /**
   * Activate/Deactivate user
   */
  @Put('users/:id/status')
  async updateUserStatus(
    @Param('id') id: string,
    @Body() { isActive }: { isActive: boolean },
  ) {
    return this.adminService.updateUserStatus(id, isActive);
  }

  /**
   * Get user details
   */
  @Get('users/:id')
  async getUserDetails(@Param('id') id: string) {
    return this.adminService.getUserDetails(id);
  }

  // ==================== CONTENT BULK OPERATIONS ====================
  /**
   * Export media data as CSV
   */
  @Get('media/export/csv')
  async exportMediaCsv(@Res() res: Response) {
    const csvData = await this.adminService.exportMediaCsv();
    res.header('Content-Type', 'text/csv');
    res.header('Content-Disposition', 'attachment; filename="media_export.csv"');
    res.send(csvData);
  }

  /**
   * Get content modification history/audit log
   */
  @Get('audit-log')
  async getAuditLog(
    @Query('entityType') entityType?: string,
    @Query('action') action?: string,
    @Query('page') page: number = 1,
    @Query('limit') limit: number = 20,
  ) {
    return this.adminService.getAuditLog(entityType, action, page, limit);
  }
}
