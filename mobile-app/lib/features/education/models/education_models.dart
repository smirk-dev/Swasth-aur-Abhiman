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
  });

  factory EducationVideo.fromJson(Map<String, dynamic> json) {
    return EducationVideo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
      thumbnailUrl: json['thumbnailUrl'],
      category: json['category'] ?? 'EDUCATION',
      subcategory: json['subcategory'],
      viewCount: json['viewCount'] ?? 0,
      uploadedById: json['uploadedBy']?['id'],
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
