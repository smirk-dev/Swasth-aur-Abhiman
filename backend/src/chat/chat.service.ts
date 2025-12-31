import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In } from 'typeorm';
import { ChatRoom } from './entities/chat-room.entity';
import { Message } from './entities/message.entity';
import { User } from '../users/entities/user.entity';
import { CreateChatRoomDto, SendMessageDto } from './dto/chat.dto';

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
        return existingRoom;
      }
    }

    const chatRoom = this.chatRoomRepository.create({
      name,
      type: participantIds.length === 1 ? 'DIRECT' : 'GROUP',
      participants,
    });

    return this.chatRoomRepository.save(chatRoom);
  }

  async getUserChatRooms(userId: string) {
    return this.chatRoomRepository
      .createQueryBuilder('room')
      .leftJoinAndSelect('room.participants', 'participant')
      .leftJoinAndSelect('room.messages', 'message')
      .where('participant.id = :userId', { userId })
      .orderBy('room.lastMessageAt', 'DESC', 'NULLS LAST')
      .addOrderBy('room.createdAt', 'DESC')
      .getMany();
  }

  async sendMessage(sendMessageDto: SendMessageDto, sender: User) {
    const { roomId, content, type } = sendMessageDto;

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
    });

    const savedMessage = await this.messageRepository.save(message);

    // Update room's last message timestamp
    room.lastMessageAt = new Date();
    await this.chatRoomRepository.save(room);

    return savedMessage;
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

    return this.messageRepository.find({
      where: { room: { id: roomId } },
      relations: ['sender'],
      order: { createdAt: 'ASC' },
    });
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
}
