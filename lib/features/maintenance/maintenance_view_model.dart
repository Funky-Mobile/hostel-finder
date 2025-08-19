import 'dart:convert';
import 'dart:developer';

import 'package:hostel_finder/core/cache/user_cache_service.dart';
import 'package:hostel_finder/core/user/user_view_model.dart';
import 'package:hostel_finder/features/maintenance/maintenance_model.dart';

import '../../core/app_urls/app_urls.dart';
import 'package:get/get.dart';
import '../../core/request_interceptor/auth_client.dart';

class MaintenanceViewModel {

  final UserViewModel _userViewModel = Get.find<UserViewModel>();

  // Error message
  final RxString errorMessage = ''.obs;

  /// Fetch user data by email
  Future<void> requestMaintenance(String roomId, String complaint) async {

    try {

      final client = AuthClient();
      final response = await client.post(
          AppUrls.requestMaintenanceUrl(_userViewModel.user.value!.id),
          body: jsonEncode(
            {
              "roomId": roomId,
              "description": complaint
            }
          )
      );

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body)['data'];


        log("THE USER DATA: ${response.body}");

      } else {
        errorMessage.value = 'Failed to fetch user: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    }
  }


  Future<List<MaintenanceModel>> fetchUserMaintenanceRequests() async {
    try {
      final user = await (UserCacheService.getUser());

      final client = AuthClient();
      final response = await client.get(
        AppUrls.fetchUserMaintenanceRequestsUrl(user!.id),
      );

      log("THE MAINTENANCE: ${response.statusCode}");

      if (response.statusCode == 200) {
        // Since your API returns a direct array, decode it directly
        final data = jsonDecode(response.body) as List<dynamic>;

        final result = data.map((result) => MaintenanceModel.fromJson(result)).toList();

        log('THE RESULT: ${result}');

        return result;

      } else {
        errorMessage.value = 'Failed to fetch user: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    }

    return [];
  }}