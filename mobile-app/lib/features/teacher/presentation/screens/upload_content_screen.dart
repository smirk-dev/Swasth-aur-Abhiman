import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/teacher_provider.dart';

class UploadContentScreen extends ConsumerStatefulWidget {
  const UploadContentScreen({super.key});

  @override
  ConsumerState<UploadContentScreen> createState() =>
      _UploadContentScreenState();
}

class _UploadContentScreenState extends ConsumerState<UploadContentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _videoUrlController = TextEditingController();
  final _thumbnailUrlController = TextEditingController();
  
  String _selectedCategory = 'Class 1-5';
  bool _isSubmitting = false;

  final _categories = [
    'Class 1-5',
    'Class 6-8',
    'Class 9-10',
    'Class 11-12',
    'Competitive',
    'Other',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _videoUrlController.dispose();
    _thumbnailUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Content'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter video title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter video description',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Category dropdown
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedCategory = value!);
              },
            ),
            const SizedBox(height: 16),

            // Video URL
            TextFormField(
              controller: _videoUrlController,
              decoration: const InputDecoration(
                labelText: 'Video URL',
                hintText: 'Enter YouTube or video URL',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.video_library),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter a video URL';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Thumbnail URL (optional)
            TextFormField(
              controller: _thumbnailUrlController,
              decoration: const InputDecoration(
                labelText: 'Thumbnail URL (optional)',
                hintText: 'Enter thumbnail image URL',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.image),
              ),
            ),
            const SizedBox(height: 24),

            // Upload info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[600]),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Videos will be available to students in the education section after upload.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Submit button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Upload Content'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final success = await ref.read(teacherProvider.notifier).uploadContent(
          title: _titleController.text,
          description: _descriptionController.text,
          category: 'EDUCATION',
          subcategory: _selectedCategory,
          videoUrl: _videoUrlController.text,
          thumbnailUrl: _thumbnailUrlController.text.isEmpty
              ? null
              : _thumbnailUrlController.text,
        );

    setState(() => _isSubmitting = false);

    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Content uploaded successfully!')),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload content')),
      );
    }
  }
}
