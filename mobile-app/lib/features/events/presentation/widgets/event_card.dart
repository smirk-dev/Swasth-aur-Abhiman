import 'package:flutter/material.dart';
import '../../models/event_models.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;

  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getEventColor(event.eventType);
    final icon = _getEventIcon(event.eventType);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with event type
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: color.withOpacity(0.15),
              child: Row(
                children: [
                  Icon(icon, size: 18, color: color),
                  const SizedBox(width: 8),
                  Text(
                    event.eventTypeDisplay,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const Spacer(),
                  if (event.isToday)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'TODAY',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Description
                  Text(
                    event.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Event Details Row
                  Row(
                    children: [
                      // Date
                      _buildInfoChip(
                        Icons.calendar_today,
                        DateFormat('dd MMM yyyy').format(event.eventDate),
                        color,
                      ),
                      const SizedBox(width: 8),
                      
                      // Time
                      if (event.eventTime != null)
                        _buildInfoChip(
                          Icons.access_time,
                          event.eventTime!,
                          color,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      // Location
                      Expanded(
                        child: _buildInfoChip(
                          Icons.location_on,
                          event.location,
                          Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      
                      // Block
                      _buildInfoChip(
                        Icons.apartment,
                        event.block,
                        Colors.blue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color _getEventColor(String eventType) {
    switch (eventType) {
      case 'MEDICAL_CAMP':
        return Colors.green;
      case 'TRAINING':
        return Colors.blue;
      case 'AWARENESS':
        return Colors.orange;
      case 'VACCINATION':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  IconData _getEventIcon(String eventType) {
    switch (eventType) {
      case 'MEDICAL_CAMP':
        return Icons.local_hospital;
      case 'TRAINING':
        return Icons.school;
      case 'AWARENESS':
        return Icons.campaign;
      case 'VACCINATION':
        return Icons.vaccines;
      default:
        return Icons.event;
    }
  }
}
