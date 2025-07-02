import 'package:flutter/material.dart';
import 'package:hostel_finder/core/app_routes.dart';
import 'package:hostel_finder/core/naviagtor/app_navigator.dart';
import 'package:hostel_finder/features/all_hostels/all_hostels.dart';
import 'package:hostel_finder/features/home/widgets/nearby_hostels.dart';
import 'package:hostel_finder/features/home/widgets/popular_hostel_card.dart';
import 'package:hostel_finder/features/home/widgets/view_all_hostels_button.dart';
import 'package:hostel_finder/features/hostel_details/hostel_detail.dart';
import 'package:hostel_finder/shared/app_assets/app_assets.dart';
import 'package:hostel_finder/shared/app_strings/custom_app_strings.dart';
import 'package:hostel_finder/shared/custom_app_labels/custom_app_header_text.dart';


class PopularHostels extends StatefulWidget {
  const PopularHostels({super.key});

  @override
  State<PopularHostels> createState() => _PopularHostelsState();
}

class _PopularHostelsState extends State<PopularHostels> {

  //Todo: this comes from the api response
  final List<String> _assets = [AppAssets.hostel1, AppAssets.hostel2, AppAssets.hostel3];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        CustomAppHeaderText(text: CustomAppStrings.popularHostelsString, size: 24, textColor: Colors.white),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ..._assets.map((asset) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (builder) => HostelDetail(
                      hostelPhotosUrls: _assets
                    ))),

                    child: PopularHostelCard(
                      hostelImageUrl: asset, //Todo: this comes from the api response
                      averageRating: 4.6, //Todo: this comes from the api response
                      totalRating: 334, //Todo: this comes from the api response
                      hostelName: 'Kings Queens Hostel', //Todo: this comes from the api response
                      hostelLocation: 'Adenta Municipality', //Todo: this comes from the api response
                      hostelAmenities: ["Water 27/7", "Kitchen", "Free bed", "Learning room", "Basketball court"] //Todo: this comes from the api response
                    ),
                  ),
                );
              })
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
          child: ViewAllHostelsButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (builder) => AllHostels(headerString: CustomAppStrings.nearbyHostelsString))),
          ),
        ),

        Column(
          children: [
            ..._assets.map((asset) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (builder) => HostelDetail(
                    hostelPhotosUrls: _assets
                  ))),

                  child: NearbyHostels(
                    asset,
                    "Gracious Queens Hotel", //Todo: this comes from the api response
                    "Adenta Municipality", //Todo: this comes from the api response
                    3.4, //Todo: this comes from the api response
                    '${231}' //Todo: this comes from the api response
                  ),
                ),
              );
            })
          ],
        )
      ],
    );
  }
}
