import { Injectable, Logger } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import { ConfigService } from '@nestjs/config';
import { lastValueFrom } from 'rxjs';

@Injectable()
export class YoutubeService {
  private readonly logger = new Logger(YoutubeService.name);

  constructor(
    private httpService: HttpService,
    private configService: ConfigService,
  ) {}

  async searchVideos(query: string, maxResults = 10) {
    const apiKey = this.configService.get('YOUTUBE_API_KEY');
    const url = 'https://www.googleapis.com/youtube/v3/search';

    const params = {
      part: 'snippet',
      q: query,
      maxResults,
      type: 'video',
      key: apiKey,
      videoEmbeddable: true,
    };

    try {
      const response = await lastValueFrom(this.httpService.get(url, { params }));
      return this.transformVideos(response.data.items);
    } catch (error) {
      this.logger.error('YouTube API error:', error);
      throw error;
    }
  }

  private transformVideos(items: any[]) {
    return items.map(item => ({
      title: item.snippet.title,
      description: item.snippet.description,
      thumbnail: item.snippet.thumbnails?.high?.url || '',
      videoId: item.id.videoId,
      externalUrl: `https://www.youtube.com/watch?v=${item.id.videoId}`,
      channelTitle: item.snippet.channelTitle,
    }));
  }
}
