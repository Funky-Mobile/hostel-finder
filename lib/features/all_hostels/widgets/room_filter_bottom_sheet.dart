import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../room/room_view_model/room_view_model.dart';

class RoomFiltersBottomSheet extends StatelessWidget {
  const RoomFiltersBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {

    final RoomViewModel controller = Get.find<RoomViewModel>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Filter Rooms",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Room Type Filter
            Text(
              "Room Type",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Obx(() => Wrap(
              spacing: 8,
              children: controller.roomTypes.map((type) {
                bool isSelected = controller.selectedRoomType.value == type;
                return FilterChip(
                  label: Text(type),
                  selected: isSelected,
                  onSelected: (selected) {
                    controller.selectedRoomType.value = type;
                  },
                  selectedColor: Colors.blue[100],
                  checkmarkColor: Colors.blue[600],
                );
              }).toList(),
            )),

            SizedBox(height: 20),

            // Gender Filter
            Text(
              "Gender",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Obx(() => Wrap(
              spacing: 8,
              children: controller.genders.map((gender) {
                bool isSelected = controller.selectedGender.value == gender;
                return FilterChip(
                  label: Text(gender),
                  selected: isSelected,
                  onSelected: (selected) {
                    controller.selectedGender.value = gender;
                  },
                  selectedColor: Colors.pink[100],
                  checkmarkColor: Colors.pink[600],
                );
              }).toList(),
            )),

            SizedBox(height: 20),

            // Price Range Filter
            Text(
              "Price Range",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Obx(() => Column(
              children: [
                RangeSlider(
                  values: controller.priceRange.value,
                  min: 0,
                  max: 1000,
                  divisions: 20,
                  activeColor: Colors.blue[600],
                  onChanged: (RangeValues values) {
                    controller.priceRange.value = values;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("\$${controller.priceRange.value.start.round()}"),
                    Text("\$${controller.priceRange.value.end.round()}"),
                  ],
                ),
              ],
            )),

            SizedBox(height: 30),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      controller.clearFilters();
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text("Clear All"),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text("Apply"),
                  ),
                ),
              ],
            ),

            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }
}