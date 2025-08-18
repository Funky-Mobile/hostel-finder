import 'dart:developer';
import 'package:get/get.dart';

import '../daos/booking_dao.dart';

class BookingHistoryViewModel extends GetxController {
  var bookings = <BookingDao>[].obs;
  var filteredBookings = <BookingDao>[].obs;
  var selectedFilter = 'All'.obs;
  var searchQuery = ''.obs;
  var isLoading = false.obs;
  var selectedDateRange = 'All Time'.obs;

  final List<String> filterOptions = [
    'All',
    'Active',
    'Upcoming',
    'Past',
    'Cancelled'
  ];

  final List<String> dateRangeOptions = [
    'All Time',
    'This Week',
    'This Month',
    'Last 3 Months',
    'This Year'
  ];

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
    // Listen to filter changes
    ever(selectedFilter, (_) => filterBookings());
    ever(selectedDateRange, (_) => filterBookings());
    debounce(searchQuery, (_) => filterBookings(), time: Duration(milliseconds: 300));
  }

  Future<void> fetchBookings() async {
    try {
      isLoading.value = true;
      // Simulate API call - replace with actual API endpoint
      await Future.delayed(Duration(seconds: 2));

      // Mock data - replace with actual API call
      final mockBookings = [
        BookingDao(
          id: '1',
          roomNumber: 'A101',
          roomType: 'Single',
          customerName: 'John Doe',
          customerEmail: 'john@example.com',
          checkInDate: DateTime.now().subtract(Duration(days: 5)),
          checkOutDate: DateTime.now().add(Duration(days: 2)),
          totalAmount: 350.0,
          paymentStatus: 'Paid',
          bookingStatus: 'Active',
          bookingDate: DateTime.now().subtract(Duration(days: 10)),
          amenities: ['WiFi', 'AC', 'TV'],
          gender: 'Male',
          capacity: 1,
          roomId: 'R100D',
        ),
        BookingDao(
          id: '2',
          roomNumber: 'B205',
          roomType: 'Double',
          customerName: 'Jane Smith',
          customerEmail: 'jane@example.com',
          checkInDate: DateTime.now().add(Duration(days: 3)),
          checkOutDate: DateTime.now().add(Duration(days: 8)),
          totalAmount: 750.0,
          paymentStatus: 'Paid',
          bookingStatus: 'Confirmed',
          bookingDate: DateTime.now().subtract(Duration(days: 7)),
          amenities: ['WiFi', 'AC', 'TV', 'Mini Fridge'],
          gender: 'Female',
          capacity: 2,
          specialRequests: 'Ground floor room preferred',
          roomId: 'R2DDE23',
        ),
        // Add more mock data as needed
      ];

      bookings.assignAll(mockBookings);
      filteredBookings.assignAll(mockBookings);
    } catch (e) {
      log('Error fetching bookings: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void filterBookings() {
    var filtered = bookings.where((booking) {
      // Filter by status
      bool matchesStatus = true;
      switch (selectedFilter.value) {
        case 'Active':
          matchesStatus = booking.isActive;
          break;
        case 'Upcoming':
          matchesStatus = booking.isUpcoming;
          break;
        case 'Past':
          matchesStatus = booking.isPast;
          break;
        case 'Cancelled':
          matchesStatus = booking.bookingStatus.toLowerCase() == 'cancelled';
          break;
      }

      // Filter by search query
      bool matchesSearch = searchQuery.value.isEmpty ||
          booking.roomNumber.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          booking.customerName.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          booking.customerEmail.toLowerCase().contains(searchQuery.value.toLowerCase());

      // Filter by date range
      bool matchesDateRange = _matchesDateRange(booking);

      return matchesStatus && matchesSearch && matchesDateRange;
    }).toList();

    // Sort by booking date (newest first)
    filtered.sort((a, b) => b.bookingDate.compareTo(a.bookingDate));
    filteredBookings.assignAll(filtered);
  }

  bool _matchesDateRange(BookingDao booking) {
    final now = DateTime.now();
    switch (selectedDateRange.value) {
      case 'This Week':
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        return booking.bookingDate.isAfter(weekStart);
      case 'This Month':
        final monthStart = DateTime(now.year, now.month, 1);
        return booking.bookingDate.isAfter(monthStart);
      case 'Last 3 Months':
        final threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);
        return booking.bookingDate.isAfter(threeMonthsAgo);
      case 'This Year':
        final yearStart = DateTime(now.year, 1, 1);
        return booking.bookingDate.isAfter(yearStart);
      default:
        return true;
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void clearFilters() {
    selectedFilter.value = 'All';
    selectedDateRange.value = 'All Time';
    searchQuery.value = '';
  }
}