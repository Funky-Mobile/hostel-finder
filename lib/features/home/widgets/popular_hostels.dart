import 'package:flutter/material.dart';
import 'package:hostel_finder/features/all_hostels/all_rooms_screen.dart';
import 'package:hostel_finder/features/bookings/booking_helper.dart';
import 'package:hostel_finder/features/home/widgets/nearby_hostels.dart';
import 'package:hostel_finder/features/home/widgets/popular_hostel_card.dart';
import 'package:hostel_finder/features/home/widgets/view_all_hostels_button.dart';
import 'package:hostel_finder/shared/app_strings/custom_app_strings.dart';

import '../../room/dao/room_dao.dart';
import '../../room/room_details/room_detail.dart';

class PopularHostels extends StatefulWidget {
  final List<RoomDao> hostelResults;

  const PopularHostels({
    super.key,
    required this.hostelResults,
  });

  @override
  State<PopularHostels> createState() => _PopularHostelsState();
}

class _PopularHostelsState extends State<PopularHostels> {
  Set<String> bookingRooms = <String>{}; // Track which rooms are being booked

  @override
  Widget build(BuildContext context) {
    // Show only the top 3 as popular
    final popular = widget.hostelResults.take(3).toList();

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
                  isBooking: bookingRooms.contains(room.id),
                  onViewDetails: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RoomDetail(room: room),
                      ),
                    );
                  },
                  onBookNow: () => BookingHelper.handleBooking(context, room)
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
                  builder: (_) => AllRoomsScreen(
                    headerString: CustomAppStrings.nearbyHostelsString,
                  ),
                ),
              );
            },
          ),
        ),

        /// ---- Nearby Hostels (Vertical List) ----
        Column(
          children: widget.hostelResults.map((room) {
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