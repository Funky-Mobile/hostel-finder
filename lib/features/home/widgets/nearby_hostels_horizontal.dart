import 'package:flutter/material.dart';
import 'package:hostel_finder/core/data/hostel_model.dart';
import 'package:hostel_finder/features/home/widgets/like_hostel_button.dart';
import '../../../shared/custom_app_labels/custom_app_header_text.dart';
import 'app_hostel_location.dart';
import 'app_hostel_ratings.dart';

class NearbyHostelsHorizontal extends StatelessWidget {
  final HostelModel hostel;

  const NearbyHostelsHorizontal({super.key, required this.hostel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Image + Details
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45,
                      offset: Offset(0, 1),
                      blurRadius: 3,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    hostel.photos.isNotEmpty ? hostel.photos.first : '',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 100,
                        height: 100,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hostel Name
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .55,
                      child: CustomAppHeaderText(
                        text: hostel.name,
                        size: 20,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Location
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: AppHostelLocation(
                        location: hostel.location,
                        color: Colors.black,
                      ),
                    ),
                    // Rating
                    AppHostelRatings(
                      averageRating: hostel.rating,
                      totalRating: '${hostel.totalRatings} Reviews',
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Favorite Button
          SizedBox(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                LikeHostelButton(hostel: hostel),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
