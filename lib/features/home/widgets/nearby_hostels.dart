import 'package:flutter/cupertino.dart';
import 'package:hostel_finder/features/home/widgets/nearby_hostels_cards.dart';
import '../../../utils/app_device.dart';
import '../../room/dao/room_dao.dart';
import '../home_screen.dart';

class NearbyHostels extends StatelessWidget {

  final RoomDao room;

  const NearbyHostels({required this.room ,super.key});

  @override
  Widget build(BuildContext context) {
    return AppDevice.isSmallScreen(context)
        ? RoomCardHorizontal(room: room)
        : RoomCardVertical(room: room);
  }
}
