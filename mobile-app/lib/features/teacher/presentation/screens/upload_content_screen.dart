import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  String? _detectedThumbnailUrl;
  bool _isValidYouTubeUrl = false;

  final _categories = [
    'Class 1-5',
    'Class 6-8',
    'Class 9-10',
    'Class 11-12',
    'Competitive',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _videoUrlController.addListener(_onVideoUrlChanged);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _videoUrlController.dispose();
    _thumbnailUrlController.dispose();
    super.dispose();
  }

  void _onVideoUrlChanged() {
    final url = _videoUrlController.text;
    final videoId = _extractYoutubeVideoId(url);
    
    setState(() {
      _isValidYouTubeUrl = videoId != null;
      if (videoId != null) {
        _detectedThumbnailUrl = 'https://img.youtube.com/vi/$videoId/mqdefault.jpg';
      } else {
        _detectedThumbnailUrl = null;
      }
    });
  }

  String? _extractYoutubeVideoId(String url) {
    if (url.isEmpty) return null;
    
    final regExp = RegExp(
      r'^.*(?:youtu\.be\/|youtube\.com\/(?:watch\?v=|embed\/|v\/|shorts\/))([a-zA-Z0-9_-]{11}).*$',
      caseSensitive: false,
    );
    
    final match = regExp.firstMatch(url);
    return match?.group(1);
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
              decoration: InputDecoration(
                labelText: 'Video URL',
                hintText: 'Paste YouTube or video URL here',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.video_library),
                suffixIcon: _isValidYouTubeUrl
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : null,
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter a video URL';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            
            // YouTube URL examples
            Text(
              'Supported: youtube.com/watch?v=..., youtu.be/..., youtube.com/shorts/...',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),

            // Thumbnail Preview
            if (_detectedThumbnailUrl != null || _thumbnailUrlController.text.isNotEmpty) ...[
              const Text(
                'Thumbnail Preview',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    imageUrl: _thumbnailUrlController.text.isNotEmpty
                        ? _thumbnailUrlController.text
                        : _detectedThumbnailUrl!,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (_isValidYouTubeUrl && _thumbnailUrlController.text.isEmpty)
                Row(
                  children: [
                    Icon(Icons.auto_awesome, size: 16, color: Colors.green[600]),
                    const SizedBox(width: 4),
                    Text(
                      'YouTube thumbnail auto-detected',
                      style: TextStyle(fontSize: 12, color: Colors.green[600]),
                    ),
                  ],
                ),
              const SizedBox(height: 16),
            ],

            // Thumbnail URL (optional)
            TextFormField(
              controller: _thumbnailUrlController,
              decoration: const InputDecoration(
                labelText: 'Custom Thumbnail URL (optional)',
                hintText: 'Leave empty to use YouTube thumbnail',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.image),
              ),
              onChanged: (_) => setState(() {}),
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
