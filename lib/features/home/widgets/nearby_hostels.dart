import 'package:flutter/cupertino.dart';
import 'package:hostel_finder/features/home/widgets/nearby_hostel_vertical.dart';
import 'package:hostel_finder/features/home/widgets/nearby_hostels_horizontal.dart';

import '../../../utils/app_device.dart';

class NearbyHostels extends StatelessWidget {

  final String hostelImageUrl;
  final String hostelName;
  final String hostelLocation;
  final double averageRating;
  final String totalRating;

  const NearbyHostels(this.hostelImageUrl, this.hostelName, this.hostelLocation, this.averageRating, this.totalRating, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppDevice.isSmallScreen(context)
        ? NearbyHostelsHorizontal(hostelImageUrl: hostelImageUrl, hostelName: hostelName, hostelLocation: hostelLocation, averageRating: averageRating, totalRating: totalRating)
        : NearbyHostelsVertical(hostelImageUrl: hostelImageUrl, hostelName: hostelName, hostelLocation: hostelLocation, averageRating: averageRating, totalRating: totalRating);
  }
}
