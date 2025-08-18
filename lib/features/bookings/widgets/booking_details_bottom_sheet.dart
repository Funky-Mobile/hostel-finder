import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../maintenance/maintenance_view_model.dart';
import '../daos/booking_dao.dart';
import 'package:get/get.dart';


class BookingDetailsBottomSheet extends StatelessWidget {
  final BookingDao booking;

  BookingDetailsBottomSheet({super.key, required this.booking});

  final MaintenanceViewModel _maintenanceViewModel = Get.put(MaintenanceViewModel());


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Booking Details',
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
          ),

          Divider(),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailSection('Room Information', [
                    _buildDetailRow('Room Number', booking.roomNumber),
                    _buildDetailRow('Room Type', booking.roomType),
                    _buildDetailRow('Capacity', '${booking.capacity} ${booking.capacity == 1 ? 'person' : 'people'}'),
                    _buildDetailRow('Gender', booking.gender),
                  ]),

                  _buildDetailSection('Customer Information', [
                    _buildDetailRow('Name', booking.customerName),
                    _buildDetailRow('Email', booking.customerEmail),
                  ]),

                  _buildDetailSection('Booking Information', [
                    _buildDetailRow('Check-in', DateFormat('EEEE, MMM dd, yyyy').format(booking.checkInDate)),
                    _buildDetailRow('Check-out', DateFormat('EEEE, MMM dd, yyyy').format(booking.checkOutDate)),
                    _buildDetailRow('Duration', '${booking.durationInDays} ${booking.durationInDays == 1 ? 'night' : 'nights'}'),
                    _buildDetailRow('Booking Date', DateFormat('MMM dd, yyyy - hh:mm a').format(booking.bookingDate)),
                  ]),

                  _buildDetailSection('Payment Information', [
                    _buildDetailRow('Total Amount', '\$${booking.totalAmount.toStringAsFixed(2)}'),
                    _buildDetailRow('Payment Status', booking.paymentStatus),
                    _buildDetailRow('Booking Status', booking.bookingStatus),
                  ]),

                  if (booking.amenities.isNotEmpty)
                    _buildDetailSection('Amenities', [
                      Container(
                        width: double.infinity,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: booking.amenities.map((amenity) {
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.blue[200]!),
                              ),
                              child: Text(
                                amenity,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ]),

                  if (booking.specialRequests != null && booking.specialRequests!.isNotEmpty)
                    _buildDetailSection('Special Requests', [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Text(
                          booking.specialRequests!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ]),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showMaintenanceRequestDialog(context, booking.roomId);
                },
                child: Text('Request Maintenance'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMaintenanceRequestDialog(BuildContext context, String roomId) {
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Request Maintenance'),
          content: TextField(
            controller: descriptionController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Enter maintenance description',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {

                await _maintenanceViewModel.requestMaintenance(roomId, descriptionController.text);

                if(context.mounted) {
                  Navigator.pop(context);
                  Get.snackbar('Success', 'Maintenance request submitted');
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12),
        ...children,
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}