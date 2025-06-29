import 'package:flutter/material.dart';
import 'package:hostel_finder/shared/app_strings/custom_app_strings.dart';
import 'package:hostel_finder/shared/custom_app_labels/custom_app_header_text.dart';

import '../../../shared/app_icons/custom_app_icon.dart';
import '../../../shared/custom_app_labels/custom_app_body_text.dart';

class Salutation extends StatefulWidget {
  const Salutation({super.key});

  @override
  State<Salutation> createState() => _SalutationState();
}

class _SalutationState extends State<Salutation> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomAppIcon(icon: Icons.location_on_outlined),
            CustomAppBodyText(text: "Adenta Municipality")
          ],
        ),

        //Todo: replace name (Joshua) with registered user's name
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: CustomAppBodyText(
            text: "${CustomAppStrings.hiString} Joshua ${CustomAppStrings.handWaveString}",
            fontSize: 18,
          ),
        ),

        CustomAppHeaderText(text: CustomAppStrings.homeHeaderString, size: 24)
      ],
    );
  }
}
