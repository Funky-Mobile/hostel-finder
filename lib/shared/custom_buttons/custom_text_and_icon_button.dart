import 'package:flutter/material.dart';

import '../custom_app_labels/custom_app_body_text.dart';

class CustomTextAndIconButton extends StatelessWidget {

  final VoidCallback onPressed;
  final String buttonText;
  final Color? color;
  final double? buttonTextSize;
  final bool? alignIconToStart;
  final IconData? icon;

  const CustomTextAndIconButton({super.key, required this.onPressed, required this.buttonText, this.color, this.buttonTextSize, this.alignIconToStart, this.icon});

  @override
  Widget build(BuildContext context) {

    bool iconToStart = alignIconToStart ?? false;

    return TextButton(
      onPressed: () { onPressed(); },
      style: ButtonStyle(
          padding: WidgetStatePropertyAll(EdgeInsets.all(0))
      ),
      child: iconToStart
        ? IntrinsicWidth(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
                children: [

                  Icon(
                    icon,
                    color: color ?? Colors.white,
                    // size: 16,
                  ),

                  SizedBox(width: 4.0),

                  CustomAppBodyText(
                    text: buttonText,
                    textColor: color ?? Colors.white,
                    fontSize: buttonTextSize,
                  )
                ],
              ),
          ),
        )
        : IntrinsicWidth(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [

              CustomAppBodyText(
                text: buttonText,
                textColor: color ?? Colors.white,
                fontSize: buttonTextSize,
              ),

              Icon(
                icon,
                color: color ?? Colors.white,
                size: 16,
              )
            ],
          ),
        ),
      )
    );
  }
}
