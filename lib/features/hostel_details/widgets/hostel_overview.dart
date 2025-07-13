import 'package:flutter/material.dart';

import '../../../shared/app_strings/custom_app_strings.dart';
import '../../../shared/custom_app_labels/custom_app_body_text.dart';
import '../../../shared/custom_app_labels/custom_app_header_text.dart';
import '../../../utils/vertical_item_spacer.dart';
import '../../home/widgets/app_hostel_location.dart';
import '../../home/widgets/app_hostel_ratings.dart';

class HostelOverview extends StatelessWidget {
  final String name;
  final String location;
  final double rating;
  final int totalRatings;
  final String overview;

  const HostelOverview({
    super.key,
    required this.name,
    required this.location,
    required this.rating,
    required this.totalRatings,
    required this.overview,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppHostelRatings(averageRating: rating, totalRating: '$totalRatings Reviews'),
        CustomAppHeaderText(text: name, size: 24, fontWeight: FontWeight.bold),
        AppHostelLocation(location: location, color: Colors.black),
        VerticalItemSpacer(
          space: 16.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppHeaderText(text: CustomAppStrings.overviewString, size: 24, fontWeight: FontWeight.bold),
              CustomAppBodyText(text: overview)
            ],
          ),
        ),
      ],
    );
  }
}
