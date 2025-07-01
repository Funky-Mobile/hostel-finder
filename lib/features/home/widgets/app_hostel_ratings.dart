import 'package:flutter/material.dart';

import '../../../shared/app_icons/custom_app_icon.dart';
import '../../../shared/custom_app_labels/custom_app_body_text.dart';

class AppHostelRatings extends StatelessWidget {

  final double averageRating;
  final String totalRating;

  const AppHostelRatings({super.key, required this.averageRating, required this.totalRating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomAppIcon(icon: Icons.star, color: Colors.orange),
        CustomAppBodyText(
            text: '$averageRating',
            textColor: Colors.orange
        ),
        CustomAppBodyText(
            text: ' ($totalRating)'
        )
      ],
    );
  }
}
