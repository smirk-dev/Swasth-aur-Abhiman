import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  OneToOne,
  JoinColumn,
} from 'typeorm';
import { User } from './user.entity';

@Entity('doctor_profiles')
export class DoctorProfile {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  specialization: string;

  @Column({ default: 'PENDING' })
  verificationStatus: string;

  @Column({ nullable: true })
  licenseNumber: string;

  @Column({ nullable: true })
  yearsOfExperience: number;

  @Column({ nullable: true })
  hospitalAffiliation: string;

  @OneToOne(() => User, user => user.doctorProfile)
  @JoinColumn()
  user: User;
}
