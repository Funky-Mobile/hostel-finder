import 'package:flutter/material.dart';
import 'package:hostel_finder/features/home/widgets/like_hostel_button.dart';

import '../../../shared/custom_app_labels/custom_app_header_text.dart';
import 'app_hostel_location.dart';
import 'app_hostel_ratings.dart';

class NearbyHostelsHorizontal extends StatelessWidget {

  final String hostelImageUrl;
  final String hostelName;
  final String hostelLocation;
  final double averageRating;
  final String totalRating;

  const NearbyHostelsHorizontal({super.key, required this.hostelImageUrl, required this.hostelName, required this.hostelLocation, required this.averageRating, required this.totalRating});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Row(
            children: [
              Container(
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
                    width: 100,
                    height: 100,
                    hostelImageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SizedBox(
                      width: MediaQuery.of(context).size.width * .55,

                      child: CustomAppHeaderText(
                        text: hostelName,
                        size: 24,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: AppHostelLocation(location: hostelLocation, color: Colors.black),
                    ),

                    AppHostelRatings(averageRating: averageRating, totalRating: '$totalRating Reviews')

                  ],
                ),
              )
            ],
          ),

          SizedBox(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                LikeHostelButton(),
              ],
            ),
          )
        ]
    );
  }
}
