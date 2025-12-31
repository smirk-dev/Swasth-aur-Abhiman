import dataSource from '../config/typeorm.config';
import { seedEducationalVideos } from '../database/seeds/educational-videos.seed';

async function run() {
  try {
    await dataSource.initialize();
    await seedEducationalVideos(dataSource);
    console.log('Seeding completed');
    await dataSource.destroy();
    process.exit(0);
  } catch (err) {
    console.error('Seeding error', err);
    process.exit(1);
  }
}

run();
