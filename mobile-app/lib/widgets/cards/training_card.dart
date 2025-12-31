import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class TrainingCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String difficulty;
  final VoidCallback? onTap;

  const TrainingCard({Key? key, required this.title, required this.subtitle, required this.difficulty, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [AppColors.trainingGradientStart, AppColors.trainingGradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.trainingText)),
                    SizedBox(height: 6),
                    Text(subtitle, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Chip(label: Text(difficulty)),
                        Spacer(),
                        Icon(Icons.workspace_premium, color: AppColors.trainingAccent),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
