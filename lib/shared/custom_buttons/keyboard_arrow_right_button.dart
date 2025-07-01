import 'package:flutter/material.dart';

import '../custom_app_labels/custom_app_body_text.dart';

class KeyboardArrowRightButton extends StatelessWidget {

  final VoidCallback onPressed;
  final String buttonText;
  final Color? buttonTextColor;
  final double? buttonTextSize;

  const KeyboardArrowRightButton({super.key, required this.onPressed, required this.buttonText, this.buttonTextColor, this.buttonTextSize});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () { onPressed(); },
      style: ButtonStyle(
          padding: WidgetStatePropertyAll(EdgeInsets.all(0))
      ),
      child: Row(
        children: [
          CustomAppBodyText(
            text: buttonText,
            textColor: buttonTextColor ?? Colors.white,
            fontSize: buttonTextSize,
          ),
          Icon(
            Icons.keyboard_arrow_right_outlined,
            color: Colors.white,
            size: 16,
          )
        ],
      ),
    );
  }
}
