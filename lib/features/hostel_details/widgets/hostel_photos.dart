import 'package:flutter/material.dart';
import '../../../shared/app_strings/custom_app_strings.dart';
import '../../../shared/custom_app_labels/custom_app_header_text.dart';
import '../../../shared/custom_buttons/custom_text_and_icon_button.dart';

class HostelPhotos extends StatelessWidget {
  final List<String> hostelPhotosUrls;

  const HostelPhotos({super.key, required this.hostelPhotosUrls});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and See All
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomAppHeaderText(
              text: CustomAppStrings.photosString,
              size: 24,
              maxLines: 1,
              fontWeight: FontWeight.bold,
            ),
            CustomTextAndIconButton(
              onPressed: () => _showPhotoBottomSheet(context),
              buttonText: "See All",
              color: Colors.black,
              icon: Icons.keyboard_arrow_right_outlined,
            )
          ],
        ),

        const SizedBox(height: 8),

        // Preview Thumbnails
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: hostelPhotosUrls.map((photoUrl) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black45,
                        offset: Offset(0, 1),
                        blurRadius: 3,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      photoUrl,
                      fit: BoxFit.cover,
                      width: 150,
                      height: 150,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _showPhotoBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.black,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, controller) {
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "Hostel Photos",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: controller,
                    itemCount: hostelPhotosUrls.length,
                    itemBuilder: (context, index) {
                      final photoUrl = hostelPhotosUrls[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            photoUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
