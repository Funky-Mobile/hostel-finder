import 'package:flutter/cupertino.dart';

import '../../../shared/app_strings/custom_app_strings.dart';
import '../../../shared/custom_app_labels/custom_app_header_text.dart';
import '../../../shared/custom_buttons/keyboard_arrow_right_button.dart';
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

            KeyboardArrowRightButton(
                onPressed: () {
                  onPressed();
                },
                buttonText: CustomAppStrings.allRoomsString,
                buttonTextSize: 16
            )
          ],
        )
        : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppHeaderText(text: CustomAppStrings.nearbyHostelsString, size: 24),

          KeyboardArrowRightButton(
              onPressed: () {
                onPressed();
              },
              buttonText: CustomAppStrings.allRoomsString,
              buttonTextSize: 16
          )
        ],
      );
  }
}
