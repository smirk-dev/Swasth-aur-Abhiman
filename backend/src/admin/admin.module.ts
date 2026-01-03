import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AdminController } from './admin.controller';
import { AdminService } from './admin.service';
import { FileUploadService } from '../media/services/file-upload.service';
import { MediaContent } from '../media/entities/media-content.entity';
import { User } from '../users/entities/user.entity';
import { Event } from '../events/entities/event.entity';

@Module({
  imports: [TypeOrmModule.forFeature([MediaContent, User, Event])],
  controllers: [AdminController],
  providers: [AdminService, FileUploadService],
  exports: [AdminService, FileUploadService],
})
export class AdminModule {}
