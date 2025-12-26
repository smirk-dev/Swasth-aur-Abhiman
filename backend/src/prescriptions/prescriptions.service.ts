import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Prescription } from './entities/prescription.entity';
import { CreatePrescriptionDto, ReviewPrescriptionDto } from './dto/prescription.dto';
import { User } from '../users/entities/user.entity';
import { PrescriptionStatus } from '../common/enums/media.enum';
import { UserRole } from '../common/enums/user.enum';

@Injectable()
export class PrescriptionsService {
  constructor(
    @InjectRepository(Prescription)
    private prescriptionRepository: Repository<Prescription>,
  ) {}

  async createPrescription(createPrescriptionDto: CreatePrescriptionDto, user: User) {
    const prescription = this.prescriptionRepository.create({
      ...createPrescriptionDto,
      user,
    });

    return this.prescriptionRepository.save(prescription);
  }

  async getUserPrescriptions(userId: string) {
    return this.prescriptionRepository.find({
      where: { user: { id: userId } },
      order: { createdAt: 'DESC' },
      relations: ['reviewedBy'],
    });
  }

  async getAllPrescriptions(user: User) {
    // Only doctors can view all prescriptions
    if (user.role !== UserRole.DOCTOR && user.role !== UserRole.ADMIN) {
      throw new ForbiddenException('Only doctors can view all prescriptions');
    }

    return this.prescriptionRepository.find({
      order: { createdAt: 'DESC' },
      relations: ['user', 'reviewedBy'],
    });
  }

  async getPendingPrescriptions(user: User) {
    if (user.role !== UserRole.DOCTOR && user.role !== UserRole.ADMIN) {
      throw new ForbiddenException('Only doctors can view pending prescriptions');
    }

    return this.prescriptionRepository.find({
      where: { status: PrescriptionStatus.PENDING },
      order: { createdAt: 'ASC' },
      relations: ['user'],
    });
  }

  async reviewPrescription(
    prescriptionId: string,
    reviewPrescriptionDto: ReviewPrescriptionDto,
    doctor: User,
  ) {
    if (doctor.role !== UserRole.DOCTOR) {
      throw new ForbiddenException('Only doctors can review prescriptions');
    }

    const prescription = await this.prescriptionRepository.findOne({
      where: { id: prescriptionId },
      relations: ['user'],
    });

    if (!prescription) {
      throw new NotFoundException('Prescription not found');
    }

    prescription.status = PrescriptionStatus.REVIEWED;
    prescription.reviewedBy = doctor;
    prescription.doctorNotes = reviewPrescriptionDto.doctorNotes;
    prescription.reviewedAt = new Date();

    return this.prescriptionRepository.save(prescription);
  }
}
