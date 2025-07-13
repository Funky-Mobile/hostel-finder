import 'package:flutter/cupertino.dart';
import 'package:hostel_finder/core/data/hostel_model.dart';
import 'package:hostel_finder/features/home/widgets/nearby_hostel_vertical.dart';
import 'package:hostel_finder/features/home/widgets/nearby_hostels_horizontal.dart';

import '../../../utils/app_device.dart';

class NearbyHostels extends StatelessWidget {

  final HostelModel hostel;

  const NearbyHostels({required this.hostel ,super.key});

  @override
  Widget build(BuildContext context) {
    return AppDevice.isSmallScreen(context)
        ? NearbyHostelsHorizontal(hostel: hostel)
        : NearbyHostelsVertical(hostel: hostel);
  }
}
