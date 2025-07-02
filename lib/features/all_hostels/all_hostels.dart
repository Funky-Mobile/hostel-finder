import 'package:flutter/material.dart';
import 'package:hostel_finder/features/all_hostels/widgets/all_hostels_header.dart';
import 'package:hostel_finder/features/all_hostels/widgets/all_nearby_hostels.dart';
import 'package:hostel_finder/shared/custom_app_labels/custom_app_body_text.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../../shared/app_assets/app_assets.dart';

class AllHostels extends StatefulWidget {

  final String headerString;

  const AllHostels({super.key, required this.headerString});

  @override
  State<AllHostels> createState() => _AllHostelsState();
}

class _AllHostelsState extends State<AllHostels> {

  //Todo: this comes from the api response
  final List<String> _assets = [
    // AppAssets.hostel1,
    // AppAssets.hostel2,
    // AppAssets.hostel3,
    // AppAssets.hostel1,
    // AppAssets.hostel2,
    // AppAssets.hostel3,
    // AppAssets.hostel1,
    // AppAssets.hostel2,
    // AppAssets.hostel3
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: StickyHeader(
        
              header: AllHostelsHeader(headerString: widget.headerString),
        
              content: _assets.isEmpty
                  ? SizedBox(
                height: MediaQuery.of(context).size.height * .6,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomAppBodyText(text: "No room available")
                    ],
                  ),
                ),
              )
                  : AllNearbyHostels(assets: _assets)
          ),
        ),
      ),
    );
  }
}
