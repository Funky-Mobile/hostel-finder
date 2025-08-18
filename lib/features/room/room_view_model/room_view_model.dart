import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/app_urls/app_urls.dart';
import '../../../core/request_interceptor/auth_client.dart';
import '../dao/room_dao.dart';

class RoomViewModel extends GetxController {
  var rooms = <RoomDao>[].obs;
  var filteredRooms = <RoomDao>[].obs;
  var searchQuery = ''.obs;
  var selectedRoomType = 'All'.obs;
  var selectedGender = 'All'.obs;
  var priceRange = RangeValues(0, 1000).obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRooms();
    // Listen to search query changes
    debounce(searchQuery, (_) => filterRooms(), time: Duration(milliseconds: 300));
    ever(selectedRoomType, (_) => filterRooms());
    ever(selectedGender, (_) => filterRooms());
    ever(priceRange, (_) => filterRooms());
  }

  /// Fetches all rooms from backend
  Future<List<RoomDao>> fetchRooms() async {
    try {
      isLoading.value = true;
      final client = AuthClient();
      final response = await client.get(AppUrls.findAllRoomsUrl);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body)['data'];
        final fetchedRooms = RoomDao.listFromJson(jsonData);
        rooms.assignAll(fetchedRooms);
        filteredRooms.assignAll(fetchedRooms);
        return fetchedRooms;
      } else {
        log('Failed to load rooms. Status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      log('Error: $e');
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  /// Filters rooms based on search criteria
  void filterRooms() {
    var filtered = rooms.where((room) {
      // Search query filter
      bool matchesSearch = searchQuery.value.isEmpty ||
          room.number.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          room.type.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          room.description.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          room.amenities.any((amenity) =>
              amenity.toLowerCase().contains(searchQuery.value.toLowerCase()));

      // Room type filter
      bool matchesType = selectedRoomType.value == 'All' ||
          room.type == selectedRoomType.value;

      // Gender filter
      bool matchesGender = selectedGender.value == 'All' ||
          room.gender == selectedGender.value;

      // Price range filter
      bool matchesPrice = room.price >= priceRange.value.start &&
          room.price <= priceRange.value.end;

      return matchesSearch && matchesType && matchesGender && matchesPrice;
    }).toList();

    filteredRooms.assignAll(filtered);
  }

  /// Updates search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  /// Clears all filters
  void clearFilters() {
    searchQuery.value = '';
    selectedRoomType.value = 'All';
    selectedGender.value = 'All';
    priceRange.value = RangeValues(0, 1000);
  }

  /// Gets unique room types
  List<String> get roomTypes {
    var types = rooms.map((room) => room.type).toSet().toList();
    types.insert(0, 'All');
    return types;
  }

  /// Gets unique genders
  List<String> get genders {
    var genderList = rooms.map((room) => room.gender).toSet().toList();
    genderList.insert(0, 'All');
    return genderList;
  }
}