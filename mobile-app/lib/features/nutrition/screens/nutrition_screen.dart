import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

// Models
class NutritionPlan {
  final String id;
  final String title;
  final String dietType;
  final String goal;
  final int? targetCalories;
  final int? targetProtein;
  final int? targetCarbs;
  final int? targetFats;
  final String status;

  NutritionPlan({
    required this.id,
    required this.title,
    required this.dietType,
    required this.goal,
    this.targetCalories,
    this.targetProtein,
    this.targetCarbs,
    this.targetFats,
    required this.status,
  });

  factory NutritionPlan.fromJson(Map<String, dynamic> json) {
    return NutritionPlan(
      id: json['id'],
      title: json['title'],
      dietType: json['dietType'],
      goal: json['goal'],
      targetCalories: json['targetCalories'],
      targetProtein: json['targetProteinGrams'],
      targetCarbs: json['targetCarbsGrams'],
      targetFats: json['targetFatsGrams'],
      status: json['status'],
    );
  }
}

class MealLog {
  final String id;
  final String mealType;
  final String foodItem;
  final int? calories;
  final int? protein;
  final int? carbs;
  final int? fats;
  final DateTime createdAt;

  MealLog({
    required this.id,
    required this.mealType,
    required this.foodItem,
    this.calories,
    this.protein,
    this.carbs,
    this.fats,
    required this.createdAt,
  });

