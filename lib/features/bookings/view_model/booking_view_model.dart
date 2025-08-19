import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:hostel_finder/core/app_urls/app_urls.dart';
import 'package:hostel_finder/core/cache/user_cache_service.dart';
import 'package:hostel_finder/core/request_interceptor/auth_client.dart';
import 'package:hostel_finder/core/user/user_model.dart';

import '../daos/booking_dao.dart';
import '../dtos/create_booking_request.dart';

class BookingViewModel extends GetxController {
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


  Future<bool> createBooking({
    required String roomId  ,
    required double amount
  }) async {
    try {
      isLoading.value = true;

      User? user = await UserCacheService.getUser();

      final bookingRequest = CreateBookingRequest(
        studentId: user!.id,
        roomId: roomId,
        checkInDate: DateTime.parse("2025-09-01T00:00:00"),
        checkOutDate: DateTime.parse("2026-06-30T00:00:00"),
        amountPaid: amount,
      );

      final client = AuthClient();
      final response = await client.post(
        AppUrls.createBookingUrl,
        body: jsonEncode(bookingRequest.toJson()),
      );

      if (response.statusCode == 201) {
        log("Booking created successfully");
        fetchBookings();
        return true;
      } else {
        log("Booking creation failed: ${response.body}");
      }
    } catch (e) {
      log("Error creating booking: $e");
    } finally {
      isLoading.value = false;
    }

    return false;
  }



  Future<void> fetchBookings() async {
    try {
      isLoading.value = true;

      User? user = await UserCacheService.getUser();

      final client = AuthClient();
      final response = await client.get(
        AppUrls.findStudentBookingsUrl(user!.id)
      );

      if(response.statusCode == 200) {

        final List<dynamic> jsonData = jsonDecode(response.body)['data'];
        final fetchedBookings = BookingDao.listFromJson(jsonData);

        bookings.assignAll(fetchedBookings);
        filteredBookings.assignAll(fetchedBookings);
      }

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