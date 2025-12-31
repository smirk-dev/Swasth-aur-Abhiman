import 'package:hive/hive.dart';

part 'education_models.g.dart';

@HiveType(typeId: 30)
class EducationVideo extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final String url;

  @HiveField(4)
  final String? thumbnailUrl;

  @HiveField(5)
  final String category;

  @HiveField(6)
  final String? subcategory;

  @HiveField(7)
  final int? viewCount;

  @HiveField(8)
  final String? uploadedById;

  @HiveField(9)
  final DateTime createdAt;

  @HiveField(10)
  final String? uploaderName;

  EducationVideo({
    required this.id,
    required this.title,
    this.description,
    required this.url,
    this.thumbnailUrl,
    required this.category,
    this.subcategory,
    this.viewCount,
    this.uploadedById,
    required this.createdAt,
    this.uploaderName,
  });

  factory EducationVideo.fromJson(Map<String, dynamic> json) {
    return EducationVideo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      url: json['url'] ?? json['mediaUrl'] ?? '',
      thumbnailUrl: json['thumbnailUrl'],
      category: json['category'] ?? 'EDUCATION',
      subcategory: json['subcategory'] ?? json['subCategory'],
      viewCount: json['viewCount'] ?? 0,
      uploadedById: json['uploadedBy']?['id'],
      uploaderName: json['uploadedBy']?['fullName'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
      'category': category,
      'subcategory': subcategory,
      'viewCount': viewCount,
    };
  }

  /// Check if this is a YouTube video
  bool get isYouTubeVideo {
    return url.contains('youtube.com') || url.contains('youtu.be');
  }

  /// Extract YouTube video ID from URL
  String? get youtubeVideoId {
    if (!isYouTubeVideo) return null;
    
    final regExp = RegExp(
      r'^.*(?:youtu\.be\/|youtube\.com\/(?:watch\?v=|embed\/|v\/|shorts\/))([a-zA-Z0-9_-]{11}).*$',
      caseSensitive: false,
    );
    
    final match = regExp.firstMatch(url);
    return match?.group(1);
  }

  /// Get YouTube thumbnail URL
  String get effectiveThumbnailUrl {
    if (thumbnailUrl != null && thumbnailUrl!.isNotEmpty) {
      return thumbnailUrl!;
    }
    
    final videoId = youtubeVideoId;
    if (videoId != null) {
      return 'https://img.youtube.com/vi/$videoId/mqdefault.jpg';
    }
    
    return '';
  }
}

class EducationCategory {
  final String id;
  final String name;
  final String? description;
  final String? iconUrl;
  final int videoCount;

  const EducationCategory({
    required this.id,
    required this.name,
    this.description,
    this.iconUrl,
    this.videoCount = 0,
  });

  factory EducationCategory.fromJson(Map<String, dynamic> json) {
    return EducationCategory(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      iconUrl: json['iconUrl'],
      videoCount: json['videoCount'] ?? 0,
    );
  }
}
