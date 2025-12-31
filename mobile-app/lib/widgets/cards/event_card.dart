import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String date;
  final String location;
  final VoidCallback? onTap;

  const EventCard({Key? key, required this.title, required this.date, required this.location, this.onTap}) : super(key: key);

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
              colors: [AppColors.eventsGradientStart, AppColors.eventsGradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.eventsText)),
              SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16),
                  SizedBox(width: 6),
                  Text(date, style: TextStyle(fontSize: 12)),
                  Spacer(),
                  ElevatedButton(onPressed: () {}, child: Text('Register'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
