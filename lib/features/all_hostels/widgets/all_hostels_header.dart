import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../shared/app_strings/custom_app_strings.dart';
import '../../../shared/custom_app_labels/custom_app_header_text.dart';
import '../../../shared/custom_buttons/custom_text_and_icon_button.dart';
import '../../../shared/text_fields/custom_app_search_bar.dart';

class AllHostelsHeader extends StatelessWidget {

  final String headerString;

  const AllHostelsHeader({super.key, required this.headerString});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusGeometry.circular(10)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomAppSearchBar(),
          ),

          CustomTextAndIconButton(
              onPressed: () {

              },
              icon: Icons.my_location_outlined,
              color: Colors.blueGrey[500],
              alignIconToStart: true,
              buttonText: CustomAppStrings.useMyLocationString
          ),


          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomAppHeaderText(
                text: headerString,
                size: 24,
                textColor: Colors.black54
            ),
          ),
        ],
      ),
    );
  }
}
