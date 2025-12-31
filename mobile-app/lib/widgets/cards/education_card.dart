import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class EducationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String thumbnailUrl;
  final double? rating;
  final int durationSeconds;
  final bool isFree;
  final VoidCallback? onTap;

  const EducationCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.thumbnailUrl,
    this.rating,
    required this.durationSeconds,
    this.isFree = true,
    this.onTap,
  }) : super(key: key);

  String get formattedDuration {
    final minutes = (durationSeconds / 60).floor();
    final seconds = durationSeconds % 60;
    return minutes.toString() + ':' + seconds.toString().padLeft(2, '0');
  }

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
              colors: [AppColors.educationGradientStart, AppColors.educationGradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: thumbnailUrl,
                  width: 120,
                  height: 80,
                  fit: BoxFit.cover,
                  placeholder: (c, s) => Container(color: Colors.grey[200]),
                  errorWidget: (c, s, e) => Icon(Icons.broken_image),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.educationText),
                    ),
                    SizedBox(height: 6),
                    Text(subtitle, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        if (rating != null) ...[
                          RatingBarIndicator(
                            rating: rating!,
                            itemBuilder: (context, index) => Icon(Icons.star, color: Colors.amber),
                            itemSize: 14,
                          ),
                          SizedBox(width: 8),
                          Text(rating!.toStringAsFixed(1), style: TextStyle(fontSize: 12)),
                        ],
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
                          child: Text(formattedDuration, style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                        SizedBox(width: 8),
                        if (isFree)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(8)),
                            child: Text('FREE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.educationText)),
                          ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
