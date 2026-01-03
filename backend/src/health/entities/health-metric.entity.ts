import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  ManyToOne,
  JoinColumn,
  Index,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';

@Entity('health_metrics')
@Index(['user', 'createdAt'])
@Index(['user', 'metricType'])
export class HealthMetric {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => User)
  @JoinColumn()
  user: User;

  @Column({
    type: 'enum',
    enum: ['BP_SYSTOLIC', 'BP_DIASTOLIC', 'BLOOD_SUGAR', 'BMI', 'WEIGHT', 'HEIGHT', 'TEMPERATURE', 'PULSE'],
  })
  metricType: string;

  @Column({ type: 'decimal', precision: 8, scale: 2 })
  value: number;

  @Column({ nullable: true })
  unit: string; // mmHg, mg/dL, kg/m², kg, cm, °F, bpm

  @Column({ nullable: true })
  notes: string;

  @Column({ type: 'varchar', length: 20, nullable: true })
  condition: string; // 'normal', 'high', 'low', 'critical'

  @CreateDateColumn()
  recordedAt: Date;

  @CreateDateColumn()
  createdAt: Date;
}

@Entity('health_metric_sessions')
@Index(['user', 'date'])
export class HealthMetricSession {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => User)
  @JoinColumn()
  user: User;

  @Column({ type: 'date' })
  date: string;

  @Column({ type: 'decimal', precision: 8, scale: 2, nullable: true })
  bpSystolic: number;

  @Column({ type: 'decimal', precision: 8, scale: 2, nullable: true })
  bpDiastolic: number;

  @Column({ type: 'decimal', precision: 8, scale: 2, nullable: true })
  bloodSugar: number;

  @Column({ type: 'decimal', precision: 8, scale: 2, nullable: true })
  bmi: number;

  @Column({ type: 'decimal', precision: 8, scale: 2, nullable: true })
  weight: number;

  @Column({ type: 'decimal', precision: 8, scale: 2, nullable: true })
  height: number;

  @Column({ type: 'decimal', precision: 8, scale: 2, nullable: true })
  temperature: number;

  @Column({ type: 'decimal', precision: 8, scale: 2, nullable: true })
  pulse: number;

  @Column({ type: 'text', nullable: true })
  notes: string;

  @CreateDateColumn()
  createdAt: Date;
}
