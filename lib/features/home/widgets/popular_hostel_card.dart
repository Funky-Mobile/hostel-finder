import 'package:flutter/material.dart';
import 'package:hostel_finder/features/home/widgets/app_hostel_ratings.dart';
import 'package:hostel_finder/features/home/widgets/hostel_amenities.dart';
import 'package:hostel_finder/features/home/widgets/like_hostel_button.dart';
import 'package:hostel_finder/shared/app_icons/custom_app_icon.dart';
import 'package:hostel_finder/shared/custom_app_labels/custom_app_body_text.dart';
import 'package:hostel_finder/shared/custom_app_labels/custom_app_header_text.dart';

class PopularHostelCard extends StatelessWidget {

  final String hostelImageUrl;
  final double averageRating;
  final int totalRating;
  final String hostelName;
  final String hostelLocation;
  final List<String> hostelAmenities;

  const PopularHostelCard({super.key, required this.hostelImageUrl, required this.averageRating, required this.totalRating, required this.hostelName, required this.hostelLocation, required this.hostelAmenities});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10)
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .7,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Stack(
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        height: 180,
                        width: MediaQuery.of(context).size.width * .7,
                        child: Image.asset(
                            hostelImageUrl,
                            fit: BoxFit.cover
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.white60,
                        child: LikeHostelButton()
                      ),
                    ),
                  )
                ],
              ),

              SizedBox(height: 8.0),

              AppHostelRatings(averageRating: averageRating, totalRating: '$totalRating'),

              CustomAppHeaderText(
                text: hostelName,
                size: 24,
                maxLines: 1,
                overflow: TextOverflow.ellipsis
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomAppIcon(icon: Icons.location_on_outlined),
                  CustomAppBodyText(
                    text: hostelLocation
                  )
                ],
              ),

              SizedBox(height: 8.0),

              HostelAmenities(amenities: hostelAmenities)
            ],
          ),
        ),
      ),
    );
  }
}
