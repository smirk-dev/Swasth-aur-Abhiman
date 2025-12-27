import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'event_models.g.dart';

@HiveType(typeId: 10)
class Event {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final DateTime eventDate;

  @HiveField(4)
  final String? eventTime;

  @HiveField(5)
  final String location;

  @HiveField(6)
  final String block; // VIKASNAGAR, DOIWALA, SAHASPUR

  @HiveField(7)
  final String eventType; // MEDICAL_CAMP, TRAINING, AWARENESS, VACCINATION, OTHER

  @HiveField(8)
  final String? organizerName;

  @HiveField(9)
  final String? organizerContact;

  @HiveField(10)
  final String? imageUrl;

  @HiveField(11)
  final int? expectedAttendees;

  @HiveField(12)
  final bool isActive;

  @HiveField(13)
  final DateTime createdAt;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.eventDate,
    this.eventTime,
    required this.location,
    required this.block,
    required this.eventType,
    this.organizerName,
    this.organizerContact,
    this.imageUrl,
    this.expectedAttendees,
    this.isActive = true,
    required this.createdAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      eventDate: DateTime.parse(json['eventDate']),
      eventTime: json['eventTime'],
      location: json['location'],
      block: json['block'],
      eventType: json['eventType'],
      organizerName: json['organizerName'],
      organizerContact: json['organizerContact'],
      imageUrl: json['imageUrl'],
      expectedAttendees: json['expectedAttendees'],
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'eventDate': eventDate.toIso8601String(),
      'eventTime': eventTime,
      'location': location,
      'block': block,
      'eventType': eventType,
      'organizerName': organizerName,
      'organizerContact': organizerContact,
      'imageUrl': imageUrl,
      'expectedAttendees': expectedAttendees,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  bool get isUpcoming => eventDate.isAfter(DateTime.now());
  bool get isToday {
    final now = DateTime.now();
    return eventDate.year == now.year &&
        eventDate.month == now.month &&
        eventDate.day == now.day;
  }

  String get eventTypeDisplay {
    switch (eventType) {
      case 'MEDICAL_CAMP':
        return 'Medical Camp';
      case 'TRAINING':
        return 'Training Session';
      case 'AWARENESS':
        return 'Awareness Program';
      case 'VACCINATION':
        return 'Vaccination Drive';
      default:
        return 'Event';
    }
  }
}

class EventType {
  static const String medicalCamp = 'MEDICAL_CAMP';
  static const String training = 'TRAINING';
  static const String awareness = 'AWARENESS';
  static const String vaccination = 'VACCINATION';
  static const String other = 'OTHER';

  static List<String> get all => [
        medicalCamp,
        training,
        awareness,
        vaccination,
        other,
      ];

  static String getDisplayName(String type) {
    switch (type) {
      case medicalCamp:
        return 'Medical Camp';
      case training:
        return 'Training Session';
      case awareness:
        return 'Awareness Program';
      case vaccination:
        return 'Vaccination Drive';
      default:
        return 'Other Event';
    }
  }

  static IconData getIcon(String type) {
    switch (type) {
      case medicalCamp:
        return Icons.local_hospital;
      case training:
        return Icons.school;
      case awareness:
        return Icons.campaign;
      case vaccination:
        return Icons.vaccines;
      default:
        return Icons.event;
    }
  }

  static Color getColor(String type) {
    switch (type) {
      case medicalCamp:
        return const Color(0xFF4CAF50);
      case training:
        return const Color(0xFF2196F3);
      case awareness:
        return const Color(0xFFFF9800);
      case vaccination:
        return const Color(0xFFE91E63);
      default:
        return const Color(0xFF9E9E9E);
    }
  }
}
