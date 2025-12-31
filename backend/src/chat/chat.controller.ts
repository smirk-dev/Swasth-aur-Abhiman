import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  UseGuards,
  Patch,
} from '@nestjs/common';
import { ChatService } from './chat.service';
import { CreateChatRoomDto } from './dto/chat.dto';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { GetUser } from '../common/decorators/get-user.decorator';
import { User } from '../users/entities/user.entity';

@Controller('chat')
@UseGuards(JwtAuthGuard)
export class ChatController {
  constructor(private chatService: ChatService) {}

  @Post('rooms')
  async createChatRoom(
    @Body() createChatRoomDto: CreateChatRoomDto,
    @GetUser() user: User,
  ) {
    return this.chatService.createChatRoom(createChatRoomDto, user);
  }

  @Get('rooms')
  async getUserChatRooms(@GetUser() user: User) {
    return this.chatService.getUserChatRooms(user.id);
  }

  @Get('rooms/:roomId/messages')
  async getRoomMessages(
    @Param('roomId') roomId: string,
    @GetUser() user: User,
  ) {
    return this.chatService.getRoomMessages(roomId, user.id);
  }

  @Patch('rooms/:roomId/read')
  async markMessagesAsRead(
    @Param('roomId') roomId: string,
    @GetUser() user: User,
  ) {
    await this.chatService.markMessagesAsRead(roomId, user.id);
    return { status: 'success' };
  }
}
