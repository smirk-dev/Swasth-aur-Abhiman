import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class MedicalCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool urgent;

  const MedicalCard({Key? key, required this.title, required this.subtitle, this.onTap, this.urgent = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [AppColors.medicalGradientStart, AppColors.medicalGradientEnd],
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
                    Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.medicalText)),
                    SizedBox(height: 6),
                    Text(subtitle, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              if (urgent)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: AppColors.medicalAlert, borderRadius: BorderRadius.circular(8)),
                  child: Text('URGENT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
