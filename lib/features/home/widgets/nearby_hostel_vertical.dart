import 'package:flutter/material.dart';
import 'package:hostel_finder/core/data/hostel_model.dart';
import 'package:hostel_finder/features/home/widgets/like_hostel_button.dart';
import '../../../shared/custom_app_labels/custom_app_header_text.dart';
import 'app_hostel_location.dart';
import 'app_hostel_ratings.dart';

class NearbyHostelsVertical extends StatelessWidget {
  final HostelModel hostel;

  const NearbyHostelsVertical({super.key, required this.hostel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hostel Image
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            hostel.photos.isNotEmpty ? hostel.photos.first : '',
            width: MediaQuery.of(context).size.width,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
          ),
        ),

        const SizedBox(height: 8),

        // Hostel Name
        CustomAppHeaderText(
          text: hostel.name,
          size: 24,
          maxLines: 1,
        ),

        // Location, Rating & Like Button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppHostelLocation(
                  location: hostel.location,
                  color: Colors.black,
                ),
                const SizedBox(height: 4),
                AppHostelRatings(
                  averageRating: hostel.rating,
                  totalRating: '${hostel.totalRatings} Reviews',
                ),
              ],
            ),

            // Like button with hostel model
            LikeHostelButton(hostel: hostel),
          ],
        ),
      ],
    );
  }
}
