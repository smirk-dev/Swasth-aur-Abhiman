import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { MediaCategory } from '../../common/enums/media.enum';

@Entity('media_content')
export class MediaContent {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  title: string;

  @Column({ type: 'text' })
  description: string;

  @Column({
    type: 'enum',
    enum: MediaCategory,
  })
  category: MediaCategory;

  @Column({ nullable: true })
  subCategory: string;

  @Column()
  mediaUrl: string;

  @Column({ nullable: true })
  thumbnailUrl: string;

  @Column({ type: 'varchar', length: 20, nullable: true })
  source: string; // 'youtube', 'internal', 'vimeo'

  @Column({ type: 'text', nullable: true })
  externalUrl: string; // YouTube URL

  @Column({ default: 0 })
  viewCount: number;

  @Column({ type: 'decimal', precision: 2, scale: 1, nullable: true })
  rating: number; // 1.0 to 5.0

  @Column({ type: 'varchar', length: 20, nullable: true })
  difficulty: string; // 'Beginner', 'Intermediate', 'Advanced'

  @Column({ type: 'varchar', length: 20, nullable: true })
  ageGroup: string; // 'Class 1', 'Class 2', etc.

  @Column({ type: 'varchar', length: 50, nullable: true })
  subject: string; // 'Mathematics', 'Science', etc.

  @Column({ type: 'varchar', length: 100, nullable: true })
  chapter: string;

  @Column({ type: 'varchar', length: 20, nullable: true })
  language: string; // 'Hindi', 'English', 'Hinglish'

  @Column({ type: 'integer', nullable: true })
  durationSeconds: number;

  @Column({ type: 'boolean', default: true })
  isFree: boolean;

  @Column({ default: true })
  isActive: boolean;

  @ManyToOne(() => User)
  @JoinColumn()
  uploadedBy: User;

  @CreateDateColumn()
  createdAt: Date;
}
