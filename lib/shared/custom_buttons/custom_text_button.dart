import 'package:flutter/material.dart';

import '../custom_app_labels/custom_app_body_text.dart';

class CustomTextButton extends StatelessWidget {

  final VoidCallback onPressed;
  final String buttonText;

  const CustomTextButton({super.key, required this.onPressed, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () { onPressed(); },
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(EdgeInsets.all(0))
      ),
      child: CustomAppBodyText(text: buttonText, textColor: Colors.white,),
    );
  }
}
