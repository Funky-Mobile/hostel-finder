import 'package:flutter/material.dart';
import 'package:hostel_finder/features/all_hostels/all_hostels.dart';
import 'package:hostel_finder/features/home/widgets/nearby_hostels.dart';
import 'package:hostel_finder/features/home/widgets/popular_hostel_card.dart';
import 'package:hostel_finder/features/home/widgets/view_all_hostels_button.dart';
import 'package:hostel_finder/features/hostel_details/room_detail.dart';
import 'package:hostel_finder/shared/app_strings/custom_app_strings.dart';

import '../home_screen.dart';

class PopularHostels extends StatelessWidget {
  final List<RoomDao> hostelResults;

  const PopularHostels({
    super.key,
    required this.hostelResults,
  });

  @override
  Widget build(BuildContext context) {
    // Show only the top 3 as popular
    final popular = hostelResults.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ---- Horizontal List for Top Hostels ----
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: popular.map((room) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: PopularHostelCard(
                  hostel: room,
                  onViewDetails: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RoomDetail(room: room),
                      ),
                    );
                  },
                  onBookNow: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Booking room ${room.number}...'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          ),
        ),

        /// ---- View All Button ----
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 4.0, left: 8.0),
          child: ViewAllHostelsButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AllHostels(
                    headerString: CustomAppStrings.nearbyHostelsString,
                  ),
                ),
              );
            },
          ),
        ),

        /// ---- Nearby Hostels (Vertical List) ----
        Column(
          children: hostelResults.map((room) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => RoomDetail(room: room),
                  ),
                );
              },
              child: NearbyHostels(room: room),
            );
          }).toList(),
        ),
      ],
    );
  }
}
