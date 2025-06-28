import 'package:flutter/material.dart';

import '../custom_app_labels/custom_app_body_text.dart';

class CustomElevatedButton extends StatelessWidget {

  final String? buttonText;
  final Widget? child;
  final VoidCallback onPressed;

  const CustomElevatedButton({super.key, required this.onPressed, this.buttonText, this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          onPressed();
        },
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.white),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(10)
            ))
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: child ?? CustomAppBodyText(
              text: buttonText ?? "Submit",
              textColor: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18
          ),
        )
    );
  }
}
