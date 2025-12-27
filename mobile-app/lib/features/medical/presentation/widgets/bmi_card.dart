import 'package:flutter/material.dart';
import '../../models/health_models.dart';

class BMICard extends StatelessWidget {
  final BMIReading reading;

  const BMICard({super.key, required this.reading});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Body Mass Index',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // BMI Gauge
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: CircularProgressIndicator(
                    value: _getBMIProgress(reading.bmi),
                    strokeWidth: 12,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getStatusColor(reading.status),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      reading.bmi.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(reading.status),
                      ),
                    ),
                    Text(
                      reading.status,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: _getStatusColor(reading.status),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Current Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  icon: Icons.monitor_weight,
                  label: 'Weight',
                  value: '${reading.weight.toStringAsFixed(1)} kg',
                ),
                _StatItem(
                  icon: Icons.height,
                  label: 'Height',
                  value: '${reading.height.toStringAsFixed(0)} cm',
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // BMI Categories Reference
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BMI Categories:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  _BMICategoryRow(label: 'Underweight', range: '< 18.5', color: Colors.orange),
                  _BMICategoryRow(label: 'Normal', range: '18.5 - 24.9', color: Colors.green),
                  _BMICategoryRow(label: 'Overweight', range: '25.0 - 29.9', color: Colors.deepOrange),
                  _BMICategoryRow(label: 'Obese', range: '≥ 30.0', color: Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getBMIProgress(double bmi) {
    // Normalize BMI to 0-1 range (15-40 scale)
    return ((bmi - 15) / 25).clamp(0.0, 1.0);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Normal':
        return Colors.green;
      case 'Underweight':
        return Colors.orange;
      case 'Overweight':
        return Colors.deepOrange;
      case 'Obese':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Theme.of(context).primaryColor),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _BMICategoryRow extends StatelessWidget {
  final String label;
  final String range;
  final Color color;

  const _BMICategoryRow({
    required this.label,
    required this.range,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(label),
          const Spacer(),
          Text(range, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
