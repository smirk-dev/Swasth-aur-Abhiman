import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Query,
  UseGuards,
  Request,
} from '@nestjs/common';
import { NutritionService } from './nutrition.service';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';

@Controller('nutrition')
export class NutritionController {
  constructor(private nutritionService: NutritionService) {}

  // ===== NUTRITION PLANS =====

  @UseGuards(JwtAuthGuard)
  @Post('plans')
  async createPlan(
    @Request() req,
    @Body()
    body: {
      title: string;
      description: string;
      dietType:
        | 'VEGETARIAN'
        | 'NON_VEGETARIAN'
        | 'VEGAN'
        | 'DIABETIC'
        | 'LOW_CALORIE';
      goal:
        | 'WEIGHT_LOSS'
        | 'WEIGHT_GAIN'
        | 'MUSCLE_BUILDING'
        | 'RECOVERY'
        | 'MAINTENANCE';
      targetCalories?: number;
      targetProteinGrams?: number;
      targetCarbsGrams?: number;
      targetFatsGrams?: number;
    },
  ) {
    return this.nutritionService.createNutritionPlan(req.user, body);
  }

  @UseGuards(JwtAuthGuard)
  @Get('plans/active')
  async getActivePlan(@Request() req) {
    return this.nutritionService.getUserActivePlan(req.user.id);
  }

  @UseGuards(JwtAuthGuard)
  @Get('plans')
  async getUserPlans(@Request() req) {
    return this.nutritionService.getNutritionPlansByUser(req.user.id);
  }

  @UseGuards(JwtAuthGuard)
  @Post('plans/:planId')
  async updatePlan(
    @Param('planId') planId: string,
    @Body() body: Partial<any>,
  ) {
    return this.nutritionService.updateNutritionPlan(planId, body);
  }

  // ===== MEAL PLANS =====

  @UseGuards(JwtAuthGuard)
  @Post('meal-plans/:planId')
  async createMealPlan(
    @Param('planId') planId: string,
    @Body()
    body: {
      dayNumber: number;
      meals: Array<{
        mealType: 'BREAKFAST' | 'LUNCH' | 'SNACK' | 'DINNER';
        foods: string[];
        recipeUrl?: string;
        estimatedCalories?: number;
        nutritionInfo?: string;
      }>;
    },
  ) {
    return this.nutritionService.createMealPlan(
      planId,
      body.dayNumber,
      body.meals,
    );
  }

  @UseGuards(JwtAuthGuard)
  @Get('meal-plans/:planId/day/:dayNumber')
  async getMealPlanForDay(
    @Param('planId') planId: string,
    @Param('dayNumber') dayNumber: number,
  ) {
    return this.nutritionService.getMealPlansForDay(planId, +dayNumber);
  }

  @UseGuards(JwtAuthGuard)
  @Get('meal-plans/:planId/week')
  async getWeeklyMealPlan(@Param('planId') planId: string) {
    return this.nutritionService.getWeeklyMealPlan(planId);
  }

  // ===== MEAL LOGGING =====

  @UseGuards(JwtAuthGuard)
  @Post('logs/meal')
  async logMeal(
    @Request() req,
    @Body()
    body: {
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
  ) {
    return this.nutritionService.logMeal(req.user, body);
  }

  @UseGuards(JwtAuthGuard)
  @Get('logs/today')
  async getTodayLogs(@Request() req) {
    return this.nutritionService.getTodayMealLogs(req.user.id);
  }

  @UseGuards(JwtAuthGuard)
  @Get('summary')
  async getNutritionSummary(
    @Request() req,
    @Query('days') days = 7,
  ) {
    return this.nutritionService.getNutritionSummary(req.user.id, +days);
  }

  // ===== RECIPES =====

  @Get('recipes/popular')
  async getPopularRecipes(@Query('limit') limit = 10) {
    return this.nutritionService.getPopularRecipes(+limit);
  }

  @Get('recipes/search')
  async searchRecipes(
    @Query('query') query: string,
    @Query('diet') diet?: string,
    @Query('limit') limit = 20,
  ) {
    return this.nutritionService.searchRecipes(query, diet, +limit);
  }

  @Get('recipes/diet/:dietType')
  async getRecipesByDiet(
    @Param('dietType') dietType: string,
    @Query('limit') limit = 15,
  ) {
    return this.nutritionService.getRecipesByDiet(dietType, +limit);
  }

  @Get('recipes/:recipeId/view')
  async viewRecipe(@Param('recipeId') recipeId: string) {
    await this.nutritionService.recordRecipeView(recipeId);
    return { message: 'Recipe view recorded' };
  }

  // ===== POST-COVID RESOURCES =====

  @Get('post-covid/tips')
  async getPostCovidTips() {
    return this.nutritionService.getPostCovidNutritionTips();
  }

  @Get('post-covid/meal-plans')
  async getPostCovidMealPlans(@Query('limit') limit = 10) {
    return this.nutritionService.getRecipesByDiet('POST_COVID_RECOVERY', +limit);
  }
}
