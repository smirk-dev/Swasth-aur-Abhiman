import { Injectable, NestInterceptor, ExecutionContext, CallHandler } from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';
import { LoggerService } from '../logger/logger.service';

@Injectable()
export class PerformanceInterceptor implements NestInterceptor {
  constructor(private readonly logger: LoggerService) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const startTime = Date.now();
    const request = context.switchToHttp().getRequest();
    const { method, url } = request;

    return next.handle().pipe(
      tap(() => {
        const responseTime = Date.now() - startTime;
        
        if (responseTime > 1000) {
          this.logger.warn(
            `Slow endpoint detected: ${method} ${url} took ${responseTime}ms`,
            'Performance',
          );
        }

        // Log database query performance if available
        if (request.queryCount) {
          this.logger.debug(
            `${method} ${url} executed ${request.queryCount} database queries`,
            'Database',
          );
        }
      }),
    );
  }
}
