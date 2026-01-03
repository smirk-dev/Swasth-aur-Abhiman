import {
  Controller,
  Get,
  Post,
  Delete,
  Param,
  Query,
  UseGuards,
  Request,
  Sse,
} from '@nestjs/common';
import { NotificationService } from './notifications.service';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { Observable, interval } from 'rxjs';
import { map } from 'rxjs/operators';

@Controller('notifications')
@UseGuards(JwtAuthGuard)
export class NotificationController {
  constructor(private notificationService: NotificationService) {}

  @Get()
  async getNotifications(
    @Request() req,
    @Query('limit') limit = 20,
    @Query('offset') offset = 0,
  ) {
    return this.notificationService.getUserNotifications(
      req.user.id,
      +limit,
      +offset,
    );
  }

  @Get('unread-count')
  async getUnreadCount(@Request() req) {
    return {
      unreadCount: await this.notificationService.getUnreadCount(req.user.id),
    };
  }

  @Post(':notificationId/read')
  async markAsRead(@Param('notificationId') notificationId: string) {
    await this.notificationService.markAsRead(notificationId);
    return { message: 'Notification marked as read' };
  }

  @Post('read-all')
  async markAllAsRead(@Request() req) {
    await this.notificationService.markAllAsRead(req.user.id);
    return { message: 'All notifications marked as read' };
  }

  @Delete(':notificationId')
  async deleteNotification(@Param('notificationId') notificationId: string) {
    await this.notificationService.deleteNotification(notificationId);
    return { message: 'Notification deleted' };
  }

  @Get('type/:type')
  async getNotificationsByType(
    @Request() req,
    @Param('type') type: string,
    @Query('limit') limit = 10,
  ) {
    return this.notificationService.getNotificationsByType(
      req.user.id,
      type,
      +limit,
    );
  }

  // ===== SERVER-SENT EVENTS (Real-time Updates) =====

  @Sse('stream')
  @UseGuards(JwtAuthGuard)
  notificationStream(@Request() req): Observable<any> {
    return interval(30000).pipe(
      map(() => ({
        data: {
          message: 'ping',
          timestamp: new Date().toISOString(),
        },
      })),
    );
  }
}
