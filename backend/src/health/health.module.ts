import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { HealthController } from './health.controller';
import { HealthService } from './health.service';
import { HealthMetric, HealthMetricSession } from './entities/health-metric.entity';

@Module({
  imports: [TypeOrmModule.forFeature([HealthMetric, HealthMetricSession])],
  controllers: [HealthController],
  providers: [HealthService],
  exports: [HealthService],
})
export class HealthModule {}
