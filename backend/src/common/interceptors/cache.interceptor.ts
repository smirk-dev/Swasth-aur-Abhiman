import { Injectable, NestInterceptor, ExecutionContext, CallHandler } from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';
import { Inject } from '@nestjs/common';
import { CACHE_MANAGER } from '@nestjs/cache-manager';
import { Cache } from 'cache-manager';

@Injectable()
export class CacheInterceptor implements NestInterceptor {
  constructor(@Inject(CACHE_MANAGER) private cacheManager: Cache) {}

  async intercept(context: ExecutionContext, next: CallHandler): Promise<Observable<any>> {
    const request = context.switchToHttp().getRequest();
    const { method, url } = request;

    // Only cache GET requests
    if (method !== 'GET') {
      return next.handle();
    }

    // Generate cache key based on URL and query parameters
    const cacheKey = `${url}${JSON.stringify(request.query)}`;

    // Try to get from cache
    const cachedResponse = await this.cacheManager.get(cacheKey);
    if (cachedResponse) {
      return new Observable((subscriber) => {
        subscriber.next(cachedResponse);
        subscriber.complete();
      });
    }

    // If not in cache, proceed with request and cache the result
    return next.handle().pipe(
      tap(async (response) => {
        await this.cacheManager.set(cacheKey, response, 300); // 5 minutes TTL
      }),
    );
  }
}
