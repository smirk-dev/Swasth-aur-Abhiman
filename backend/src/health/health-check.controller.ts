import { Controller, Get } from '@nestjs/common';
import { HealthCheck, HealthCheckService, TypeOrmHealthIndicator, DiskHealthIndicator, MemoryHealthIndicator } from '@nestjs/terminus';

@Controller('health-check')
export class HealthCheckController {
  constructor(
    private health: HealthCheckService,
    private db: TypeOrmHealthIndicator,
    private disk: DiskHealthIndicator,
    private memory: MemoryHealthIndicator,
  ) {}

  @Get()
  @HealthCheck()
  check() {
    return this.health.check([
      // Database health check
      () => this.db.pingCheck('database'),
      // Disk storage check (90% threshold)
      () => this.disk.checkStorage('storage', { path: '/', thresholdPercent: 0.9 }),
      // Memory heap check (300MB threshold)
      () => this.memory.checkHeap('memory_heap', 300 * 1024 * 1024),
      // Memory RSS check (300MB threshold)
      () => this.memory.checkRSS('memory_rss', 300 * 1024 * 1024),
    ]);
  }

  @Get('liveness')
  liveness() {
    return { status: 'ok', timestamp: new Date().toISOString() };
  }

  @Get('readiness')
  @HealthCheck()
  readiness() {
    return this.health.check([
      () => this.db.pingCheck('database'),
    ]);
  }
}
