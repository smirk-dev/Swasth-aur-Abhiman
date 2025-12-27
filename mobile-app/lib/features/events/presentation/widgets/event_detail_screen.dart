import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/event_models.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getEventColor(event.eventType);
    final icon = _getEventIcon(event.eventType);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                event.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: event.imageUrl != null
                  ? Image.network(
                      event.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildPlaceholder(color, icon),
                    )
                  : _buildPlaceholder(color, icon),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Type Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 16, color: color),
                        const SizedBox(width: 8),
                        Text(
                          event.eventTypeDisplay,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Today/Upcoming Badge
                  if (event.isToday || event.isUpcoming)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: event.isToday
                            ? Colors.red
                            : Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        event.isToday ? '🔴 Happening Today!' : '📅 Upcoming Event',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                  // Description
                  Text(
                    event.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Details Section
                  _buildDetailSection(
                    'Date & Time',
                    Icons.calendar_today,
                    [
                      DateFormat('EEEE, dd MMMM yyyy').format(event.eventDate),
                      if (event.eventTime != null) event.eventTime!,
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildDetailSection(
                    'Location',
                    Icons.location_on,
                    [
                      event.location,
                      'Block: ${event.block}',
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (event.organizerName != null)
                    _buildDetailSection(
                      'Organizer',
                      Icons.person,
                      [
                        event.organizerName!,
                        if (event.organizerContact != null)
                          'Contact: ${event.organizerContact}',
                      ],
                    ),
                  const SizedBox(height: 16),

                  if (event.expectedAttendees != null)
                    _buildDetailSection(
                      'Expected Attendees',
                      Icons.people,
                      ['${event.expectedAttendees} people'],
                    ),

                  const SizedBox(height: 32),

                  // Action Buttons
                  if (event.isUpcoming || event.isToday) ...[
                    // Add to Calendar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _addToCalendar(context),
                        icon: const Icon(Icons.calendar_month),
                        label: const Text('Add to Calendar'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Call Organizer
                    if (event.organizerContact != null)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _callOrganizer(),
                          icon: const Icon(Icons.phone),
                          label: const Text('Call Organizer'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),

                    // Share Event
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _shareEvent(context),
                        icon: const Icon(Icons.share),
                        label: const Text('Share Event'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(Color color, IconData icon) {
    return Container(
      color: color.withOpacity(0.2),
      child: Center(
        child: Icon(
          icon,
          size: 80,
          color: color.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, IconData icon, List<String> details) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.grey[700]),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                ...details.map((detail) => Text(
                      detail,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
              ],
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

  void _addToCalendar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Event added to calendar'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _callOrganizer() async {
    if (event.organizerContact != null) {
      final url = Uri.parse('tel:${event.organizerContact}');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    }
  }

  void _shareEvent(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality coming soon'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
