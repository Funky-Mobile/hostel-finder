import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hostel_finder/core/cache/user_cache_service.dart';
import 'package:hostel_finder/core/user/user_model.dart';
import 'package:hostel_finder/features/maintenance/maintenance_model.dart';

import '../../core/app_urls/app_urls.dart';
import 'package:get/get.dart';
import '../../core/request_interceptor/auth_client.dart';

class MaintenanceViewModel {

  // Error message
  final RxString errorMessage = ''.obs;

  /// Fetch user data by email
  Future<void> requestMaintenance(BuildContext context, String roomId, String complaint) async {

    try {

      User? user = await UserCacheService.getUser();

      final client = AuthClient();
      final response = await client.post(
          AppUrls.requestMaintenanceUrl(user!.id),
          body: jsonEncode(
            {
              "roomId": roomId,
              "description": complaint
            }
          )
      );

      if (response.statusCode == 200) {

        if(context.mounted) {
            Navigator.pop(context);
            Navigator.pop(context);
            Get.snackbar('Success', 'Maintenance request submitted');
        }

      } else {
        errorMessage.value = 'Failed to send request: ${response.statusCode}';
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

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body) as List<dynamic>;
        final result = data.map((result) => MaintenanceModel.fromJson(result)).toList();

        return result;

      } else {
        errorMessage.value = 'Failed to fetch user: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    }

    return [];
  }}