import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { NutritionService } from './nutrition.service';
import { NutritionController } from './nutrition.controller';
import {
  NutritionPlan,
  MealPlan,
  NutritionLog,
  NutritionRecipe,
} from './entities/nutrition.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      NutritionPlan,
      MealPlan,
      NutritionLog,
      NutritionRecipe,
    ]),
  ],
  controllers: [NutritionController],
  providers: [NutritionService],
  exports: [NutritionService],
})
export class NutritionModule {}
