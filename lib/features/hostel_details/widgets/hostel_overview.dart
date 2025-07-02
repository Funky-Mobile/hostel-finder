import 'package:flutter/material.dart';

import '../../../shared/app_strings/custom_app_strings.dart';
import '../../../shared/custom_app_labels/custom_app_body_text.dart';
import '../../../shared/custom_app_labels/custom_app_header_text.dart';
import '../../../utils/vertical_item_spacer.dart';
import '../../home/widgets/app_hostel_location.dart';
import '../../home/widgets/app_hostel_ratings.dart';

class HostelOverview extends StatelessWidget {


  const HostelOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          AppHostelRatings(averageRating: 5.0, totalRating: '${200} Reviews'), //Todo: this comes from the api response

          CustomAppHeaderText(
            text: "Glorious Queens Hostel", //Todo: this comes from the api response
            size: 24,
            maxLines: 10,
            fontWeight: FontWeight.bold,
          ),

          AppHostelLocation(
              location: "Adenta Municipality", //Todo: this comes from the api response
              color: Colors.black
          ),

          VerticalItemSpacer(
            space: 16.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppHeaderText(
                  text: CustomAppStrings.overviewString,
                  size: 24,
                  fontWeight: FontWeight.bold,
                ),

                CustomAppBodyText(
                    text: "Modern Shared Hostel Room – Perfect for Students Welcome to your new cozy and affordable living space! This furnished shared hostel room is designed for comfort, convenience, and community. Each bedspace comes with: A comfortable single bed with a quality mattress and bedsheets Private study desk and chair for focused learning Spacious wardrobe/locker for secure storage Fan or air conditioning unit (depending on room type) Fast Wi-Fi connection Access to clean shared bathrooms and fully equipped kitchen 24/7 security and maintenance support The hostel is located just 5 minutes from campus and surrounded by eateries, markets, and transport links. Utilities and cleaning services are included in the rent. Whether you're staying for a semester or a full academic year, this room offers everything you need to feel at home while focusing on your studies." //Todo: this comes from the api response
                )
              ],
            ),
          ),
        ],
      );
  }
}
