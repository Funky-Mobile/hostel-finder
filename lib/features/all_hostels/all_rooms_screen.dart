import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_finder/features/all_hostels/widgets/all_hostels_header.dart';
import 'package:hostel_finder/features/all_hostels/widgets/room_card.dart';
import 'package:hostel_finder/features/all_hostels/widgets/room_filter_bottom_sheet.dart';
import 'package:sticky_headers/sticky_headers.dart';
import '../../../shared/custom_app_labels/custom_app_body_text.dart';
import '../room/room_view_model/room_view_model.dart';

class AllRoomsScreen extends StatefulWidget {
  final String headerString;

  const AllRoomsScreen({super.key, required this.headerString});

  @override
  State<AllRoomsScreen> createState() => _AllRoomsScreenState();
}

class _AllRoomsScreenState extends State<AllRoomsScreen> {

  final RoomViewModel controller = Get.put(RoomViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => controller.fetchRooms(),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: StickyHeader(
              header: EnhancedAllRoomsHeader(
                headerString: widget.headerString,
                onSearchChanged: controller.updateSearchQuery,
                onFilterPressed: () => _showFiltersBottomSheet(context),
              ),
              content: Obx(() {
                if (controller.isLoading.value) {
                  return _buildLoadingWidget();
                }

                if (controller.filteredRooms.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildRoomsList();
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
            ),
            SizedBox(height: 16),
            CustomAppBodyText(text: "Loading rooms..."),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            CustomAppBodyText(text: "No rooms found"),
            SizedBox(height: 8),
            TextButton(
              onPressed: controller.clearFilters,
              child: Text(
                "Clear filters",
                style: TextStyle(color: Colors.blue[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomsList() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Results count
          Obx(() => Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              "${controller.filteredRooms.length} rooms found",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          )),

          // Rooms grid
          Obx(() => GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: controller.filteredRooms.length,
            itemBuilder: (context, index) {
              return RoomCard(room: controller.filteredRooms[index]);
            },
          )),
        ],
      ),
    );
  }

  void _showFiltersBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RoomFiltersBottomSheet(),
    );
  }
}