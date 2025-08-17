import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../shared/app_strings/custom_app_strings.dart';
import '../../../shared/custom_app_labels/custom_app_header_text.dart';
import '../../../shared/custom_buttons/custom_text_and_icon_button.dart';
import '../../../utils/app_device.dart';

class ViewAllHostelsButton extends StatelessWidget {

  final VoidCallback onPressed;

  const ViewAllHostelsButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AppDevice.isSmallScreen(context)
        ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomAppHeaderText(text: CustomAppStrings.nearbyHostelsString, size: 24),

            CustomTextAndIconButton(
                onPressed: () {
                  onPressed();
                },
                icon: Icons.keyboard_arrow_right_outlined,
                buttonText: CustomAppStrings.allRoomsString,
                buttonTextSize: 16,
                color: Colors.black,
            )
          ],
        )
        : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppHeaderText(text: CustomAppStrings.nearbyHostelsString, size: 24),

          CustomTextAndIconButton(
              onPressed: () {
                onPressed();
              },
              icon: Icons.keyboard_arrow_right_outlined,
              buttonText: CustomAppStrings.allRoomsString,
              buttonTextSize: 16,
              color: Colors.black,
          )
        ],
      );
  }
}
