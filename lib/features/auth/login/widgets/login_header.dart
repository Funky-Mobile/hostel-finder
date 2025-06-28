import 'package:flutter/material.dart';

import '../../../../shared/app_strings/custom_app_strings.dart';
import '../../../../shared/custom_app_labels/custom_app_body_text.dart';
import '../../../../shared/custom_app_labels/custom_app_header_text.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomAppHeaderText(
          text: CustomAppStrings.loginHeaderText,
          fontWeight: FontWeight.bold,
          textColor: Colors.white,
        ),
        CustomAppBodyText(
            text: CustomAppStrings.loginSubHeadingText,
            textColor: Colors.white
        )
      ],
    );
  }
}
