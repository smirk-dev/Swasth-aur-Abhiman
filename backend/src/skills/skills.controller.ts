import {
  Controller,
  Get,
  Param,
  Query,
  UseGuards,
} from '@nestjs/common';
import { SkillsService } from './skills.service';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';

@Controller('skills')
@UseGuards(JwtAuthGuard)
export class SkillsController {
  constructor(private skillsService: SkillsService) {}

  // ==================== CATEGORIES ====================

  /**
   * Get all available skill categories
   * GET /skills/categories
   */
  @Get('categories')
  async getSkillCategories() {
    return this.skillsService.getSkillCategories();
  }

  /**
   * Get specific category details
   * GET /skills/categories/:categoryId
   */
  @Get('categories/:categoryId')
  async getSkillCategory(@Param('categoryId') categoryId: string) {
    return this.skillsService.getSkillCategoryById(categoryId);
  }

  // ==================== CONTENT ====================

  /**
   * Get content for a specific skill category
   * GET /skills/:categoryId/content?page=1&limit=20
   */
  @Get(':categoryId/content')
  async getSkillContent(
    @Param('categoryId') categoryId: string,
    @Query('page') page: number = 1,
    @Query('limit') limit: number = 20,
  ) {
    return this.skillsService.getSkillContent(categoryId, page, limit);
  }

  /**
   * Search skill content
   * GET /skills/search?query=bamboo&categoryId=bamboo-training
   */
  @Get('search')
  async searchSkillContent(
    @Query('query') query: string,
    @Query('categoryId') categoryId?: string,
  ) {
    return this.skillsService.searchSkillContent(query, categoryId);
  }

  /**
   * Get trending skill content
   * GET /skills/trending?limit=10
   */
  @Get('trending')
  async getTrendingSkillContent(@Query('limit') limit: number = 10) {
    return this.skillsService.getTrendingSkillContent(limit);
  }

  /**
   * Get featured skills with top course
   * GET /skills/featured
   */
  @Get('featured')
  async getFeaturedSkills() {
    return this.skillsService.getFeaturedSkills();
  }

  // ==================== DIFFICULTY ====================

  /**
   * Get content by difficulty level
   * GET /skills/:categoryId/difficulty/:difficulty?page=1&limit=20
   */
  @Get(':categoryId/difficulty/:difficulty')
  async getContentByDifficulty(
    @Param('categoryId') categoryId: string,
    @Param('difficulty') difficulty: string,
    @Query('page') page: number = 1,
    @Query('limit') limit: number = 20,
  ) {
    return this.skillsService.getContentByDifficulty(
      categoryId,
      difficulty,
      page,
      limit,
    );
  }

  /**
   * Get available difficulty levels for a category
   * GET /skills/:categoryId/difficulties
   */
  @Get(':categoryId/difficulties')
  async getDifficultyLevels(@Param('categoryId') categoryId: string) {
    return this.skillsService.getDifficultyLevels(categoryId);
  }

  // ==================== LEARNING PATH ====================

  /**
   * Get recommended learning path
   * GET /skills/:categoryId/learning-path
   */
  @Get(':categoryId/learning-path')
  async getLearningPath(@Param('categoryId') categoryId: string) {
    return this.skillsService.getLearningPath(categoryId);
  }

  /**
   * Get next recommended course
   * GET /skills/:categoryId/next?completedVideos=id1,id2,id3
   */
  @Get(':categoryId/next')
  async getNextRecommendedCourse(
    @Param('categoryId') categoryId: string,
    @Query('completedVideos') completedVideos?: string,
  ) {
    const completed = completedVideos ? completedVideos.split(',') : [];
    return this.skillsService.getNextRecommendedCourse(categoryId, completed);
  }
}
