import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  UseGuards,
  Patch,
} from '@nestjs/common';
import { PrescriptionsService } from './prescriptions.service';
import { CreatePrescriptionDto, ReviewPrescriptionDto } from './dto/prescription.dto';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { RolesGuard } from '../common/guards/roles.guard';
import { Roles } from '../common/decorators/roles.decorator';
import { GetUser } from '../common/decorators/get-user.decorator';
import { UserRole } from '../common/enums/user.enum';
import { User } from '../users/entities/user.entity';

@Controller('prescriptions')
@UseGuards(JwtAuthGuard, RolesGuard)
export class PrescriptionsController {
  constructor(private prescriptionsService: PrescriptionsService) {}

  @Post()
  @Roles(UserRole.USER)
  async createPrescription(
    @Body() createPrescriptionDto: CreatePrescriptionDto,
    @GetUser() user: User,
  ) {
    return this.prescriptionsService.createPrescription(createPrescriptionDto, user);
  }

  @Get('my')
  @Roles(UserRole.USER)
  async getUserPrescriptions(@GetUser() user: User) {
    return this.prescriptionsService.getUserPrescriptions(user.id);
  }

  @Get('all')
  @Roles(UserRole.DOCTOR, UserRole.ADMIN)
  async getAllPrescriptions(@GetUser() user: User) {
    return this.prescriptionsService.getAllPrescriptions(user);
  }

  @Get('pending')
  @Roles(UserRole.DOCTOR, UserRole.ADMIN)
  async getPendingPrescriptions(@GetUser() user: User) {
    return this.prescriptionsService.getPendingPrescriptions(user);
  }

  @Patch(':id/review')
  @Roles(UserRole.DOCTOR)
  async reviewPrescription(
    @Param('id') id: string,
    @Body() reviewPrescriptionDto: ReviewPrescriptionDto,
    @GetUser() doctor: User,
  ) {
    return this.prescriptionsService.reviewPrescription(id, reviewPrescriptionDto, doctor);
  }
}
