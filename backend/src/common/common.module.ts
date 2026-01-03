import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { ThrottlerModule } from '@nestjs/throttler';
import { CacheModule } from '@nestjs/cache-manager';
import * as redisStore from 'cache-manager-redis-store';
import { TerminusModule } from '@nestjs/terminus';
import { HealthCheckController } from './health/health-check.controller';
import { LoggerService } from './common/logger/logger.service';

@Module({
  imports: [
    // Rate limiting
    ThrottlerModule.forRoot([
      {
        name: 'short',
        ttl: 1000,
        limit: 10, // 10 requests per second
      },
      {
        name: 'medium',
        ttl: 10000,
        limit: 100, // 100 requests per 10 seconds
      },
      {
        name: 'long',
        ttl: 60000,
        limit: 500, // 500 requests per minute
      },
    ]),

    // Redis caching
    CacheModule.register({
      isGlobal: true,
      store: redisStore,
      host: process.env.REDIS_HOST || 'localhost',
      port: process.env.REDIS_PORT || 6379,
      ttl: 300, // 5 minutes default
      max: 100, // maximum number of items in cache
    }),

    // Health checks
    TerminusModule,
  ],
  controllers: [HealthCheckController],
  providers: [LoggerService],
  exports: [LoggerService],
})
export class CommonModule {}
