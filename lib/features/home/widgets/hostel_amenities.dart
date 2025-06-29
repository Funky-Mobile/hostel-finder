import 'package:flutter/material.dart';
import 'package:hostel_finder/features/home/widgets/hostel_amenity.dart';

class HostelAmenities extends StatelessWidget {

  final List<String> amenities;

  const HostelAmenities({super.key, required this.amenities});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...amenities.map((amenity) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: HostelAmenity(amenity: amenity),
            );
          })
        ],
      ),
    );
  }
}
