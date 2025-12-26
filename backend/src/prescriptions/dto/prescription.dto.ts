import { IsString, IsOptional, IsUrl } from 'class-validator';

export class CreatePrescriptionDto {
  @IsUrl()
  imageUrl: string;

  @IsString()
  @IsOptional()
  description?: string;

  @IsString()
  @IsOptional()
  symptoms?: string;
}

export class ReviewPrescriptionDto {
  @IsString()
  doctorNotes: string;
}
