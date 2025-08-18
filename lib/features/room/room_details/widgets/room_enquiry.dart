import 'package:flutter/material.dart';
import 'package:hostel_finder/shared/custom_app_labels/custom_app_body_text.dart';
import 'package:hostel_finder/shared/custom_app_labels/custom_app_header_text.dart';
import 'package:hostel_finder/utils/vertical_item_spacer.dart';
import 'package:url_launcher/url_launcher.dart';
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
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: CustomAppBodyText(
                                text: "${room.capacity} ${room.capacity == 1 ? 'person' : 'people'}",
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                textColor: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                    ...room.amenities.map((amenity) => _buildAmenityItem(amenity)),
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
                            Icon(Icons.info, color: Colors.blue.shade600, size: 20),
                            const SizedBox(width: 8),
                            const CustomAppBodyText(
                              text: "Booking Information",
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(Icons.payment, "Payment", "GHS${room.price.toInt()} per semester"),
                        const SizedBox(height: 8),
                        _buildInfoRow(Icons.person, "Capacity", "${room.capacity} ${room.capacity == 1 ? 'person' : 'people'}"),
                        const SizedBox(height: 8),
                        _buildInfoRow(Icons.wc, "Gender", "${room.gender} students only"),
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
                          icon: const Icon(Icons.bookmark_add, color: Colors.white),
                          label: CustomAppBodyText(
                            text: room.status.toLowerCase() == 'available'
                                ? "Book Now"
                                : "Not Available",
                            fontWeight: FontWeight.w600,
                            textColor: Colors.white,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: room.status.toLowerCase() == 'available'
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
      builder: (context) => AlertDialog(
        title: const CustomAppHeaderText(
          text: "Contact Information",
          size: 18,
          fontWeight: FontWeight.bold,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomAppBodyText(
              text: "For booking inquiries and more information about this room, please contact:",
              fontSize: 14,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAppBodyText(
                    text: "📞 Phone: +233 XX XXX XXXX",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 4),
                  CustomAppBodyText(
                    text: "📧 Email: bookings@hostel.com",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  )
                ],
              ),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const CustomAppBodyText(
                    text: "Close",
                    fontWeight: FontWeight.w600,
                    textColor: Color(0xFF3B82F6),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _launchPhoneCall(context, "+233XXXXXXXXX");
                  },
                  icon: const Icon(Icons.call, size: 16),
                  label: const CustomAppBodyText(
                    text: "Call Now",
                    fontWeight: FontWeight.w600,
                    textColor: Colors.white,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmBooking(BuildContext context, RoomDao room) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const CustomAppHeaderText(
          text: "Confirm Booking",
          size: 18,
          fontWeight: FontWeight.bold,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBodyText(
              text: "Are you sure you want to book Room ${room.number}?",
              fontSize: 14,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAppBodyText(
                    text: "Room: ${room.number} (${room.type})",
                    fontWeight: FontWeight.w600,
                  ),
                  CustomAppBodyText(
                    text: "Price: GHS${room.price.toInt()} per semester",
                    fontWeight: FontWeight.w600,
                  ),
                  CustomAppBodyText(
                    text: "Capacity: ${room.capacity} ${room.capacity == 1 ? 'person' : 'people'}",
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const CustomAppBodyText(
              text: "Cancel",
              fontWeight: FontWeight.w600,
              textColor: Colors.grey,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Close the bottom sheet too
              _showBookingSuccess(context, room);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
            ),
            child: const CustomAppBodyText(
              text: "Confirm Booking",
              fontWeight: FontWeight.w600,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingSuccess(BuildContext context, RoomDao room) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            const CustomAppHeaderText(
              text: "Booking Submitted!",
              size: 18,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 8),
            CustomAppBodyText(
              text: "Your booking request for Room ${room.number} has been submitted. You will be contacted shortly to complete the process.",
              fontSize: 14,
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const CustomAppBodyText(
              text: "Done",
              fontWeight: FontWeight.w600,
              textColor: Colors.white,
            ),
          ),
        ],
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