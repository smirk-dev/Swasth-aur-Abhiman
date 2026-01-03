import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Between, MoreThanOrEqual } from 'typeorm';
import {
  NutritionPlan,
  MealPlan,
  NutritionLog,
  NutritionRecipe,
} from './entities/nutrition.entity';
import { User } from '../users/entities/user.entity';

@Injectable()
export class NutritionService {
  constructor(
    @InjectRepository(NutritionPlan)
    private planRepo: Repository<NutritionPlan>,
    @InjectRepository(MealPlan)
    private mealRepo: Repository<MealPlan>,
    @InjectRepository(NutritionLog)
    private logRepo: Repository<NutritionLog>,
    @InjectRepository(NutritionRecipe)
    private recipeRepo: Repository<NutritionRecipe>,
  ) {}

  // ===== NUTRITION PLANS =====

  async createNutritionPlan(
    user: User,
    data: {
      title: string;
      description: string;
      dietType: 'VEGETARIAN' | 'NON_VEGETARIAN' | 'VEGAN' | 'DIABETIC' | 'LOW_CALORIE';
      goal: 'WEIGHT_LOSS' | 'WEIGHT_GAIN' | 'MUSCLE_BUILDING' | 'RECOVERY' | 'MAINTENANCE';
      targetCalories?: number;
      targetProteinGrams?: number;
      targetCarbsGrams?: number;
      targetFatsGrams?: number;
    },
  ): Promise<NutritionPlan> {
    const plan = this.planRepo.create({
      user,
      ...data,
      startDate: new Date(),
      status: 'ACTIVE',
    });
    return this.planRepo.save(plan);
  }

  async getUserActivePlan(userId: string): Promise<NutritionPlan | null> {
    return this.planRepo.findOne({
      where: { user: { id: userId }, status: 'ACTIVE' },
      order: { createdAt: 'DESC' },
    });
  }

  async getNutritionPlansByUser(userId: string): Promise<NutritionPlan[]> {
    return this.planRepo.find({
      where: { user: { id: userId } },
      order: { createdAt: 'DESC' },
    });
  }

  async updateNutritionPlan(
    planId: string,
    data: Partial<NutritionPlan>,
  ): Promise<NutritionPlan> {
    await this.planRepo.update(planId, data);
    return this.planRepo.findOne({ where: { id: planId } });
  }

  // ===== MEAL PLANS =====

  async createMealPlan(
    planId: string,
    dayNumber: number,
    meals: Array<{
      mealType: 'BREAKFAST' | 'LUNCH' | 'SNACK' | 'DINNER';
      foods: string[];
      recipeUrl?: string;
      estimatedCalories?: number;
      nutritionInfo?: string;
    }>,
  ): Promise<MealPlan[]> {
    const plan = await this.planRepo.findOne({ where: { id: planId } });

    const mealPlans = meals.map((meal) =>
      this.mealRepo.create({
        nutritionPlan: plan,
        dayNumber,
        ...meal,
      }),
    );

    return this.mealRepo.save(mealPlans);
  }

  async getMealPlansForDay(
    planId: string,
    dayNumber: number,
  ): Promise<MealPlan[]> {
    return this.mealRepo.find({
      where: {
        nutritionPlan: { id: planId },
        dayNumber,
      },
      order: { mealType: 'ASC' },
    });
  }

  async getWeeklyMealPlan(planId: string): Promise<MealPlan[]> {
    return this.mealRepo.find({
      where: { nutritionPlan: { id: planId } },
      order: { dayNumber: 'ASC', mealType: 'ASC' },
    });
  }

  // ===== NUTRITION LOGGING =====

  async logMeal(
    user: User,
    data: {
      mealType: 'BREAKFAST' | 'LUNCH' | 'SNACK' | 'DINNER';
      foodItem: string;
      servingSize?: string;
      estimatedCalories?: number;
      proteinGrams?: number;
      carbsGrams?: number;
      fatsGrams?: number;
      fiberGrams?: number;
      notes?: string;
    },
  ): Promise<NutritionLog> {
    const log = this.logRepo.create({
      user,
      ...data,
    });
    return this.logRepo.save(log);
  }

  async getTodayMealLogs(userId: string): Promise<{
    logs: NutritionLog[];
    totalCalories: number;
    totalProtein: number;
    totalCarbs: number;
    totalFats: number;
  }> {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    const logs = await this.logRepo.find({
      where: {
        user: { id: userId },
        createdAt: Between(today, tomorrow),
      },
      order: { createdAt: 'ASC' },
    });

    const totals = logs.reduce(
      (acc, log) => ({
        totalCalories:
          acc.totalCalories + (log.estimatedCalories || 0),
        totalProtein: acc.totalProtein + (log.proteinGrams || 0),
        totalCarbs: acc.totalCarbs + (log.carbsGrams || 0),
        totalFats: acc.totalFats + (log.fatsGrams || 0),
      }),
      {
        totalCalories: 0,
        totalProtein: 0,
        totalCarbs: 0,
        totalFats: 0,
      },
    );

    return {
      logs,
      ...totals,
    };
  }

