import 'package:flutter/material.dart';
import 'package:hostel_finder/core/data/hostel_model.dart';
import 'package:hostel_finder/features/home/widgets/app_hostel_location.dart';
import 'package:hostel_finder/features/home/widgets/app_hostel_ratings.dart';
import 'package:hostel_finder/features/home/widgets/hostel_amenities.dart';
import 'package:hostel_finder/features/home/widgets/like_hostel_button.dart';
import 'package:hostel_finder/shared/custom_app_labels/custom_app_header_text.dart';

class PopularHostelCard extends StatelessWidget {
  final HostelModel hostel;

  const PopularHostelCard({super.key, required this.hostel});

  @override
  Widget build(BuildContext context) {
    final imageUrl = hostel.photos.isNotEmpty ? hostel.photos.first : '';

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
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
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
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
                        child: LikeHostelButton(hostel: hostel),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8.0),

              AppHostelRatings(
                averageRating: hostel.rating,
                totalRating: '${hostel.totalRatings}',
              ),

              CustomAppHeaderText(
                text: hostel.name,
                size: 24,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              AppHostelLocation(
                location: hostel.location,
                color: Colors.black,
              ),

              const SizedBox(height: 8.0),

              HostelAmenities(amenities: hostel.amenities),
            ],
          ),
        ),
      ),
    );
  }
}
