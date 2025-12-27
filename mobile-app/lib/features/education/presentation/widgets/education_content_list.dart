import 'package:flutter/material.dart';
import '../../../../core/models/media_models.dart';

class EducationContentList extends StatelessWidget {
  final List<MediaContent> content;
  final Function(MediaContent) onContentTap;

  const EducationContentList({
    super.key,
    required this.content,
    required this.onContentTap,
  });

  @override
  Widget build(BuildContext context) {
    if (content.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'No content available yet',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for updates',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: content.length,
      itemBuilder: (context, index) {
        final item = content[index];
        return _ContentCard(
          content: item,
          onTap: () => onContentTap(item),
        );
      },
    );
  }
}

class _ContentCard extends StatelessWidget {
  final MediaContent content;
  final VoidCallback onTap;

  const _ContentCard({
    required this.content,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Icon/Thumbnail
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _getTypeColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: content.thumbnailUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          content.thumbnailUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildIcon(),
                        ),
                      )
                    : _buildIcon(),
              ),
              const SizedBox(width: 12),
              
              // Content Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      content.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      content.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _TypeBadge(type: _getTypeLabel()),
                        const SizedBox(width: 8),
                        Icon(Icons.visibility, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          '${content.viewCount}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Arrow
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Icon(
      _getTypeIcon(),
      size: 28,
      color: _getTypeColor(),
    );
  }

  IconData _getTypeIcon() {
    if (content.isPdf) return Icons.picture_as_pdf;
    if (content.isVideo) return Icons.play_circle_filled;
    return Icons.article;
  }

  String _getTypeLabel() {
    if (content.isPdf) return 'PDF';
    if (content.isVideo) return 'Video';
    return 'Article';
  }

  Color _getTypeColor() {
    if (content.isPdf) return Colors.red;
    if (content.isVideo) return Colors.blue;
    return Colors.green;
  }
}

class _TypeBadge extends StatelessWidget {
  final String type;

  const _TypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _getColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        type,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _getColor(),
        ),
      ),
    );
  }

  Color _getColor() {
    switch (type) {
      case 'PDF':
        return Colors.red;
      case 'Video':
        return Colors.blue;
      default:
        return Colors.green;
    }
  }
}
