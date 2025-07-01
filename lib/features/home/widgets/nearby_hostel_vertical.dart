import 'package:flutter/material.dart';
import 'package:hostel_finder/features/home/widgets/like_hostel_button.dart';

import '../../../shared/custom_app_labels/custom_app_header_text.dart';
import 'app_hostel_location.dart';
import 'app_hostel_ratings.dart';

class NearbyHostelsVertical extends StatelessWidget {

  final String hostelImageUrl;
  final String hostelName;
  final String hostelLocation;
  final double averageRating;
  final String totalRating;

  const NearbyHostelsVertical({super.key, required this.hostelImageUrl, required this.hostelName, required this.hostelLocation, required this.averageRating, required this.totalRating});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              width: MediaQuery.of(context).size.width,
              height: 200,
              hostelImageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),

        CustomAppHeaderText(
            text: hostelName,
            size: 24,
            maxLines: 1
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: AppHostelLocation(location: hostelLocation, color: Colors.black),
                ),

                AppHostelRatings(averageRating: averageRating, totalRating: '$totalRating Reviews')
              ],
            ),

            LikeHostelButton(),
          ],
        )
      ],
    );
  }
}
