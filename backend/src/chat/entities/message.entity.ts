import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { ChatRoom } from './chat-room.entity';

@Entity('messages')
export class Message {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => ChatRoom, room => room.messages)
  @JoinColumn()
  room: ChatRoom;

  @ManyToOne(() => User)
  @JoinColumn()
  sender: User;

  @Column({ type: 'text' })
  content: string;

  @Column({ default: 'TEXT' })
  type: string; // TEXT or IMAGE

  @Column({ default: false })
  isRead: boolean;

  @CreateDateColumn()
  createdAt: Date;
}
