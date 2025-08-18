import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:hostel_finder/core/app_urls/app_urls.dart';
import 'package:hostel_finder/core/cache/user_cache_service.dart';
import 'package:hostel_finder/core/user/user_model.dart';

import '../request_interceptor/auth_client.dart';


class UserViewModel extends GetxController {
  // Observable user
  final Rxn<User> user = Rxn<User>();

  // Loading state
  final RxBool isLoading = false.obs;

  // Error message
  final RxString errorMessage = ''.obs;

  /// Fetch user data by email
  Future<void> fetchUserByEmail(String email) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {

      final client = AuthClient();

      final response = await client.get(AppUrls.findUserByEmailUrl(email));

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body)['data'];
        final fetchedUser = User.fromJson(data);

        // Save user to cache
        await UserCacheService.saveUser(fetchedUser);

        // Update observable
        user.value = fetchedUser;

        log("THE USER DATA: ${user.value}");

      } else {
        errorMessage.value = 'Failed to fetch user: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Load user from cache if available
  Future<void> loadUserFromCache() async {
    final cachedUser = await UserCacheService.getUser();
    if (cachedUser != null) {
      user.value = cachedUser;
    }
  }
}
