import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../room/room_details/room_detail.dart';
import 'controllers/favorites_controller.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoritesController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.favorites.isEmpty) {
          return const Center(
            child: Text(
              'No favorite rooms yet.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.favorites.length,
          itemBuilder: (context, index) {
            final room = controller.favorites[index];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    room.images.isNotEmpty ? room.images.first : '',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                  ),
                ),
                title: Text(
                  "Room ${room.number} • ${room.type}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Capacity: ${room.capacity} | ${room.gender}\n\$${room.price.toStringAsFixed(2)} people",
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: () {
                    controller.toggleFavorite(room);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RoomDetail(room: room),
                    ),
                  );
                },
              ),
            );
          },
        );
      }),
    );
  }
}
