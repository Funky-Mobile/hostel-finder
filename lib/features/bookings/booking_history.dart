import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_finder/features/bookings/view_model/booking_view_model.dart';
import 'package:hostel_finder/features/bookings/widgets/booking_details_bottom_sheet.dart';
import 'package:intl/intl.dart';

import 'daos/booking_dao.dart';

class BookingHistory extends StatefulWidget {
  const BookingHistory({super.key});

  @override
  State<BookingHistory> createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistory> {

  final BookingHistoryViewModel controller = Get.put(BookingHistoryViewModel());
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Booking History',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.black87),
            onPressed: () => controller.fetchBookings(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchBookings(),
        child: Column(
          children: [
            _buildHeader(),
            _buildFilterChips(),
            Expanded(child: _buildBookingsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Search Bar
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              controller: searchController,
              onChanged: controller.updateSearchQuery,
              decoration: InputDecoration(
                hintText: 'Search bookings...',
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[600]),
                  onPressed: () {
                    searchController.clear();
                    controller.updateSearchQuery('');
                  },
                )
                    : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
          ),

          SizedBox(height: 16),

          // Date Range Selector
          Row(
            children: [
              Expanded(
                child: Obx(() => DropdownButtonFormField<String>(
                  value: controller.selectedDateRange.value,
                  decoration: InputDecoration(
                    labelText: 'Date Range',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: controller.dateRangeOptions.map((range) {
                    return DropdownMenuItem(
                      value: range,
                      child: Text(range, style: TextStyle(fontSize: 14)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedDateRange.value = value;
                    }
                  },
                )),
              ),
              SizedBox(width: 12),
              TextButton.icon(
                onPressed: controller.clearFilters,
                icon: Icon(Icons.clear_all, size: 18),
                label: Text('Clear'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Obx(() => Row(
          children: controller.filterOptions.map((filter) {
            bool isSelected = controller.selectedFilter.value == filter;
            return Padding(
              padding: EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(filter),
                selected: isSelected,
                onSelected: (selected) {
                  controller.selectedFilter.value = filter;
                },
                selectedColor: Colors.blue[100],
                checkmarkColor: Colors.blue[600],
                backgroundColor: Colors.grey[100],
                labelStyle: TextStyle(
                  color: isSelected ? Colors.blue[600] : Colors.grey[700],
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            );
          }).toList(),
        )),
      ),
    );
  }

  Widget _buildBookingsList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingWidget();
      }

      if (controller.filteredBookings.isEmpty) {
        return _buildEmptyState();
      }

      return ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: controller.filteredBookings.length,
        itemBuilder: (context, index) {
          return BookingCard(booking: controller.filteredBookings[index]);
        },
      );
    });
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
          ),
          SizedBox(height: 16),
          Text(
            'Loading bookings...',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No bookings found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

// Booking Card Widget
class BookingCard extends StatelessWidget {
  final BookingDao booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _showBookingDetails(context),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Room ${booking.roomNumber}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          booking.roomType,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildStatusChip(),
                      SizedBox(height: 4),
                      _buildPaymentStatusChip(),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Customer Info
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      booking.customerName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8),

              // Dates
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${DateFormat('MMM dd').format(booking.checkInDate)} - ${DateFormat('MMM dd, yyyy').format(booking.checkOutDate)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Text(
                    '${booking.durationInDays} ${booking.durationInDays == 1 ? 'night' : 'nights'}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              // Amount and Booking Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${booking.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[600],
                    ),
                  ),
                  Text(
                    'Booked ${DateFormat('MMM dd, yyyy').format(booking.bookingDate)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
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

  Widget _buildStatusChip() {
    Color statusColor;
    String statusText = booking.bookingStatus;

    if (booking.isActive) {
      statusColor = Colors.green;
      statusText = 'Active';
    } else if (booking.isUpcoming) {
      statusColor = Colors.blue;
      statusText = 'Upcoming';
    } else if (booking.isPast) {
      statusColor = Colors.grey;
      statusText = 'Completed';
    } else {
      switch (booking.bookingStatus.toLowerCase()) {
        case 'cancelled':
          statusColor = Colors.red;
          break;
        case 'confirmed':
          statusColor = Colors.green;
          break;
        default:
          statusColor = Colors.orange;
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 11,
          color: statusColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPaymentStatusChip() {
    Color paymentColor;
    switch (booking.paymentStatus.toLowerCase()) {
      case 'paid':
        paymentColor = Colors.green;
        break;
      case 'pending':
        paymentColor = Colors.orange;
        break;
      case 'failed':
        paymentColor = Colors.red;
        break;
      default:
        paymentColor = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: paymentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        booking.paymentStatus,
        style: TextStyle(
          fontSize: 10,
          color: paymentColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showBookingDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BookingDetailsBottomSheet(booking: booking),
    );
  }
}
