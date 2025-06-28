import 'package:flutter/cupertino.dart';

import '../custom_app_labels/custom_app_body_text.dart';
import 'custom_elevated_button.dart';

class CustomElevatedIconButton extends StatelessWidget {

  final String assetIcon;
  final String buttonText;
  final VoidCallback onPressed;

  const CustomElevatedIconButton({super.key, required this.buttonText, required this.assetIcon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      onPressed: () { onPressed(); },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            assetIcon,
            height: 18,
          ),

          SizedBox(width: 8.0),

          CustomAppBodyText(text: buttonText, fontSize: 18)
        ],
      ),
    );
  }
}
