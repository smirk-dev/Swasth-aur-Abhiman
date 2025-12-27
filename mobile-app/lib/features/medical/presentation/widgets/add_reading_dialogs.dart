import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/health_provider.dart';

void showAddBPDialog(BuildContext context, WidgetRef ref) {
  final systolicController = TextEditingController();
  final diastolicController = TextEditingController();
  final pulseController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Add Blood Pressure Reading'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: systolicController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Systolic (mmHg)',
                hintText: 'e.g., 120',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                final num = int.tryParse(value);
                if (num == null || num < 50 || num > 250) {
                  return 'Enter valid systolic (50-250)';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: diastolicController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Diastolic (mmHg)',
                hintText: 'e.g., 80',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                final num = int.tryParse(value);
                if (num == null || num < 30 || num > 150) {
                  return 'Enter valid diastolic (30-150)';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: pulseController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Pulse (bpm) - Optional',
                hintText: 'e.g., 72',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              final systolic = int.parse(systolicController.text);
              final diastolic = int.parse(diastolicController.text);
              final pulse = pulseController.text.isNotEmpty 
                  ? int.parse(pulseController.text) 
                  : null;
              
              ref.read(healthProvider.notifier).addBPReading(
                systolic,
                diastolic,
                pulse,
              );
              
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Blood pressure reading added')),
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}

void showAddSugarDialog(BuildContext context, WidgetRef ref) {
  final levelController = TextEditingController();
  String selectedType = 'FASTING';
  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('Add Blood Sugar Reading'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Reading Type:'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['FASTING', 'RANDOM', 'POST_MEAL'].map((type) {
                  return ChoiceChip(
                    label: Text(type.replaceAll('_', ' ')),
                    selected: selectedType == type,
                    onSelected: (selected) {
                      if (selected) setState(() => selectedType = type);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: levelController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Sugar Level (mg/dL)',
                  hintText: 'e.g., 100',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  final num = double.tryParse(value);
                  if (num == null || num < 20 || num > 600) {
                    return 'Enter valid level (20-600)';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final level = double.parse(levelController.text);
                
                ref.read(healthProvider.notifier).addSugarReading(
                  level,
                  selectedType,
                );
                
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Blood sugar reading added')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ),
  );
}

void showAddBMIDialog(BuildContext context, WidgetRef ref) {
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Add Weight/BMI Reading'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: weightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
                hintText: 'e.g., 65',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                final num = double.tryParse(value);
                if (num == null || num < 20 || num > 300) {
                  return 'Enter valid weight (20-300 kg)';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: heightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Height (cm)',
                hintText: 'e.g., 170',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                final num = double.tryParse(value);
                if (num == null || num < 50 || num > 250) {
                  return 'Enter valid height (50-250 cm)';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              final weight = double.parse(weightController.text);
              final height = double.parse(heightController.text);
              
              ref.read(healthProvider.notifier).addBMIReading(weight, height);
              
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('BMI reading added')),
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}
