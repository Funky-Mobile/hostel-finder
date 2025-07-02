import 'package:flutter/material.dart';
import 'package:hostel_finder/features/hostel_details/widgets/hostel_enquiry_button.dart';
import 'package:hostel_finder/features/hostel_details/widgets/hostel_image.dart';
import 'package:hostel_finder/features/hostel_details/widgets/hostel_overview.dart';
import 'package:hostel_finder/features/hostel_details/widgets/hostel_photos.dart';
import 'package:hostel_finder/shared/custom_buttons/custom_elevated_button.dart';
import 'package:hostel_finder/utils/vertical_item_spacer.dart';

import '../home/widgets/hostel_amenities.dart';

class HostelDetail extends StatefulWidget {

  final List<String> hostelPhotosUrls;

  const HostelDetail({super.key, required this.hostelPhotosUrls});

  @override
  State<HostelDetail> createState() => _HostelDetailState();
}

class _HostelDetailState extends State<HostelDetail> {


  final List<String> hostelAmenities = <String>["Water 27/7", "Kitchen", "Free bed", "Learning room", "Basketball court"];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              HostelImage(imageUrl: widget.hostelPhotosUrls[0]),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),

                child: Column(
                  children: [
                    HostelOverview(),

                    HostelAmenities(amenities: hostelAmenities),

                    HostelPhotos(hostelPhotosUrls: widget.hostelPhotosUrls),

                    HostelEnquiryButton()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
