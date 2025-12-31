import 'dart:async';
import 'package:flutter/material.dart';
import 'package:record/record.dart' as record_pkg;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceRecorder extends StatefulWidget {
  final Function(String path, int duration) onRecordingComplete;
  final VoidCallback onCancel;

  const VoiceRecorder({
    super.key,
    required this.onRecordingComplete,
    required this.onCancel,
  });

  @override
  State<VoiceRecorder> createState() => _VoiceRecorderState();
}

class _VoiceRecorderState extends State<VoiceRecorder>
    with SingleTickerProviderStateMixin {
  final record_pkg.AudioRecorder _recorder = record_pkg.AudioRecorder();
  bool _isRecording = false;
  int _recordingDuration = 0;
  Timer? _timer;
  String? _recordingPath;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _startRecording();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    // Request microphone permission
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Microphone permission is required for voice messages'),
          ),
        );
        widget.onCancel();
      }
      return;
    }

    try {
      // Check if we can record
      if (await _recorder.hasPermission()) {
        final directory = await getTemporaryDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        _recordingPath = '${directory.path}/voice_$timestamp.m4a';

        await _recorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: _recordingPath!,
        );

        setState(() => _isRecording = true);
        _startTimer();
      }
    } catch (e) {
      debugPrint('Error starting recording: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to start recording: $e')),
        );
        widget.onCancel();
      }
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _recordingDuration++);
    });
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _recorder.stop();
      _timer?.cancel();

      if (path != null && _recordingDuration > 0) {
        widget.onRecordingComplete(path, _recordingDuration);
      } else {
        widget.onCancel();
      }
    } catch (e) {
      debugPrint('Error stopping recording: $e');
      widget.onCancel();
    }
  }

  Future<void> _cancelRecording() async {
    try {
      await _recorder.stop();
      _timer?.cancel();
      widget.onCancel();
    } catch (e) {
      widget.onCancel();
    }
  }

  String get _formattedDuration {
    final minutes = _recordingDuration ~/ 60;
    final seconds = _recordingDuration % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          // Cancel button
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: _cancelRecording,
            tooltip: 'Cancel',
          ),

          // Recording indicator
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.5 + _pulseController.value * 0.5),
                  shape: BoxShape.circle,
                ),
              );
            },
          ),
          const SizedBox(width: 12),

          // Duration text
          Text(
            _formattedDuration,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.red,
            ),
          ),

          const Spacer(),

          // Slide to cancel hint
          Text(
            'Tap to send',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),

          const SizedBox(width: 12),

          // Send button
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _stopRecording,
              tooltip: 'Send',
            ),
          ),
        ],
      ),
    );
  }
}

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;
  final int? duration;
  final bool isMe;

  const AudioPlayerWidget({
    super.key,
    required this.audioUrl,
    this.duration,
    this.isMe = false,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  bool _isPlaying = false;
  double _progress = 0.0;
  int _currentPosition = 0;

  String get _formattedPosition {
    final minutes = _currentPosition ~/ 60;
    final seconds = _currentPosition % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String get _formattedDuration {
    if (widget.duration == null) return '0:00';
    final minutes = widget.duration! ~/ 60;
    final seconds = widget.duration! % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void _togglePlayback() async {
    setState(() => _isPlaying = !_isPlaying);
    // Audio playback would be implemented with audioplayers package
    // This is a placeholder for the UI
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isMe ? Colors.white : Theme.of(context).primaryColor;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Play/Pause button
        IconButton(
          icon: Icon(
            _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
            color: color,
            size: 40,
          ),
          onPressed: _togglePlayback,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),

        const SizedBox(width: 8),

        // Progress bar and duration
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Progress bar
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: color,
                  inactiveTrackColor: color.withOpacity(0.3),
                  thumbColor: color,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                  trackHeight: 3,
                  overlayShape: SliderComponentShape.noOverlay,
                ),
                child: Slider(
                  value: _progress,
                  onChanged: (value) {
                    setState(() => _progress = value);
                  },
                ),
              ),

              // Duration text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formattedPosition,
                      style: TextStyle(
                        fontSize: 10,
                        color: color.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      _formattedDuration,
                      style: TextStyle(
                        fontSize: 10,
                        color: color.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
