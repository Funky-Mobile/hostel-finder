import 'dart:convert';
import 'dart:developer';

import 'package:hostel_finder/core/user/user_view_model.dart';

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
}