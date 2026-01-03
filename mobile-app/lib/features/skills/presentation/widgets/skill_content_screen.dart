import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/models/media_models.dart';
import '../../../../core/providers/media_provider.dart';
import '../../data/skill_playlists.dart';
import 'video_player_screen.dart';

class SkillContentScreen extends ConsumerStatefulWidget {
  final String categoryId;
  final String title;

  const SkillContentScreen({
    super.key,
    required this.categoryId,
    required this.title,
  });

  @override
  ConsumerState<SkillContentScreen> createState() => _SkillContentScreenState();
}

class _SkillContentScreenState extends ConsumerState<SkillContentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mediaProvider.notifier).loadSubCategory('SKILL', widget.categoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaState = ref.watch(mediaProvider);
    final content = mediaState.getByCategory('SKILL:${widget.categoryId}');
    final isLoading = mediaState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : content.isEmpty
              ? _buildEmptyState()
              : _buildContentList(content),
    );
  }

  Widget _buildEmptyState() {
    final playlist = SkillPlaylists.getPlaylist(widget.categoryId) ?? SkillPlaylists.getPlaylist(widget.title);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.video_library_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'No training videos available yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for ${widget.title} content',
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          if (playlist != null)
            ElevatedButton.icon(
              onPressed: () async {
                final uri = Uri.parse(playlist);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open playlist')));
                }
              },
              icon: const Icon(Icons.playlist_play),
              label: const Text('Open Playlist'),
            ),
        ],
      ),
    );
  }

  Widget _buildContentList(List<MediaContent> content) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: content.length,
      itemBuilder: (context, index) {
        final video = content[index];
        return _VideoCard(
          video: video,
          onTap: () => _openVideo(video),
        );
      },
    );
  }

  void _openVideo(MediaContent video) {
    ref.read(mediaProvider.notifier).trackView(video.id);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoPlayerScreen(
          title: video.title,
          videoUrl: video.mediaUrl,
          description: video.description,
        ),
      ),
    );
  }
}

class _VideoCard extends StatelessWidget {
  final MediaContent video;
  final VoidCallback onTap;

  const _VideoCard({
    required this.video,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Container(
              height: 180,
              width: double.infinity,
              color: Colors.grey[300],
              child: Stack(
                fit: StackFit.expand,
                children: [
                  video.thumbnailUrl != null
                      ? Image.network(
                          video.thumbnailUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildPlaceholder(),
                        )
                      : _buildPlaceholder(),
                  // Play button overlay
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // View count
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.visibility, size: 14, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            '${video.viewCount}',
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    video.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: Icon(
        Icons.video_library,
        size: 48,
        color: Colors.grey[500],
      ),
    );
  }
}
