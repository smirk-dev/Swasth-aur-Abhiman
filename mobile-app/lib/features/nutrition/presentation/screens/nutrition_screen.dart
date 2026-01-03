import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/media_provider.dart';
import '../widgets/nutrition_category_card.dart';
import '../widgets/nutrition_tips_section.dart';
import '../widgets/diet_plan_section.dart';
import '../widgets/nutrition_content_screen.dart';

class NutritionScreen extends ConsumerStatefulWidget {
  const NutritionScreen({super.key});

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mediaProvider.notifier).loadCategory('NUTRITION');
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition & Diet'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.restaurant_menu), text: 'Diet Plans'),
            Tab(icon: Icon(Icons.video_library), text: 'Videos'),
            Tab(icon: Icon(Icons.lightbulb_outline), text: 'Tips'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _DietPlansTab(),
          _VideosTab(),
          const NutritionTipsSection(),
        ],
      ),
    );
  }
}

class _DietPlansTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post-COVID Recovery Section (PRD Priority)
          _buildSectionHeader(
            context,
            'Post-COVID Recovery Diet',
            Icons.coronavirus_outlined,
            Colors.red,
          ),
          const SizedBox(height: 12),
          const DietPlanSection(
            title: 'Recovery Diet Plan',
            description: 'Specially designed diet for post-COVID recovery focusing on immunity building and strength restoration.',
            meals: [
              DietMeal(
                time: 'Early Morning (6:00 AM)',
                items: ['Warm water with lemon & honey', 'Tulsi leaves (3-4)', 'Soaked almonds (5-6)'],
                benefits: 'Detoxification, Immunity boost',
              ),
              DietMeal(
                time: 'Breakfast (8:00 AM)',
                items: ['Moong dal chilla / Besan chilla', 'Seasonal vegetables', 'Curd (1 cup)', 'Fresh fruit'],
                benefits: 'Protein, Probiotics, Vitamins',
              ),
              DietMeal(
                time: 'Mid-Morning (11:00 AM)',
                items: ['Coconut water', 'Dry fruits (10-15g)', 'Giloy juice (if available)'],
                benefits: 'Hydration, Energy, Immunity',
              ),
              DietMeal(
                time: 'Lunch (1:00 PM)',
                items: ['Daliya khichdi / Brown rice', 'Mixed dal', 'Green vegetables', 'Salad with lemon'],
                benefits: 'Complex carbs, Protein, Fiber',
              ),
              DietMeal(
                time: 'Evening (4:00 PM)',
                items: ['Kadha (herbal tea)', 'Roasted chana / Makhana', 'Fresh seasonal fruit'],
                benefits: 'Antioxidants, Light energy',
              ),
              DietMeal(
                time: 'Dinner (7:00 PM)',
                items: ['Roti (2)', 'Light vegetable curry', 'Dal / Paneer', 'Warm milk with turmeric'],
                benefits: 'Easy digestion, Better sleep',
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Anemia Diet Section (PRD Priority)
          _buildSectionHeader(
            context,
            'Anemia Diet Plan',
            Icons.bloodtype,
            Colors.pink,
          ),
          const SizedBox(height: 12),
          const DietPlanSection(
            title: 'Iron-Rich Diet',
            description: 'Diet plan focused on increasing iron and hemoglobin levels, especially designed for women and children.',
            meals: [
              DietMeal(
                time: 'Early Morning',
                items: ['Soaked black raisins (10)', 'Soaked fenugreek seeds water', 'Amla juice (30ml)'],
                benefits: 'Iron absorption, Vitamin C',
              ),
              DietMeal(
                time: 'Breakfast',
                items: ['Poha with peanuts', 'Jaggery (small piece)', 'Banana', 'Sprouts salad'],
                benefits: 'Iron, Folic acid, Energy',
              ),
              DietMeal(
                time: 'Mid-Morning',
                items: ['Pomegranate juice', 'Dates (3-4)', 'Moringa powder milk'],
                benefits: 'Hemoglobin boost, Iron',
              ),
              DietMeal(
                time: 'Lunch',
                items: ['Bajra/Jowar roti', 'Leafy greens (palak/methi)', 'Chana masala', 'Lemon rice'],
                benefits: 'Iron, Vitamin C for absorption',
              ),
              DietMeal(
                time: 'Evening',
                items: ['Sesame ladoo', 'Beetroot juice', 'Roasted groundnuts'],
                benefits: 'Iron, Folic acid, Protein',
              ),
              DietMeal(
                time: 'Dinner',
                items: ['Palak paneer / Methi dal', 'Roti', 'Kheera raita', 'Dates milk'],
                benefits: 'Iron, Calcium, Protein',
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // General Healthy Diet
          _buildSectionHeader(
            context,
            'Balanced Daily Diet',
            Icons.eco,
            Colors.green,
          ),
          const SizedBox(height: 12),
          const DietPlanSection(
            title: 'General Health Diet',
            description: 'A balanced nutritional plan suitable for everyday health maintenance.',
            meals: [
              DietMeal(
                time: 'Morning',
                items: ['Warm water', 'Seasonal fruit', 'Nuts (10g)'],
                benefits: 'Metabolism boost, Vitamins',
              ),
              DietMeal(
                time: 'Breakfast',
                items: ['Paratha / Idli / Upma', 'Curd / Chutney', 'Milk / Tea'],
                benefits: 'Energy, Probiotics, Protein',
              ),
              DietMeal(
                time: 'Lunch',
                items: ['Rice / Roti (2-3)', 'Dal', 'Vegetable sabzi', 'Salad'],
                benefits: 'Complete nutrition',
              ),
              DietMeal(
                time: 'Dinner',
                items: ['Roti (2)', 'Light sabzi', 'Dal / Paneer'],
                benefits: 'Light, digestible',
              ),
            ],
          ),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _VideosTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaState = ref.watch(mediaProvider);
    final content = mediaState.getByCategory('NUTRITION');
    final isLoading = mediaState.isLoading;

    // Nutrition categories from PRD
    final categories = [
      NutritionCategoryItem(
        id: 'post_covid',
        title: 'Post-COVID Recovery',
        icon: '🦠',
        color: Colors.red,
        description: 'Nutrition videos for recovering from COVID-19',
      ),
      NutritionCategoryItem(
        id: 'anemia',
        title: 'Anemia Diet',
        icon: '🩸',
        color: Colors.pink,
        description: 'Iron-rich foods and recipes for anemia prevention',
      ),
      NutritionCategoryItem(
        id: 'pregnancy',
        title: 'Pregnancy Nutrition',
        icon: '🤰',
        color: Colors.purple,
        description: 'Healthy diet during pregnancy and lactation',
      ),
      NutritionCategoryItem(
        id: 'children',
        title: 'Child Nutrition',
        icon: '👶',
        color: Colors.blue,
        description: 'Balanced diet for growing children',
      ),
      NutritionCategoryItem(
        id: 'diabetes',
        title: 'Diabetes Diet',
        icon: '🍎',
        color: Colors.orange,
        description: 'Low glycemic foods and meal planning',
      ),
      NutritionCategoryItem(
        id: 'general',
        title: 'General Wellness',
        icon: '🥗',
        color: Colors.green,
        description: 'General healthy eating tips and recipes',
      ),
    ];

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final categoryContent = content
                  .where((c) => c.subCategory == category.id)
                  .toList();
              
              return NutritionCategoryCard(
                category: category,
                videoCount: categoryContent.length,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NutritionContentScreen(
                        categoryId: category.id,
                        title: category.title,
                      ),
                    ),
                  );
                },
              );
            },
          );
  }
}

class NutritionCategoryItem {
  final String id;
  final String title;
  final String icon;
  final Color color;
  final String description;

  const NutritionCategoryItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
  });
}
