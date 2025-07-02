import 'package:flutter/material.dart';

import '../../../shared/app_strings/custom_app_strings.dart';
import '../../../shared/custom_app_labels/custom_app_header_text.dart';
import '../../../shared/custom_buttons/custom_text_and_icon_button.dart';

class HostelPhotos extends StatelessWidget {

  final List<String> hostelPhotosUrls;

  const HostelPhotos({super.key, required this.hostelPhotosUrls});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            CustomAppHeaderText(
              text: CustomAppStrings.photosString,
              size: 24,
              maxLines: 10,
              fontWeight: FontWeight.bold,
            ),

            CustomTextAndIconButton(
                onPressed: () {  },
                buttonText: "See All",
                color: Colors.black,
                icon: Icons.keyboard_arrow_right_outlined
            )

          ],
        ),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              ...hostelPhotosUrls.map((photoUrl) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black45,
                              offset: Offset(0, 1),
                              blurRadius: 3
                          )
                        ],
                        borderRadius: BorderRadiusGeometry.circular(10)
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                          photoUrl,
                          fit: BoxFit.cover,
                          width: 150,
                          height: 150
                      ),
                    ),
                  ),
                );
              })

            ],
          ),
        )
      ],
    );
  }
}
