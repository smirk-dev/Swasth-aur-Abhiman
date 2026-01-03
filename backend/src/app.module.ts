import { Module, MiddlewareConsumer, NestModule } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ThrottlerModule, ThrottlerGuard } from '@nestjs/throttler';
import { APP_GUARD } from '@nestjs/core';
import { CacheModule } from '@nestjs/cache-manager';
import * as redisStore from 'cache-manager-redis-store';
import { TerminusModule } from '@nestjs/terminus';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { MediaModule } from './media/media.module';
import { EventsModule } from './events/events.module';
import { PrescriptionsModule } from './prescriptions/prescriptions.module';
import { ChatModule } from './chat/chat.module';
import { YoutubeModule } from './youtube/youtube.module';
import { AnalyticsModule } from './analytics/analytics.module';
import { AdminModule } from './admin/admin.module';
import { HealthModule } from './health/health.module';
import { DoctorModule } from './doctor/doctor.module';
import { SkillsModule } from './skills/skills.module';
import { NutritionModule } from './nutrition/nutrition.module';
import { NotificationModule } from './notifications/notifications.module';
import { LoggingMiddleware } from './common/middleware/logging.middleware';
import { LoggerService } from './common/logger/logger.service';
import { HealthCheckController } from './health/health-check.controller';

@Module({
  imports: [
    // Configuration Module
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
    }),

    // Rate Limiting
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

    // Redis Caching
    CacheModule.registerAsync({
      isGlobal: true,
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: async (configService: ConfigService) => ({
        store: redisStore,
        host: configService.get('REDIS_HOST', 'localhost'),
        port: configService.get('REDIS_PORT', 6379),
        ttl: 300, // 5 minutes default
        max: 100, // maximum number of items in cache
      }),
    }),

    // Health Checks
    TerminusModule,

    // Database Module
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => ({
        type: 'postgres',
        host: configService.get('DB_HOST'),
        port: configService.get<number>('DB_PORT'),
        username: configService.get('DB_USERNAME'),
        password: configService.get('DB_PASSWORD'),
        database: configService.get('DB_DATABASE'),
        entities: [__dirname + '/**/*.entity{.ts,.js}'],
        synchronize: configService.get('NODE_ENV') === 'development', // Set to false in production
        logging: configService.get('NODE_ENV') === 'development',
        // Performance optimizations
        extra: {
          max: 20, // max number of clients in the pool
          idleTimeoutMillis: 30000,
          connectionTimeoutMillis: 2000,
        },
      }),
    }),

    // Feature Modules
    AuthModule,
    UsersModule,
    MediaModule,
    EventsModule,
    PrescriptionsModule,
    ChatModule,
    YoutubeModule,
    AnalyticsModule,
    AdminModule,
    HealthModule,
    DoctorModule,
    SkillsModule,
    NutritionModule,
    NotificationModule,
  ],
  controllers: [HealthCheckController],
  providers: [
    LoggerService,
    {
      provide: APP_GUARD,
      useClass: ThrottlerGuard,
    },
  ],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer
      .apply(LoggingMiddleware)
      .forRoutes('*');
  }
}
