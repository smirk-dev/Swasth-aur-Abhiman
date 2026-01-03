import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SkillsController } from './skills.controller';
import { SkillsService } from './skills.service';
import { TrainerDashboardController } from './trainer-dashboard.controller';
import { TrainerDashboardService } from './trainer-dashboard.service';
import { MediaContent } from '../media/entities/media-content.entity';
import { User } from '../users/entities/user.entity';
import { SkillEnrollment, SkillProgress } from './entities/skill-progress.entity';

@Module({
  imports: [TypeOrmModule.forFeature([MediaContent, User, SkillEnrollment, SkillProgress])],
  controllers: [SkillsController, TrainerDashboardController],
  providers: [SkillsService, TrainerDashboardService],
  exports: [SkillsService, TrainerDashboardService],
})
export class SkillsModule {}
