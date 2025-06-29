import 'package:flutter/material.dart';

import '../../../shared/custom_app_labels/custom_app_body_text.dart';
import '../../../shared/custom_app_labels/custom_app_header_text.dart';

class AuthScreensHeader extends StatelessWidget {

  final String heading;
  final String body;

  const AuthScreensHeader({super.key, required this.heading, required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomAppHeaderText(
          text: heading,
          fontWeight: FontWeight.bold,
          textColor: Colors.white,
        ),
        CustomAppBodyText(
            text: body,
            textColor: Colors.white
        )
      ],
    );
  }
}