  async getNutritionSummary(
    userId: string,
    days: number = 7,
  ): Promise<{
    averageDailyCalories: number;
    averageDailyProtein: number;
    averageDailyCarbs: number;
    averageDailyFats: number;
    mealsTaken: number;
    completionRate: number;
  }> {
    const startDate = new Date();
    startDate.setDate(startDate.getDate() - days);

    const logs = await this.logRepo.find({
      where: {
        user: { id: userId },
        createdAt: MoreThanOrEqual(startDate),
      },
    });

    const dailyGrouped = new Map<string, NutritionLog[]>();
    logs.forEach((log) => {
      const dateKey = log.createdAt.toISOString().split('T')[0];
      if (!dailyGrouped.has(dateKey)) {
        dailyGrouped.set(dateKey, []);
      }
      dailyGrouped.get(dateKey).push(log);
    });

    const dailyStats = Array.from(dailyGrouped.values()).map((dayLogs) => ({
      calories: dayLogs.reduce((sum, log) => sum + (log.estimatedCalories || 0), 0),
      protein: dayLogs.reduce((sum, log) => sum + (log.proteinGrams || 0), 0),
      carbs: dayLogs.reduce((sum, log) => sum + (log.carbsGrams || 0), 0),
      fats: dayLogs.reduce((sum, log) => sum + (log.fatsGrams || 0), 0),
      meals: dayLogs.length,
    }));

    const avgDailyCalories =
      dailyStats.length > 0
        ? Math.round(
            dailyStats.reduce((sum, d) => sum + d.calories, 0) /
              dailyStats.length,
          )
        : 0;

    const plan = await this.getUserActivePlan(userId);
    const targetCalories = plan?.targetCalories || 2000;
    const completionRate =
      dailyStats.length > 0
        ? Math.round(
            (dailyStats.reduce((sum, d) => sum + d.calories, 0) /
              (targetCalories * dailyStats.length)) *
              100,
          )
        : 0;

    return {
      averageDailyCalories: avgDailyCalories,
      averageDailyProtein: dailyStats.length > 0
        ? Math.round(
            dailyStats.reduce((sum, d) => sum + d.protein, 0) /
              dailyStats.length,
          )
        : 0,
      averageDailyCarbs: dailyStats.length > 0
        ? Math.round(
            dailyStats.reduce((sum, d) => sum + d.carbs, 0) /
              dailyStats.length,
          )
        : 0,
      averageDailyFats: dailyStats.length > 0
        ? Math.round(
            dailyStats.reduce((sum, d) => sum + d.fats, 0) /
              dailyStats.length,
          )
        : 0,
      mealsTaken: logs.length,
      completionRate,
    };
  }

  // ===== RECIPES =====

  async getPopularRecipes(
    limit: number = 10,
  ): Promise<NutritionRecipe[]> {
    return this.recipeRepo.find({
      order: { viewCount: 'DESC' },
      take: limit,
    });
  }

  async searchRecipes(
    query: string,
    dietType?: string,
    limit: number = 20,
  ): Promise<NutritionRecipe[]> {
    const queryBuilder = this.recipeRepo.createQueryBuilder('recipe');

    if (query) {
      queryBuilder.where(
        'recipe.title ILIKE :query OR recipe.description ILIKE :query OR recipe.cuisineType ILIKE :query',
        { query: `%${query}%` },
      );
    }

    if (dietType) {
      queryBuilder.andWhere('recipe.dietSuitability ILIKE :dietType', {
        dietType: `%${dietType}%`,
      });
    }

    return queryBuilder
      .orderBy('recipe.viewCount', 'DESC')
      .take(limit)
      .getMany();
  }

  async getRecipesByDiet(
    dietSuitability: string,
    limit: number = 15,
  ): Promise<NutritionRecipe[]> {
    return this.recipeRepo.find({
      where: { dietSuitability: dietSuitability.toUpperCase() },
      order: { viewCount: 'DESC' },
      take: limit,
    });
  }

  async getPostCovidNutritionTips(): Promise<{
    tips: string[];
    recipes: NutritionRecipe[];
    resources: string[];
  }> {
    const recipes = await this.recipeRepo.find({
      where: { dietSuitability: 'POST_COVID_RECOVERY' },
      order: { viewCount: 'DESC' },
      take: 5,
    });

    return {
      tips: [
        'Include protein-rich foods like dal, chicken, eggs',
        'Add turmeric and ginger for anti-inflammatory benefits',
        'Stay hydrated with herbal teas',
        'Include vitamin C rich fruits like oranges, kiwi',
        'Avoid heavy, fried, and spicy foods initially',
        'Eat small, frequent meals',
        'Include probiotic foods for gut health',
        'Add iron-rich foods to combat anemia',
      ],
      recipes,
      resources: [
        'https://example.com/covid-nutrition-guide',
        'https://example.com/recovery-meal-plans',
      ],
    };
  }

  async recordRecipeView(recipeId: string): Promise<void> {
    const recipe = await this.recipeRepo.findOne({ where: { id: recipeId } });
    if (recipe) {
      recipe.viewCount += 1;
      await this.recipeRepo.save(recipe);
    }
  }
}
