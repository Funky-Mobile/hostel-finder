import 'package:flutter/material.dart';
import 'package:hostel_finder/core/data/hostel_model.dart';
import 'package:hostel_finder/features/hostel_details/widgets/hostel_enquiry_button.dart';
import 'package:hostel_finder/features/hostel_details/widgets/hostel_image.dart';
import 'package:hostel_finder/features/hostel_details/widgets/hostel_overview.dart';
import 'package:hostel_finder/features/hostel_details/widgets/hostel_photos.dart';
import 'package:hostel_finder/shared/app_assets/app_assets.dart';
import 'package:hostel_finder/shared/custom_app_labels/custom_app_body_text.dart';
import 'package:hostel_finder/shared/custom_app_labels/custom_app_header_text.dart';

import '../home/widgets/hostel_amenities.dart';

class HostelDetail extends StatelessWidget {
  final HostelModel hostel;

  const HostelDetail({super.key, required this.hostel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              HostelImage(imageUrl: hostel.photos.first),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HostelOverview(
                      name: hostel.name,
                      location: hostel.location,
                      rating: hostel.rating,
                      totalRatings: hostel.totalRatings,
                      overview: hostel.overview,
                    ),
                    HostelAmenities(amenities: hostel.amenities),
                    HostelPhotos(hostelPhotosUrls: hostel.photos),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        HostelEnquiryButton(
          name: hostel.name,
          location: hostel.location,
          reviews: hostel.reviews,
          phoneNumber: hostel.phoneNumber,
        ),
      ],
    );
  }
}

