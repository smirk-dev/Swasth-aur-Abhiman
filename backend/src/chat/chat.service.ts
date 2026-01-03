import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In, Not } from 'typeorm';
import { ChatRoom } from './entities/chat-room.entity';
import { Message } from './entities/message.entity';
import { User } from '../users/entities/user.entity';
import { CreateChatRoomDto, SendMessageDto } from './dto/chat.dto';
import { UserRole } from '../common/enums/user.enum';

@Injectable()
export class ChatService {
  constructor(
    @InjectRepository(ChatRoom)
    private chatRoomRepository: Repository<ChatRoom>,
    @InjectRepository(Message)
    private messageRepository: Repository<Message>,
    @InjectRepository(User)
    private userRepository: Repository<User>,
  ) {}

  async createChatRoom(createChatRoomDto: CreateChatRoomDto, currentUser: User) {
    const { participantIds, name } = createChatRoomDto;

    // Get all participants
    const participants = await this.userRepository.find({
      where: { id: In([...participantIds, currentUser.id]) },
    });

    if (participants.length !== participantIds.length + 1) {
      throw new NotFoundException('Some participants not found');
    }

    // Check if direct chat already exists
    if (participantIds.length === 1) {
      const existingRoom = await this.chatRoomRepository
        .createQueryBuilder('room')
        .leftJoin('room.participants', 'participant')
        .where('room.type = :type', { type: 'DIRECT' })
        .andWhere('participant.id IN (:...ids)', { ids: [currentUser.id, participantIds[0]] })
        .groupBy('room.id')
        .having('COUNT(participant.id) = 2')
        .getOne();

      if (existingRoom) {
        return {
          id: existingRoom.id,
          name: existingRoom.name,
          description: null,
          type: existingRoom.type,
          participants: participants.map(p => ({
            id: p.id,
            name: p.fullName,
            role: p.role,
            avatarUrl: null,
            isOnline: false,
          })),
          lastMessage: null,
          unreadCount: 0,
          createdAt: existingRoom.createdAt.toISOString(),
          updatedAt: null,
        };
      }
    }

    const chatRoom = this.chatRoomRepository.create({
      name: name || (participantIds.length === 1 
        ? participants.find(p => p.id === participantIds[0])?.fullName 
        : 'Group Chat'),
      type: participantIds.length === 1 ? 'DIRECT' : 'GROUP',
      participants,
    });

    const savedRoom = await this.chatRoomRepository.save(chatRoom);

    return {
      id: savedRoom.id,
      name: savedRoom.name,
      description: null,
      type: savedRoom.type,
      participants: participants.map(p => ({
        id: p.id,
        name: p.fullName,
        role: p.role,
        avatarUrl: null,
        isOnline: false,
      })),
      lastMessage: null,
      unreadCount: 0,
      createdAt: savedRoom.createdAt.toISOString(),
      updatedAt: null,
    };
  }

  async getUserChatRooms(userId: string) {
    const rooms = await this.chatRoomRepository
      .createQueryBuilder('room')
      .leftJoinAndSelect('room.participants', 'participant')
      .leftJoinAndSelect('room.messages', 'message')
      .where('participant.id = :userId', { userId })
      .orderBy('room.lastMessageAt', 'DESC', 'NULLS LAST')
      .addOrderBy('room.createdAt', 'DESC')
      .getMany();

    // Map rooms to include properly formatted data for the client
    return rooms.map(room => ({
      id: room.id,
      name: room.name || room.participants.find(p => p.id !== userId)?.fullName || 'Chat',
      description: null,
      type: room.type,
      participants: room.participants.map(p => ({
        id: p.id,
        name: p.fullName,
        role: p.role,
        avatarUrl: null,
        isOnline: false,
      })),
      lastMessage: room.messages && room.messages.length > 0
        ? {
            id: room.messages[room.messages.length - 1].id,
            roomId: room.id,
            senderId: room.messages[room.messages.length - 1].sender?.id,
            senderName: room.messages[room.messages.length - 1].sender?.fullName,
            content: room.messages[room.messages.length - 1].content,
            type: room.messages[room.messages.length - 1].type || 'TEXT',
            mediaUrl: room.messages[room.messages.length - 1].mediaUrl,
            createdAt: room.messages[room.messages.length - 1].createdAt.toISOString(),
            isRead: room.messages[room.messages.length - 1].isRead,
            audioDuration: room.messages[room.messages.length - 1].audioDuration,
          }
        : null,
      unreadCount: 0,
      createdAt: room.createdAt.toISOString(),
      updatedAt: room.lastMessageAt?.toISOString(),
    }));
  }

