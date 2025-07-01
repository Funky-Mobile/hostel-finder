import 'package:flutter/material.dart';

import '../../../shared/app_icons/custom_app_icon.dart';
import '../../../shared/custom_app_labels/custom_app_body_text.dart';

class AppHostelLocation extends StatelessWidget {

  final String location;
  final Color? color;

  const AppHostelLocation({super.key, required this.location, this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomAppIcon(icon: Icons.location_on_outlined, color: color ?? Colors.white),
        CustomAppBodyText(text: location, textColor: color ?? Colors.white)
      ],
    );
  }
}
