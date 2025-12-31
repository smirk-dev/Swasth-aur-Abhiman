import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  UseGuards,
  Patch,
  Query,
} from '@nestjs/common';
import { ChatService } from './chat.service';
import { CreateChatRoomDto, SendMessageDto } from './dto/chat.dto';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { GetUser } from '../common/decorators/get-user.decorator';
import { User } from '../users/entities/user.entity';

@Controller('chat')
@UseGuards(JwtAuthGuard)
export class ChatController {
  constructor(private chatService: ChatService) {}

  @Get('contacts')
  async getAvailableContacts(
    @GetUser() user: User,
    @Query('role') role?: string,
  ) {
    return this.chatService.getAvailableContacts(user.id, role);
  }

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

  @Post('rooms/:roomId/messages')
  async sendMessage(
    @Param('roomId') roomId: string,
    @Body() body: { content: string; type?: string },
    @GetUser() user: User,
  ) {
    const sendMessageDto: SendMessageDto = {
      roomId,
      content: body.content,
      type: body.type,
    };
    return this.chatService.sendMessageToRoom(sendMessageDto, user);
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