  async sendMessage(sendMessageDto: SendMessageDto, sender: User) {
    const { roomId, content, type, mediaUrl, audioDuration } = sendMessageDto;

    const room = await this.chatRoomRepository.findOne({
      where: { id: roomId },
      relations: ['participants'],
    });

    if (!room) {
      throw new NotFoundException('Chat room not found');
    }

    // Verify sender is a participant
    const isParticipant = room.participants.some(p => p.id === sender.id);
    if (!isParticipant) {
      throw new NotFoundException('You are not a participant of this chat room');
    }

    const message = this.messageRepository.create({
      room,
      sender,
      content,
      type: type || 'TEXT',
      mediaUrl,
      audioDuration,
    });

    const savedMessage = await this.messageRepository.save(message);

    // Update room's last message timestamp
    room.lastMessageAt = new Date();
    await this.chatRoomRepository.save(room);

    // Return message with additional fields for the client
    return {
      id: savedMessage.id,
      roomId: roomId,
      senderId: sender.id,
      senderName: sender.fullName,
      content: savedMessage.content,
      type: savedMessage.type || 'TEXT',
      mediaUrl: savedMessage.mediaUrl,
      audioDuration: savedMessage.audioDuration,
      isRead: savedMessage.isRead,
      createdAt: savedMessage.createdAt.toISOString(),
    };
  }

  async getRoomMessages(roomId: string, userId: string) {
    const room = await this.chatRoomRepository.findOne({
      where: { id: roomId },
      relations: ['participants'],
    });

    if (!room) {
      throw new NotFoundException('Chat room not found');
    }

    // Verify user is a participant
    const isParticipant = room.participants.some(p => p.id === userId);
    if (!isParticipant) {
      throw new NotFoundException('You are not a participant of this chat room');
    }

    const messages = await this.messageRepository.find({
      where: { room: { id: roomId } },
      relations: ['sender'],
      order: { createdAt: 'ASC' },
    });

    // Map messages to include all required fields for the client
    return messages.map(msg => ({
      id: msg.id,
      roomId: roomId,
      senderId: msg.sender.id,
      senderName: msg.sender.fullName,
      content: msg.content,
      type: msg.type || 'TEXT',
      mediaUrl: msg.mediaUrl,
      audioDuration: msg.audioDuration,
      isRead: msg.isRead,
      createdAt: msg.createdAt.toISOString(),
    }));
  }

  async markMessagesAsRead(roomId: string, userId: string) {
    await this.messageRepository
      .createQueryBuilder()
      .update(Message)
      .set({ isRead: true })
      .where('roomId = :roomId', { roomId })
      .andWhere('senderId != :userId', { userId })
      .andWhere('isRead = :isRead', { isRead: false })
      .execute();
  }

  async getAvailableContacts(currentUserId: string, role?: string) {
    const whereConditions: any = {
      id: Not(currentUserId),
      isActive: true,
    };

    if (role && Object.values(UserRole).includes(role as UserRole)) {
      whereConditions.role = role as UserRole;
    }

    const users = await this.userRepository.find({
      where: whereConditions,
      relations: ['userProfile', 'doctorProfile'],
      order: { fullName: 'ASC' },
    });

    return users.map(user => ({
      id: user.id,
      name: user.fullName,
      role: user.role,
      email: user.email,
      block: user.userProfile?.block || null,
      isOnline: false, // Can be tracked via websocket connections
    }));
  }

  async sendMessageToRoom(sendMessageDto: SendMessageDto, sender: User) {
    return this.sendMessage(sendMessageDto, sender);
  }
}