  factory MealLog.fromJson(Map<String, dynamic> json) {
    return MealLog(
      id: json['id'],
      mealType: json['mealType'],
      foodItem: json['foodItem'],
      calories: json['estimatedCalories'],
      protein: json['proteinGrams'],
      carbs: json['carbsGrams'],
      fats: json['fatsGrams'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

// Providers
final nutritionPlanProvider =
    FutureProvider<NutritionPlan?>((ref) async {
  // TODO: Fetch from API /nutrition/plans/active
  return null;
});

final todayMealsProvider = FutureProvider<({
  List<MealLog> logs,
  int totalCalories,
  int totalProtein,
  int totalCarbs,
  int totalFats,
})>((ref) async {
  // TODO: Fetch from API /nutrition/logs/today
  return (
    logs: <MealLog>[],
    totalCalories: 0,
    totalProtein: 0,
    totalCarbs: 0,
    totalFats: 0
  );
});

final nutritionSummaryProvider = FutureProvider<({
  int averageDailyCalories,
  int averageDailyProtein,
  int averageDailyCarbs,
  int averageDailyFats,
  int mealsTaken,
  int completionRate,
})>((ref) async {
  // TODO: Fetch from API /nutrition/summary
  return (
    averageDailyCalories: 0,
    averageDailyProtein: 0,
    averageDailyCarbs: 0,
    averageDailyFats: 0,
    mealsTaken: 0,
    completionRate: 0
  );
});

// Nutrition Screen
class NutritionScreen extends ConsumerStatefulWidget {
  const NutritionScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends ConsumerState<NutritionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final planAsync = ref.watch(nutritionPlanProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition & Diet'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Today'),
            Tab(text: 'Progress'),
            Tab(text: 'Recipes'),
          ],
        ),
      ),
      body: planAsync.when(
        data: (plan) => TabBarView(
          controller: _tabController,
          children: [
            _buildTodayTab(context, plan),
            _buildProgressTab(context, plan),
            _buildRecipesTab(context),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMealDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTodayTab(BuildContext context, NutritionPlan? plan) {
    final mealsAsync = ref.watch(todayMealsProvider);

    return mealsAsync.when(
      data: (mealData) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plan Summary Card
            if (plan != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${plan.dietType} • Goal: ${plan.goal}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Target: ${plan.targetCalories ?? 2000} cal/day',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Today's Macro Breakdown
            _buildMacroBreakdownChart(context, mealData),
            const SizedBox(height: 16),

            // Calorie Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${mealData.totalCalories}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        'Consumed',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${plan?.targetCalories ?? 2000}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Target',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      value: (mealData.totalCalories / (plan?.targetCalories ?? 2000))
                          .clamp(0.0, 1.0),
                      strokeWidth: 6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Meals List
            Text(
              'Meals Logged (${mealData.logs.length})',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            if (mealData.logs.isEmpty)
              Center(
                child: Text(
                  'No meals logged today',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: mealData.logs.length,
                itemBuilder: (context, index) {
                  final meal = mealData.logs[index];
                  return _buildMealCard(context, meal);
                },
              ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildProgressTab(BuildContext context, NutritionPlan? plan) {
    final summaryAsync = ref.watch(nutritionSummaryProvider);

    return summaryAsync.when(
      data: (summary) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '7-Day Average',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            // Macro Distribution Chart
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Macros',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              color: Colors.red,
                              value: summary.averageDailyProtein.toDouble(),
                              title: 'Protein',
                              radius: 50,
                            ),
                            PieChartSectionData(
                              color: Colors.green,
                              value: summary.averageDailyCarbs.toDouble(),
                              title: 'Carbs',
                              radius: 50,
                            ),
                            PieChartSectionData(
                              color: Colors.yellow,
                              value: summary.averageDailyFats.toDouble(),
                              title: 'Fats',
                              radius: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Summary Stats
            _buildStatCard(
              'Average Calories',
              '${summary.averageDailyCalories} cal',
              Colors.blue,
            ),
            const SizedBox(height: 8),
            _buildStatCard(
              'Protein',
              '${summary.averageDailyProtein}g',
              Colors.red,
            ),
            const SizedBox(height: 8),
            _buildStatCard(
              'Carbohydrates',
              '${summary.averageDailyCarbs}g',
              Colors.green,
            ),
            const SizedBox(height: 8),
            _buildStatCard(
              'Fats',
              '${summary.averageDailyFats}g',
              Colors.yellow,
            ),
            const SizedBox(height: 16),

            // Completion Rate
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Plan Completion',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        '${summary.completionRate}%',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (summary.completionRate / 100).clamp(0.0, 1.0),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildRecipesTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Popular Recipes Section
          Text(
            'Popular Recipes',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Card(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 150,
                        color: Colors.grey[300],
                        child: Center(
                          child: Text('Recipe ${index + 1}'),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // Post-COVID Tips
          Text(
            'Post-COVID Recovery Tips',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTip('Include protein-rich foods daily'),
                  _buildTip('Add turmeric and ginger for anti-inflammatory benefits'),
                  _buildTip('Stay hydrated with herbal teas'),
                  _buildTip('Include vitamin C rich fruits'),
                  _buildTip('Eat small, frequent meals'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroBreakdownChart(BuildContext context, dynamic mealData) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Macro Breakdown',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMacroBox('Protein', mealData.totalProtein, 'g', Colors.red),
                _buildMacroBox('Carbs', mealData.totalCarbs, 'g', Colors.green),
                _buildMacroBox('Fats', mealData.totalFats, 'g', Colors.yellow),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroBox(
    String label,
    int value,
    String unit,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            '$value',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(unit, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildMealCard(BuildContext context, MealLog meal) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getMealIcon(meal.mealType),
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.foodItem,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  Text(
                    meal.mealType,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Text(
              '${meal.calories ?? 0} cal',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }

  Widget _buildTip(String tip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, size: 18, color: Colors.green),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getMealIcon(String mealType) {
    switch (mealType.toUpperCase()) {
      case 'BREAKFAST':
        return Icons.wb_sunny;
      case 'LUNCH':
        return Icons.sunny;
      case 'SNACK':
        return Icons.cake;
      case 'DINNER':
        return Icons.nightlight_round;
      default:
        return Icons.restaurant;
    }
  }

  void _showAddMealDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Meal'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Food Item',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Calories',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Log meal
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
