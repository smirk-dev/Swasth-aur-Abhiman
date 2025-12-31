import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../widgets/cards/education_card.dart';
import '../../../core/models/video.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/services/api_service.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class VideoPlayerScreen extends ConsumerStatefulWidget {
  final Video video;

  const VideoPlayerScreen({Key? key, required this.video}) : super(key: key);

  @override
  ConsumerState<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  Timer? _watchTimer;
  int _watchSeconds = 0;
  double _userRating = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.video.youtubeVideoId,
      flags: const YoutubePlayerFlags(autoPlay: false),
    );

    _controller.addListener(() {
      if (_controller.value.isPlaying) {
        _startWatchTimer();
      } else {
        _stopWatchTimer();
      }
    });
  }

  void _startWatchTimer() {
    _watchTimer ??= Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _watchSeconds++);
    });
  }

  void _stopWatchTimer() {
    _watchTimer?.cancel();
    _watchTimer = null;
  }

  @override
  void dispose() {
    // Send watch analytics
    if (_watchSeconds > 0) {
      final api = ref.read(apiServiceProvider);
      api.trackVideoView(widget.video.id, _watchSeconds);
    }
    _stopWatchTimer();
    _controller.dispose();
    super.dispose();
  }



  void _share() {
    Share.share(widget.video.externalUrl ?? '');
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rate this video'),
        content: RatingBar.builder(
          initialRating: _userRating,
          minRating: 1,
          allowHalfRating: true,
          itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
          onRatingUpdate: (rating) async {
            setState(() => _userRating = rating);
            try {
              final api = ref.read(apiServiceProvider);
              await api.rateVideo(widget.video.id, rating);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Thanks for rating')));
            } catch (_) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit rating')));
            }
            if (!mounted) return;
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  void _bookmark() async {
    final current = _controller.value.position.inSeconds;
    try {
      final api = ref.read(apiServiceProvider);
      await api.addBookmark(widget.video.id, current, null);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bookmarked at ${current}s')));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to bookmark')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.video.title)),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.redAccent,
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: Text(widget.video.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
              IconButton(onPressed: _bookmark, icon: Icon(Icons.bookmark_border)),
              IconButton(onPressed: _showRatingDialog, icon: Icon(Icons.star_border)),
              IconButton(onPressed: _share, icon: Icon(Icons.share)),
            ],
          ),
          SizedBox(height: 8),
          Text(widget.video.description),
          SizedBox(height: 16),
          Text('Watch time: $_watchSeconds s'),
          SizedBox(height: 16),
          Text('Related videos', style: TextStyle(fontWeight: FontWeight.w700)),
          SizedBox(height: 8),
          // Placeholder related videos — should be fetched via API
          EducationCard(
            title: 'Related: Example video',
            subtitle: 'Class 10 • Mathematics',
            thumbnailUrl: widget.video.thumbnailUrl,
            durationSeconds: 420,
            rating: 4.5,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
