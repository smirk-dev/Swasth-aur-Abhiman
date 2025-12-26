import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  OneToOne,
  JoinColumn,
} from 'typeorm';
import { User } from './user.entity';
import { Block } from '../../common/enums/user.enum';

@Entity('user_profiles')
export class UserProfile {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({
    type: 'enum',
    enum: Block,
  })
  block: Block;

  @Column({ type: 'jsonb', nullable: true })
  healthMetrics: {
    bpHistory?: Array<{ date: string; systolic: number; diastolic: number }>;
    sugarHistory?: Array<{ date: string; level: number; type: string }>;
    bmiHistory?: Array<{ date: string; weight: number; height: number; bmi: number }>;
  };

  @Column({ nullable: true })
  address: string;

  @Column({ nullable: true })
  age: number;

  @OneToOne(() => User, user => user.userProfile)
  @JoinColumn()
  user: User;
}
