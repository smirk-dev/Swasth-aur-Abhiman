import 'package:flutter/material.dart';
import '../../models/event_models.dart';

class EventFilters extends StatelessWidget {
  final String? selectedBlock;
  final String? selectedEventType;
  final Function(String?) onBlockChanged;
  final Function(String?) onEventTypeChanged;

  const EventFilters({
    super.key,
    this.selectedBlock,
    this.selectedEventType,
    required this.onBlockChanged,
    required this.onEventTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Text(
                'Filter Events',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 16),

          // Block Filter
          const Text(
            'Filter by Block',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              _buildBlockChip('VIKASNAGAR', 'Vikasnagar'),
              _buildBlockChip('DOIWALA', 'Doiwala'),
              _buildBlockChip('SAHASPUR', 'Sahaspur'),
            ],
          ),
          const SizedBox(height: 24),

          // Event Type Filter
          const Text(
            'Filter by Event Type',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildEventTypeChip(
                EventType.medicalCamp,
                'Medical Camp',
                Icons.local_hospital,
                Colors.green,
              ),
              _buildEventTypeChip(
                EventType.training,
                'Training',
                Icons.school,
                Colors.blue,
              ),
              _buildEventTypeChip(
                EventType.awareness,
                'Awareness',
                Icons.campaign,
                Colors.orange,
              ),
              _buildEventTypeChip(
                EventType.vaccination,
                'Vaccination',
                Icons.vaccines,
                Colors.pink,
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBlockChip(String value, String label) {
    final isSelected = selectedBlock == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        onBlockChanged(selected ? value : null);
      },
      selectedColor: Colors.blue.withOpacity(0.2),
      checkmarkColor: Colors.blue,
    );
  }

  Widget _buildEventTypeChip(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    final isSelected = selectedEventType == value;
    return FilterChip(
      avatar: Icon(icon, size: 16, color: isSelected ? color : Colors.grey),
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        onEventTypeChanged(selected ? value : null);
      },
      selectedColor: color.withOpacity(0.2),
      checkmarkColor: color,
    );
  }
}
