class Video {
  final int id;
  final String title;
  final String description;
  final String source; // 'youtube', 'internal'
  final String? externalUrl;
  final String thumbnailUrl;
  final String category;
  final String subCategory;
  final String ageGroup; // 'Class 10'
  final String subject;
  final String? chapter;
  final String difficulty;
  final int durationSeconds;
  final String language;
  final int viewCount;
  final double? rating;
  final bool isFree;
  final List<String> tags;

  Video({
    required this.id,
    required this.title,
    required this.description,
    required this.source,
    this.externalUrl,
    required this.thumbnailUrl,
    required this.category,
    required this.subCategory,
    required this.ageGroup,
    required this.subject,
    this.chapter,
    required this.difficulty,
    required this.durationSeconds,
    required this.language,
    required this.viewCount,
    this.rating,
    required this.isFree,
    required this.tags,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      source: json['source'] ?? 'internal',
      externalUrl: json['externalUrl'],
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      category: json['category'] ?? '',
      subCategory: json['subCategory'] ?? '',
      ageGroup: json['ageGroup'] ?? '',
      subject: json['subject'] ?? '',
      chapter: json['chapter'],
      difficulty: json['difficulty'] ?? 'Beginner',
      durationSeconds: json['durationSeconds'] ?? 0,
      language: json['language'] ?? 'English',
      viewCount: json['viewCount'] ?? 0,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      isFree: json['isFree'] ?? true,
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  String get formattedDuration {
    final minutes = (durationSeconds / 60).floor();
    final seconds = durationSeconds % 60;
    return minutes.toString() + ':' + seconds.toString().padLeft(2, '0');
  }

  String get youtubeVideoId {
    if (source == 'youtube' && externalUrl != null) {
      final uri = Uri.parse(externalUrl!);
      return uri.queryParameters['v'] ?? '';
    }
    return '';
  }
}
