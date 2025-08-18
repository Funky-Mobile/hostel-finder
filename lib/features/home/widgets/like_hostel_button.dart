import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../favorites/controllers/favorites_controller.dart';
import '../../room/dao/room_dao.dart';
import '../home_screen.dart';

class LikeRoomButton extends StatelessWidget {
  final RoomDao room;
  final Color? iconColor;

  const LikeRoomButton({
    super.key,
    required this.room,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoritesController>();

    return Obx(() {
      final isFavorite = controller.isFavorite(room);

      return IconButton(
        onPressed: () => controller.toggleFavorite(room),
        icon: isFavorite
            ? CircleAvatar(
          backgroundColor: Colors.black.withOpacity(0.05),
          child: const Icon(Icons.favorite, color: Colors.red),
        )
            : Icon(
          Icons.favorite_border_outlined,
          color: iconColor ?? Colors.black54,
        ),
      );
    });
  }
}
