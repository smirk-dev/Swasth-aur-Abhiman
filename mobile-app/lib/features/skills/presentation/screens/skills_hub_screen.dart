import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Skill Course Model
class SkillCourse {
  final String id;
  final String title;
  final String description;
  final String category;
  final String? difficulty;
  final int? durationSeconds;
  final int viewCount;
  final String? thumbnailUrl;
  final String? language;

  SkillCourse({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.difficulty,
    this.durationSeconds,
    required this.viewCount,
    this.thumbnailUrl,
    this.language,
  });

  factory SkillCourse.fromJson(Map<String, dynamic> json) {
    return SkillCourse(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'] ?? json['subCategory'],
      difficulty: json['difficulty'],
      durationSeconds: json['durationSeconds'],
      viewCount: json['viewCount'] ?? 0,
      thumbnailUrl: json['thumbnailUrl'],
      language: json['language'],
    );
  }
}

class SkillCategory {
  final String id;
  final String name;
  final String description;
  final String icon;
  final SkillCourse? topCourse;

  SkillCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.topCourse,
  });

  factory SkillCategory.fromJson(Map<String, dynamic> json) {
    return SkillCategory(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      topCourse: json['topCourse'] != null
          ? SkillCourse.fromJson(json['topCourse'])
          : null,
    );
  }
}

// Riverpod Providers
final skillCategoriesProvider = FutureProvider<List<SkillCategory>>((ref) async {
  // TODO: Fetch from API /skills/categories
  return [];
});

final skillContentProvider =
    FutureProvider.family<List<SkillCourse>, String>((ref, categoryId) async {
  // TODO: Fetch from API /skills/:categoryId/content
  return [];
});

final skillsSearchProvider =
    FutureProvider.family<List<SkillCourse>, String>((ref, query) async {
  // TODO: Fetch from API /skills/search?query=:query
  return [];
});

final trendingSkillsProvider = FutureProvider<List<SkillCourse>>((ref) async {
  // TODO: Fetch from API /skills/trending
  return [];
});

// Skills Hub Screen
class SkillsHubScreen extends ConsumerStatefulWidget {
  const SkillsHubScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SkillsHubScreen> createState() => _SkillsHubScreenState();
}

class _SkillsHubScreenState extends ConsumerState<SkillsHubScreen> {
  final searchController = TextEditingController();
  String? selectedCategory;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(skillCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Skills & Training'),
        elevation: 0,
      ),
      body: categoriesAsync.when(
        data: (categories) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search skills...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 24),

              // Featured Skills Section
              if (categories.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Featured Skills',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.take(5).length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: _buildFeaturedCard(context, category),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),

              // All Categories
              Text(
                'All Training Programs',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildCategoryCard(context, category),
                  );
                },
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildFeaturedCard(BuildContext context, SkillCategory category) {
    return Card(
      child: InkWell(
        onTap: () => _navigateToCategory(context, category.id),
        child: Container(
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: category.topCourse?.thumbnailUrl != null
                ? DecorationImage(
                    image: NetworkImage(category.topCourse!.thumbnailUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black26,
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, SkillCategory category) {
    final iconMap = {
      'bamboo': Icons.nature,
      'bee': Icons.pets,
      'palette': Icons.palette,
      'work': Icons.work,
      'workspaces': Icons.workspaces,
    };

    return Card(
      child: InkWell(
        onTap: () => _navigateToCategory(context, category.id),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      iconMap[category.icon] ?? Icons.school,
                      color: Colors.blue,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          category.description,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToCategory(BuildContext context, String categoryId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SkillCategoryScreen(categoryId: categoryId),
      ),
    );
  }
}

// Skills Category Screen
class SkillCategoryScreen extends ConsumerStatefulWidget {
  final String categoryId;

  const SkillCategoryScreen({
    Key? key,
    required this.categoryId,
  }) : super(key: key);

  @override
  ConsumerState<SkillCategoryScreen> createState() =>
      _SkillCategoryScreenState();
}

class _SkillCategoryScreenState extends ConsumerState<SkillCategoryScreen> {
  String? selectedDifficulty;

  @override
  Widget build(BuildContext context) {
    final skillsAsync = ref.watch(skillContentProvider(widget.categoryId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Training Program'),
        elevation: 0,
      ),
      body: skillsAsync.when(
        data: (skills) => Column(
          children: [
            // Difficulty Filter
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Difficulty Level',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['Beginner', 'Intermediate', 'Advanced']
                        .map((level) => FilterChip(
                          label: Text(level),
                          selected: selectedDifficulty == level,
                          onSelected: (selected) {
                            setState(() {
                              selectedDifficulty =
                                  selected ? level : null;
                            });
                          },
                        ))
                        .toList(),
                  ),
                ],
              ),
            ),
            // Courses List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: skills.length,
                itemBuilder: (context, index) {
                  final skill = skills[index];
                  if (selectedDifficulty != null &&
                      skill.difficulty != selectedDifficulty) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildCourseCard(context, skill),
                  );
                },
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, SkillCourse course) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // TODO: Navigate to video player
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (course.thumbnailUrl != null)
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  course.thumbnailUrl!,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    course.description,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (course.difficulty != null)
                        Chip(
                          label: Text(course.difficulty!),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          labelPadding: EdgeInsets.zero,
                        ),
                      const Spacer(),
                      Icon(Icons.play_circle_outline,
                          size: 20, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      if (course.durationSeconds != null)
                        Text(
                          '${(course.durationSeconds! ~/ 60)} min',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
