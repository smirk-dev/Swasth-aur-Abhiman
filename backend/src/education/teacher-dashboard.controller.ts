import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Query,
  UseGuards,
  Res,
} from '@nestjs/common';
import { Response } from 'express';
import { TeacherDashboardService } from './teacher-dashboard.service';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { RolesGuard } from '../common/guards/roles.guard';
import { Roles } from '../common/decorators/roles.decorator';
import { GetUser } from '../common/decorators/get-user.decorator';
import { UserRole } from '../common/enums/user.enum';
import { User } from '../users/entities/user.entity';

@Controller('teacher')
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(UserRole.TEACHER)
export class TeacherDashboardController {
  constructor(private teacherDashboardService: TeacherDashboardService) {}

  /**
   * Get teacher dashboard overview
   * GET /teacher/dashboard
   */
  @Get('dashboard')
  async getDashboardOverview(@GetUser() user: User) {
    return this.teacherDashboardService.getDashboardOverview(user.id);
  }

  /**
   * Get all classes managed by teacher
   * GET /teacher/classes
   */
  @Get('classes')
  async getClasses(
    @GetUser() user: User,
    @Query('page') page: number = 1,
    @Query('limit') limit: number = 20,
  ) {
    return this.teacherDashboardService.getClasses(user.id, page, limit);
  }

  /**
   * Get subjects for a class
   * GET /teacher/classes/:classLevel/subjects
   */
  @Get('classes/:classLevel/subjects')
  async getSubjectsForClass(
    @GetUser() user: User,
    @Param('classLevel') classLevel: string,
  ) {
    return this.teacherDashboardService.getSubjectsForClass(user.id, classLevel);
  }

  /**
   * Get chapters for a subject
   * GET /teacher/classes/:classLevel/subjects/:subject/chapters
   */
  @Get('classes/:classLevel/subjects/:subject/chapters')
  async getChaptersForSubject(
    @GetUser() user: User,
    @Param('classLevel') classLevel: string,
    @Param('subject') subject: string,
  ) {
    return this.teacherDashboardService.getChaptersForSubject(
      user.id,
      classLevel,
      subject,
    );
  }

  /**
   * Get top performing content
   * GET /teacher/content/top
   */
  @Get('content/top')
  async getTopContent(
    @GetUser() user: User,
    @Query('limit') limit: number = 10,
  ) {
    return this.teacherDashboardService.getTopContent(user.id, limit);
  }

  /**
   * Create lesson plan
   * POST /teacher/lesson-plans
   */
  @Post('lesson-plans')
  async createLessonPlan(
    @GetUser() user: User,
    @Body()
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
    return this.teacherDashboardService.createLessonPlan(user.id, lessonData);
  }

  /**
   * Get student progress for content
   * GET /teacher/content/:contentId/progress
   */
  @Get('content/:contentId/progress')
  async getStudentProgress(
    @GetUser() user: User,
    @Param('contentId') contentId: string,
  ) {
    return this.teacherDashboardService.getStudentProgress(user.id, contentId);
  }

  /**
   * Get analytics for date range
   * GET /teacher/analytics
   */
  @Get('analytics')
  async getAnalytics(
    @GetUser() user: User,
    @Query('startDate') startDate: string,
    @Query('endDate') endDate: string,
  ) {
    const start = startDate ? new Date(startDate) : new Date(new Date().setDate(new Date().getDate() - 30));
    const end = endDate ? new Date(endDate) : new Date();

    return this.teacherDashboardService.getAnalytics(user.id, start, end);
  }

  /**
   * Export content data as CSV
   * GET /teacher/export/csv
   */
  @Get('export/csv')
  async exportContent(@GetUser() user: User, @Res() res: Response) {
    const csv = await this.teacherDashboardService.exportContent(user.id);

    res.header('Content-Type', 'text/csv');
    res.header('Content-Disposition', 'attachment; filename="teacher_content_export.csv"');
    res.send(csv);
  }
}
