class MediaContent {
  final String id;
  final String title;
  final String description;
  final String category;
  final String? subCategory;
  final String mediaUrl;
  final String? thumbnailUrl;
  final int viewCount;
  final bool isActive;
  final DateTime createdAt;

  MediaContent({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.subCategory,
    required this.mediaUrl,
    this.thumbnailUrl,
    required this.viewCount,
    required this.isActive,
    required this.createdAt,
  });

  factory MediaContent.fromJson(Map<String, dynamic> json) {
    return MediaContent(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      subCategory: json['subCategory'],
      mediaUrl: json['mediaUrl'],
      thumbnailUrl: json['thumbnailUrl'],
      viewCount: json['viewCount'] ?? 0,
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'subCategory': subCategory,
      'mediaUrl': mediaUrl,
      'thumbnailUrl': thumbnailUrl,
      'viewCount': viewCount,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  bool get isVideo => 
      mediaUrl.endsWith('.mp4') || 
      mediaUrl.endsWith('.m3u8') || 
      mediaUrl.contains('video');
  
  bool get isPdf => 
      mediaUrl.endsWith('.pdf');
}

class CreateMediaRequest {
  final String title;
  final String description;
  final String category;
  final String? subCategory;
  final String mediaUrl;
  final String? thumbnailUrl;

  CreateMediaRequest({
    required this.title,
    required this.description,
    required this.category,
    this.subCategory,
    required this.mediaUrl,
    this.thumbnailUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'subCategory': subCategory,
      'mediaUrl': mediaUrl,
      'thumbnailUrl': thumbnailUrl,
    };
  }
}

// NCERT Book model
class NCERTBook {
  final String id;
  final int classNumber;
  final String subject;
  final String title;
  final String pdfUrl;
  final String? thumbnailUrl;

  NCERTBook({
    required this.id,
    required this.classNumber,
    required this.subject,
    required this.title,
    required this.pdfUrl,
    this.thumbnailUrl,
  });

  factory NCERTBook.fromMediaContent(MediaContent content) {
    // Parse subCategory to extract class and subject
    // Expected format: "Class 5 - Mathematics"
    final parts = content.subCategory?.split(' - ') ?? [];
    final classStr = parts.isNotEmpty ? parts[0].replaceAll('Class ', '') : '1';
    final subject = parts.length > 1 ? parts[1] : 'General';

    return NCERTBook(
      id: content.id,
      classNumber: int.tryParse(classStr) ?? 1,
      subject: subject,
      title: content.title,
      pdfUrl: content.mediaUrl,
      thumbnailUrl: content.thumbnailUrl,
    );
  }
}

// Skill training categories per PRD
class SkillCategory {
  final String id;
  final String name;
  final String icon;
  final String description;

  const SkillCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
  });

  static const List<SkillCategory> categories = [
    SkillCategory(
      id: 'bamboo',
      name: 'Bamboo Training',
      icon: '🎋',
      description: 'Learn traditional bamboo crafting techniques',
    ),
    SkillCategory(
      id: 'artisan',
      name: 'Artisan Training',
      icon: '🎨',
      description: 'Master traditional artisan skills and crafts',
    ),
    SkillCategory(
      id: 'honeybee',
      name: 'Honeybee Farming',
      icon: '🐝',
      description: 'Beekeeping and honey production techniques',
    ),
    SkillCategory(
      id: 'jute',
      name: 'Jutework',
      icon: '🧶',
      description: 'Jute crafting and product making',
    ),
    SkillCategory(
      id: 'macrame',
      name: 'Macrame Work',
      icon: '🪢',
      description: 'Decorative macrame art and techniques',
    ),
  ];
}
