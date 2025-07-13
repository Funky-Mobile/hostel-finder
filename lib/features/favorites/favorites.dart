import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../hostel_details/hostel_detail.dart';
import 'controllers/favorites_controller.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.find<FavoritesController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: Obx(() {
        if (controller.favorites.isEmpty) {
          return const Center(child: Text('No favorite hostels yet.'));
        }

        return ListView.builder(
          itemCount: controller.favorites.length,
          itemBuilder: (context, index) {
            final hostel = controller.favorites[index];
            return ListTile(
              leading: Image.network(hostel.photos.first),
              title: Text(hostel.name),
              subtitle: Text(hostel.location),
              trailing: IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () {
                  controller.toggleFavorite(hostel);
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HostelDetail(hostel: hostel),
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }
}
