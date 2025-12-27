import 'package:flutter/material.dart';
import '../../models/health_models.dart';

class HerbalRemediesSection extends StatelessWidget {
  const HerbalRemediesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final remedies = HerbalRemedies.remedies;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header Card
        Card(
          color: Colors.green.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.local_florist, color: Colors.green.shade700, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Traditional Herbal Remedies',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                          ),
                          Text(
                            'Post-COVID Recovery & General Wellness',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'These traditional remedies can support recovery and boost immunity. '
                  'Always consult with a healthcare professional before starting any new treatment.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green.shade700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Anemia Section (Special focus for women)
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.pink.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.pink.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.female, color: Colors.pink.shade700),
                  const SizedBox(width: 8),
                  Text(
                    'Anemia in Women - Special Focus',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.pink.shade800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Iron deficiency is common among women. Natural sources like Moringa leaves, '
                'Beetroot, and Amla can help improve iron levels.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.pink.shade700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Remedies List
        ...remedies.map((remedy) => _RemedyCard(remedy: remedy)),
      ],
    );
  }
}

class _RemedyCard extends StatelessWidget {
  final HerbalRemedy remedy;

  const _RemedyCard({required this.remedy});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: Icon(Icons.eco, color: Colors.green.shade700),
        ),
        title: Text(
          remedy.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: _getConditionColor(remedy.condition).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            remedy.condition,
            style: TextStyle(
              fontSize: 12,
              color: _getConditionColor(remedy.condition),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Benefits:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(remedy.description),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: Colors.amber.shade700, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'How to Use:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(remedy.usage),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getConditionColor(String condition) {
    if (condition.contains('Immunity')) return Colors.blue;
    if (condition.contains('Anemia')) return Colors.pink;
    if (condition.contains('Fatigue')) return Colors.purple;
    if (condition.contains('Vitamin')) return Colors.orange;
    if (condition.contains('inflammatory')) return Colors.red;
    if (condition.contains('Throat') || condition.contains('Cough')) return Colors.teal;
    return Colors.green;
  }
}
