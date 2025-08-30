import 'package:flutter/material.dart';
import 'package:hostel_finder/features/bookings/booking_helper.dart';
import 'package:hostel_finder/shared/custom_app_labels/custom_app_body_text.dart';
import 'package:hostel_finder/shared/custom_app_labels/custom_app_header_text.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../roommate_request/widgets/CreateRoommateRequestDialog.dart';
import '../../../roommate_request/widgets/ExistingRoommateRequestsSheet.dart';
import '../../dao/room_dao.dart';

class RoomEnquiry {
  void showBottomModalSheet(BuildContext context, RoomDao room) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (_, controller) {
            return SingleChildScrollView(
              controller: controller,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Room Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomAppHeaderText(
                          text: "Room ${room.number}",
                          size: 24,
                          fontWeight: FontWeight.bold,
                          textColor: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: CustomAppBodyText(
                                text: room.type,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                textColor: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: CustomAppBodyText(
                                text: "${room.capacity} ${room.capacity == 1
                                    ? 'person'
                                    : 'people'}",
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                textColor: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: CustomAppBodyText(
                                text: "${room.gender} only",
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                textColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomAppHeaderText(
                              text: "GHS${room.price.toInt()}",
                              size: 20,
                              fontWeight: FontWeight.w800,
                              textColor: Colors.white,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: room.status.toLowerCase() == 'available'
                                    ? Colors.green.shade600
                                    : Colors.red.shade600,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: CustomAppBodyText(
                                text: room.status.toUpperCase(),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                textColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Room Description
                  const CustomAppHeaderText(
                    text: "Room Description",
                    size: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: CustomAppBodyText(
                      text: room.description,
                      fontSize: 14,
                      textColor: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Room Amenities
                  if (room.amenities.isNotEmpty) ...[
                    const CustomAppHeaderText(
                      text: "Room Amenities",
                      size: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 12),
                    ...room.amenities.map((amenity) =>
                        _buildAmenityItem(amenity)),
                    const SizedBox(height: 20),
                  ],

                  // Roommate Options Section
                  if (room.capacity > 1 &&
                      room.status.toLowerCase() == 'available') ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.purple.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.people, color: Colors.purple.shade600,
                                  size: 20),
                              const SizedBox(width: 8),
                              const CustomAppBodyText(
                                text: "Roommate Options",
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const CustomAppBodyText(
                            text: "This room can accommodate multiple people. You can either book alone and get matched with roommates, or create a roommate request to find compatible roommates before booking.",
                            fontSize: 14,
                            textColor: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () =>
                                      _createRoommateRequest(context, room),
                                  icon: Icon(Icons.person_search, size: 16,
                                      color: Colors.purple.shade600),
                                  label: const CustomAppBodyText(
                                    text: "Find Roommate",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    side: BorderSide(
                                        color: Colors.purple.shade600),
                                    foregroundColor: Colors.purple.shade600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () =>
                                      _viewExistingRequests(context, room),
                                  icon: Icon(Icons.search, size: 16,
                                      color: Colors.purple.shade600),
                                  label: const CustomAppBodyText(
                                    text: "Join Request",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    side: BorderSide(
                                        color: Colors.purple.shade600),
                                    foregroundColor: Colors.purple.shade600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Booking Instructions
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info, color: Colors.blue.shade600,
                                size: 20),
                            const SizedBox(width: 8),
                            const CustomAppBodyText(
                              text: "Booking Information",
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(Icons.payment, "Payment", "GHS${room.price
                            .toInt()} per semester"),
                        const SizedBox(height: 8),
                        _buildInfoRow(Icons.person, "Capacity", "${room
                            .capacity} ${room.capacity == 1
                            ? 'person'
                            : 'people'}"),
                        const SizedBox(height: 8),
                        _buildInfoRow(Icons.wc, "Gender", "${room
                            .gender} students only"),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          room.status.toLowerCase() == 'available'
                              ? Icons.check_circle
                              : Icons.cancel,
                          "Status",
                          room.status.toLowerCase() == 'available'
                              ? "Available for booking"
                              : "Currently occupied",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showContactInfo(context),
                          icon: const Icon(Icons.contact_phone),
                          label: const CustomAppBodyText(
                            text: "Contact Info",
                            fontWeight: FontWeight.w600,
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            side: const BorderSide(color: Color(0xFF3B82F6)),
                            foregroundColor: const Color(0xFF3B82F6),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: room.status.toLowerCase() == 'available'
                              ? () => _confirmBooking(context, room)
                              : null,
                          icon: const Icon(
                              Icons.bookmark_add, color: Colors.white),
                          label: CustomAppBodyText(
                            text: room.status.toLowerCase() == 'available'
                                ? "Book Now"
                                : "Not Available",
                            fontWeight: FontWeight.w600,
                            textColor: Colors.white,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: room.status.toLowerCase() ==
                                'available'
                                ? const Color(0xFF3B82F6)
                                : Colors.grey.shade400,
                            padding: const EdgeInsets.all(16),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _createRoommateRequest(BuildContext context, RoomDao room) async {
    Navigator.pop(context); // Close bottom sheet first

    // Show create roommate request dialog with pre-selected room
    final result = await showDialog(
      context: context,
      builder: (context) => CreateRoommateRequestDialog(
        preSelectedRoomId: room.id,
        preSelectedRoomNumber: room.number,
      ),
    );

    if (result != null) {
      // TODO: Handle the roommate request creation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Roommate request created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _viewExistingRequests(BuildContext context, RoomDao room) {
    Navigator.pop(context); // Close bottom sheet first

    // Show existing roommate requests for this room
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) => ExistingRoommateRequestsSheet(room: room),
    );
  }

  Widget _buildAmenityItem(String amenity) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            _getAmenityIcon(amenity),
            size: 18,
            color: Colors.green.shade600,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: CustomAppBodyText(
              text: amenity,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.blue.shade600),
        const SizedBox(width: 8),
        CustomAppBodyText(
          text: "$label:",
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CustomAppBodyText(
            text: value,
            fontSize: 13,
            textColor: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  IconData _getAmenityIcon(String amenity) {
    final lowerAmenity = amenity.toLowerCase();
    if (lowerAmenity.contains('wifi') || lowerAmenity.contains('internet')) {
      return Icons.wifi;
    } else if (lowerAmenity.contains('ac') || lowerAmenity.contains('air')) {
      return Icons.ac_unit;
    } else if (lowerAmenity.contains('bed') || lowerAmenity.contains('mattress')) {
      return Icons.bed;
    } else if (lowerAmenity.contains('desk') || lowerAmenity.contains('table')) {
      return Icons.desk;
    } else if (lowerAmenity.contains('wardrobe') || lowerAmenity.contains('closet')) {
      return Icons.weekend;
    } else if (lowerAmenity.contains('window') || lowerAmenity.contains('ventilation')) {
      return Icons.window;
    } else if (lowerAmenity.contains('fan')) {
      return Icons.toys;
    } else if (lowerAmenity.contains('light') || lowerAmenity.contains('lamp')) {
      return Icons.lightbulb;
    }
    // else if (lowerAmenity.contains('mirror')) {
    //   return Icons.mirror;
    // }
    else if (lowerAmenity.contains('socket') || lowerAmenity.contains('outlet')) {
      return Icons.power;
    } else {
      return Icons.check_circle;
    }
  }


  void _showContactInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Row(
                children: [
                  const Icon(Icons.info_outline, color: Color(0xFF3B82F6)),
                  const SizedBox(width: 8),
                  const CustomAppHeaderText(
                    text: "Contact Information",
                    size: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Description
              const CustomAppBodyText(
                text:
                "For booking inquiries and more information about this room, please contact:",
                fontSize: 14,
              ),
              const SizedBox(height: 16),

              // Contact Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    CustomAppBodyText(
                      text: "📞 Phone: +233 XX XXX XXXX",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 6),
                    CustomAppBodyText(
                      text: "📧 Email: bookings@hostel.com",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: Color(0xFF3B82F6)),
                      ),
                      child: const CustomAppBodyText(
                        text: "Close",
                        fontWeight: FontWeight.w600,
                        textColor: Color(0xFF3B82F6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _launchPhoneCall(context, "+233XXXXXXXXX");
                      },
                      icon: const Icon(Icons.call, size: 18),
                      label: const CustomAppBodyText(
                        text: "Call Now",
                        fontWeight: FontWeight.w600,
                        textColor: Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }



  void _confirmBooking(BuildContext context, RoomDao room) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Row(
                children: [
                  const Icon(Icons.event_available, color: Color(0xFF3B82F6), size: 26),
                  const SizedBox(width: 8),
                  const CustomAppHeaderText(
                    text: "Confirm Booking",
                    size: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Main prompt
              CustomAppBodyText(
                text: "Are you sure you want to book Room ${room.number}?",
                fontSize: 14,
                textColor: Colors.black87,
              ),
              const SizedBox(height: 16),

              // Room details card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomAppBodyText(
                      text: "Room: ${room.number} (${room.type})",
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 6),
                    CustomAppBodyText(
                      text: "Price: GHS${room.price.toInt()} per semester",
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 6),
                    CustomAppBodyText(
                      text: "Capacity: ${room.capacity} ${room.capacity == 1 ? 'person' : 'people'}",
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const CustomAppBodyText(
                        text: "Cancel",
                        fontWeight: FontWeight.w600,
                        textColor: Colors.grey,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context); // Close confirmation dialog
                        await BookingHelper.handleBooking(context, room);
                        if (context.mounted) Navigator.pop(context); // Close bottom sheet
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const CustomAppBodyText(
                        text: "Confirm Booking",
                        fontWeight: FontWeight.w600,
                        textColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }



  void _launchPhoneCall(BuildContext context, String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      if(context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not launch dialer.")),
        );
      }
    }
  }
}