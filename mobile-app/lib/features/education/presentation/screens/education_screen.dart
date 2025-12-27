import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/media_models.dart';
import '../../../../core/providers/media_provider.dart';
import '../widgets/class_selector.dart';
import '../widgets/subject_card.dart';
import '../widgets/education_content_list.dart';
import '../widgets/pdf_viewer_screen.dart';

class EducationScreen extends ConsumerStatefulWidget {
  const EducationScreen({super.key});

  @override
  ConsumerState<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends ConsumerState<EducationScreen> {
  int? _selectedClass;
  String? _selectedSubject;

  @override
  void initState() {
    super.initState();
    // Load education content
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mediaProvider.notifier).loadCategory('EDUCATION');
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaState = ref.watch(mediaProvider);
    final educationContent = mediaState.getByCategory('EDUCATION');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Education Hub'),
        actions: [
          if (_selectedClass != null || _selectedSubject != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _selectedClass = null;
                  _selectedSubject = null;
                });
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Header Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade700, Colors.blue.shade500],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.school, color: Colors.white, size: 28),
                    SizedBox(width: 12),
                    Text(
                      'NCERT Books & Educational Content',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Access curriculum for Classes 1-12',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),

          // Class Selector
          ClassSelector(
            selectedClass: _selectedClass,
            onClassSelected: (classNum) {
              setState(() {
                _selectedClass = classNum;
                _selectedSubject = null;
              });
            },
          ),

          // Subject Selector (if class is selected)
          if (_selectedClass != null)
            SubjectSelector(
              selectedSubject: _selectedSubject,
              onSubjectSelected: (subject) {
                setState(() {
                  _selectedSubject = subject;
                });
              },
            ),

          // Content Area
          Expanded(
            child: mediaState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : _selectedClass == null
                    ? _buildClassOverview()
                    : _selectedSubject == null
                        ? _buildSubjectGrid()
                        : EducationContentList(
                            content: _filterContent(educationContent),
                            onContentTap: (content) => _openContent(context, content),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassOverview() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        final classNum = index + 1;
        return Card(
          child: InkWell(
            onTap: () {
              setState(() => _selectedClass = classNum);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blue.shade100,
                  child: Text(
                    '$classNum',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Class $classNum',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubjectGrid() {
    final subjects = [
      {'name': 'Mathematics', 'icon': Icons.calculate, 'color': Colors.blue},
      {'name': 'Science', 'icon': Icons.science, 'color': Colors.green},
      {'name': 'English', 'icon': Icons.menu_book, 'color': Colors.orange},
      {'name': 'Hindi', 'icon': Icons.translate, 'color': Colors.red},
      {'name': 'Social Science', 'icon': Icons.public, 'color': Colors.purple},
      {'name': 'EVS', 'icon': Icons.eco, 'color': Colors.teal},
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        final subject = subjects[index];
        return SubjectCard(
          name: subject['name'] as String,
          icon: subject['icon'] as IconData,
          color: subject['color'] as Color,
          onTap: () {
            setState(() => _selectedSubject = subject['name'] as String);
          },
        );
      },
    );
  }

  List<MediaContent> _filterContent(List<MediaContent> content) {
    return content.where((item) {
      if (_selectedClass != null && _selectedSubject != null) {
        final expectedSubCat = 'Class $_selectedClass - $_selectedSubject';
        return item.subCategory == expectedSubCat;
      }
      return true;
    }).toList();
  }

  void _openContent(BuildContext context, MediaContent content) {
    ref.read(mediaProvider.notifier).trackView(content.id);
    
    if (content.isPdf) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PdfViewerScreen(
            title: content.title,
            pdfUrl: content.mediaUrl,
          ),
        ),
      );
    } else if (content.isVideo) {
      // TODO: Open video player
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Opening video...')),
      );
    }
  }
}
