import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/media_models.dart';
import '../../../../core/providers/media_provider.dart';
import '../widgets/skill_category_card.dart';
import '../widgets/skill_content_screen.dart';

class SkillsScreen extends ConsumerStatefulWidget {
  const SkillsScreen({super.key});

  @override
  ConsumerState<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends ConsumerState<SkillsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mediaProvider.notifier).loadCategory('SKILL');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skills & Training'),
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade700, Colors.orange.shade500],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.construction, color: Colors.white, size: 28),
                    SizedBox(width: 12),
                    Text(
                      'Vocational Training',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Learn traditional skills and crafts',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Categories Grid
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Choose a Training Category',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Bamboo Training
                SkillCategoryCard(
                  title: 'Bamboo Training',
                  description: 'Learn traditional bamboo crafting techniques including furniture making, basket weaving, and decorative items.',
                  icon: '🎋',
                  color: Colors.green,
                  imageUrl: null,
                  onTap: () => _openCategory(context, 'bamboo', 'Bamboo Training'),
                ),
                
                // Artisan Training
                SkillCategoryCard(
                  title: 'Artisan Training',
                  description: 'Master traditional artisan skills including pottery, woodwork, metalcraft, and other handmade crafts.',
                  icon: '🎨',
                  color: Colors.purple,
                  imageUrl: null,
                  onTap: () => _openCategory(context, 'artisan', 'Artisan Training'),
                ),
                
                // Honeybee Farming
                SkillCategoryCard(
                  title: 'Honeybee Farming',
                  description: 'Complete guide to beekeeping - from setting up hives to harvesting honey and managing bee colonies.',
                  icon: '🐝',
                  color: Colors.amber,
                  imageUrl: null,
                  onTap: () => _openCategory(context, 'honeybee', 'Honeybee Farming'),
                ),
                
                // Jutework
                SkillCategoryCard(
                  title: 'Jutework',
                  description: 'Learn jute crafting techniques to create bags, rugs, wall hangings, and other eco-friendly products.',
                  icon: '🧶',
                  color: Colors.brown,
                  imageUrl: null,
                  onTap: () => _openCategory(context, 'jute', 'Jutework'),
                ),
                
                // Macrame Work
                SkillCategoryCard(
                  title: 'Macrame Work',
                  description: 'Create beautiful macrame art including plant hangers, wall decor, jewelry, and home accessories.',
                  icon: '🪢',
                  color: Colors.teal,
                  imageUrl: null,
                  onTap: () => _openCategory(context, 'macrame', 'Macrame Work'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openCategory(BuildContext context, String categoryId, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SkillContentScreen(
          categoryId: categoryId,
          title: title,
        ),
      ),
    );
  }
}
