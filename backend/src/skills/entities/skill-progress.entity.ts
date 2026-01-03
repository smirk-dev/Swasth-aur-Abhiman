import {
  Column,
  CreateDateColumn,
  Entity,
  ManyToOne,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';

@Entity('skill_enrollments')
@Index(['user', 'skillCategory'])
export class SkillEnrollment {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => User, { onDelete: 'CASCADE' })
  user: User;

  @Column()
  skillCategory: string;

  @Column({ default: 0 })
  completedCoursesCount: number;

  @Column({ default: 0 })
  totalCoursesCount: number;

  @Column('decimal', { precision: 5, scale: 2, default: 0 })
  completionPercentage: number;

  @Column({ nullable: true })
  certificateIssuedDate: Date;

  @Column({ default: 'ENROLLED' })
  status: 'ENROLLED' | 'COMPLETED' | 'DROPPED_OUT';

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}

@Entity('skill_progress')
@Index(['user', 'courseId'])
@Index(['enrollment', 'courseId'])
export class SkillProgress {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => User, { onDelete: 'CASCADE' })
  user: User;

  @ManyToOne(() => SkillEnrollment, { onDelete: 'CASCADE' })
  enrollment: SkillEnrollment;

  @Column()
  courseId: string;

  @Column()
  courseTitle: string;

  @Column({ nullable: true })
  videoUrl: string;

  @Column({ default: 0 })
  watchedDurationSeconds: number;

  @Column({ nullable: true })
  totalDurationSeconds: number;

  @Column('decimal', { precision: 5, scale: 2, default: 0 })
  progressPercentage: number;

  @Column({ default: false })
  isCompleted: boolean;

  @Column({ nullable: true })
  completedAt: Date;

  @Column({ default: 0 })
  viewCount: number;

  @Column({ nullable: true })
  lastWatchedAt: Date;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
