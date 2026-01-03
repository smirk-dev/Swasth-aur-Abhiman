import 'package:flutter/material.dart';
import '../../data/curriculum_data.dart';

class ClassSelector extends StatelessWidget {
  final int? selectedClass;
  final Function(int?) onClassSelected;

  const ClassSelector({
    super.key,
    required this.selectedClass,
    required this.onClassSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 12,
        itemBuilder: (context, index) {
          final classNum = index + 1;
          final isSelected = selectedClass == classNum;
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text('Class $classNum'),
              selected: isSelected,
              onSelected: (selected) {
                onClassSelected(selected ? classNum : null);
              },
              selectedColor: Theme.of(context).primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : null,
                fontWeight: isSelected ? FontWeight.bold : null,
              ),
            ),
          );
        },
      ),
    );
  }
}

class SubjectSelector extends StatelessWidget {
  final String? selectedSubject;
  final int selectedClass;
  final Function(String?) onSubjectSelected;

  const SubjectSelector({
    super.key,
    required this.selectedSubject,
    required this.selectedClass,
    required this.onSubjectSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Get subjects for the selected class
    final subjects = CurriculumData.getSubjectsForClass(selectedClass);

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          final subject = subjects[index];
          final isSelected = selectedSubject == subject;
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label: Text(subject),
              selected: isSelected,
              onSelected: (selected) {
                onSubjectSelected(selected ? subject : null);
              },
              selectedColor: Colors.blue.shade100,
            ),
          );
        },
      ),
    );
  }
}
