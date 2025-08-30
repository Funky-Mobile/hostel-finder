import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_finder/core/cache/user_cache_service.dart';
import 'package:hostel_finder/features/bookings/view_model/booking_view_model.dart';
import 'package:hostel_finder/features/room/dao/room_dao.dart';
import 'package:hostel_finder/features/roommate_request/dtos/RoommateRequest.dart';
import 'package:hostel_finder/features/roommate_request/dtos/JoinRequestData.dart';
import '../../../core/app_urls/app_urls.dart';
import '../../../core/request_interceptor/auth_client.dart';

class RoommateRequestViewmodel extends GetxController {

  final client = AuthClient();
  final BookingViewModel _bookingViewModel = Get.put(BookingViewModel());

  RxString currentUserId = ''.obs;

  // ========== LOADERS ==========

  Future<List<RoommateRequest>> loadAllRequests() async {
    try {
      final response = await client.get(AppUrls.roommateRequestsUrl);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        return data.map((e) => RoommateRequest.fromJson(e)).toList();
      }
      log("Failed to load all roommate requests: ${response.statusCode}");
      return [];
    } catch (e) {
      log("Error loading all requests: $e");
      return [];
    }
  }

  Future<List<RoommateRequest>> loadRequestsByRoomId(String roomId) async {
    try {
      final response = await client.get(AppUrls.roommateRequestsByRoomIdUrl(roomId));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        return data.map((e) => RoommateRequest.fromJson(e)).toList();
      } else {
        log("Failed to load roommate requests for room $roomId. Status: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      log("Error loading roommate requests by room: $e");
      return [];
    }
  }

  Future<List<RoommateRequest>> loadMyRequests() async {
    try {
      final user = await UserCacheService.getUser();

      final response = await client.get(AppUrls.roommateRequestsByStudentUrl(user!.id));

      currentUserId.value = user.id;

      log("Roommate requests: {\n   currentUserId: ${currentUserId.value},\n    data: ${response.body} \n}");

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        return data.map((e) => RoommateRequest.fromJson(e)).toList();
      }
      log("Failed to load my roommate requests: ${response.statusCode}");
      return [];
    } catch (e) {
      log("Error loading my requests: $e");
      return [];
    }
  }

  Future<List<RoommateRequest>> loadJoinedRequests() async {
    try {

      final user = await UserCacheService.getUser();

      final response = await client.get(AppUrls.joinedRequestsByStudentUrl(user!.id));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        return data.map((e) => RoommateRequest.fromJson(e)).toList();
      }
      log("Failed to load joined requests: ${response.statusCode}");
      return [];
    } catch (e) {
      log("Error loading joined requests: $e");
      return [];
    }
  }


  // ========== ACTIONS ==========

  Future<void> createRoommateRequest(
      BuildContext context,
      RoomDao room,
      String preferences,
      ) async {
    try {
      final user = await UserCacheService.getUser();

      // Show beautiful confirmation dialog
      final confirm = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with icon
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.home,
                          color: Colors.blue.shade600,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "Confirm Roommate Request",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Warning message
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.orange.shade600,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            "Creating this roommate request will also book the room.",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Room details card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Room Details",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow(Icons.meeting_room, "Room Number", room.number),
                        const SizedBox(height: 8),
                        _buildDetailRow(Icons.location_on, "Hostel", room.hostelName),
                        const SizedBox(height: 8),
                        _buildDetailRow(Icons.category, "Type", room.type),
                        const SizedBox(height: 8),
                        _buildDetailRow(Icons.people, "Capacity", "${room.capacity} people"),
                        const SizedBox(height: 8),
                        _buildDetailRow(Icons.attach_money, "Price", "\$${room.price.toStringAsFixed(2)}"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          "Confirm",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );

      if (confirm != true) return; // user cancelled

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Loading animation
                  Container(
                    width: 60,
                    height: 60,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Processing Request",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Please wait while we create your roommate request and book the room...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

      try {
        // Step 1: book room first
        bool booked = await _bookingViewModel.createBooking(
          roomId: room.id,
          amount: room.price,
        );

        if (!booked) {
          // Close loading dialog
          if (context.mounted) Navigator.pop(context);
          _showErrorSnackBar(context, "Failed to book room. Request not created.");
          return;
        }

        // Step 2: create roommate request
        final body = jsonEncode({
          "studentId": user!.id,
          "roomId": room.id,
          "preferences": preferences,
        });

        final response = await client.post(
          AppUrls.roommateRequestsUrl,
          headers: {"Content-Type": "application/json"},
          body: body,
        );

        // Close loading dialog
        if (context.mounted) Navigator.pop(context);

        if (response.statusCode == 201) {
          if (context.mounted) {
            _showSuccessSnackBar(context, "Roommate request created successfully!");
            Navigator.pop(context, true);
          }
        } else {
          _showErrorSnackBar(
            context,
            "Failed to create roommate request. Status: ${response.statusCode}",
          );
        }
      } catch (e) {
        // Close loading dialog if still open
        if (context.mounted) Navigator.pop(context);
        _showErrorSnackBar(context, "Error creating roommate request: $e");
      }
    } catch (e) {
      _showErrorSnackBar(context, "Error creating roommate request: $e");
    }
  }

  Future<void> confirmAndJoinRequest(
      BuildContext context, String requestId, JoinRequestData data, RoomDao room) async {
    // Show beautiful confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with icon
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.group_add,
                        color: Colors.green.shade600,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "Confirm Join Request",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Warning message
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.orange.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          "By joining this request, you will automatically book this room.",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Room details card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Room Details",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(Icons.meeting_room, "Room Number", room.number),
                      const SizedBox(height: 8),
                      _buildDetailRow(Icons.location_on, "Hostel", room.hostelName),
                      const SizedBox(height: 8),
                      _buildDetailRow(Icons.category, "Type", room.type),
                      const SizedBox(height: 8),
                      _buildDetailRow(Icons.people, "Capacity", "${room.capacity} people"),
                      const SizedBox(height: 8),
                      _buildDetailRow(Icons.attach_money, "Price", "\${room.price.toStringAsFixed(2)}"),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        "Join Request",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (confirm != true) return; // User cancelled

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Loading animation
                Container(
                  width: 60,
                  height: 60,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade600),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Joining Request",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Please wait while we process your join request and book the room...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    // Proceed with join + booking
    try {
      final response = await client.post(
        AppUrls.joinRoommateRequestUrl(requestId),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data.toJson()),
      );

      if (response.statusCode == 200) {
        bool booked = await _bookingViewModel.createBooking(
          roomId: room.id,
          amount: room.price,
        );

        // Close loading dialog
        if (context.mounted) Navigator.pop(context);

        if (booked) {
          _showSuccessSnackBar(context, "Successfully joined and booked room!");
        } else {
          _showErrorSnackBar(context, "Joined request but booking failed.");
        }
      } else {
        // Close loading dialog
        if (context.mounted) Navigator.pop(context);
        _showErrorSnackBar(context, "Failed to join request. Status: ${response.statusCode}");
      }
    } catch (e) {
      // Close loading dialog if still open
      if (context.mounted) Navigator.pop(context);
      _showErrorSnackBar(context, "Error joining request: $e");
    }
  }

// Helper widget for detail rows
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 8),
        Text(
          "$label:",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }




  Future<void> cancelRequest(BuildContext context, String requestId, String studentId) async {
    try {
      final response =
      await client.delete(AppUrls.cancelRoommateRequestUrl(requestId, studentId));

      if (response.statusCode == 200) {
        _showSuccessSnackBar(context, "Roommate request cancelled successfully!");
      } else {
        _showErrorSnackBar(context,
            "Failed to cancel request. Status: ${response.statusCode}");
      }
    } catch (e) {
      _showErrorSnackBar(context, "Error cancelling request: $e");
    }
  }

  // ========== HELPERS ==========

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green)
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
