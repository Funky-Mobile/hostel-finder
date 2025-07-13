import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_finder/core/data/hostel_model.dart';

import '../../favorites/controllers/favorites_controller.dart';

class LikeHostelButton extends StatelessWidget {
  final HostelModel hostel;
  final Color? iconColor;

  const LikeHostelButton({
    super.key,
    required this.hostel,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {

    final controller = Get.find<FavoritesController>();

    return Obx(() {
      final isFavorite = controller.isFavorite(hostel);

      return IconButton(
        onPressed: () => controller.toggleFavorite(hostel),
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
