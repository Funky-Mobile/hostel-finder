import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppUrls {

  static final String _baseUrl = '${dotenv.env['BASE_ENDPOINT_URL']}';

  static Uri get loginUrl => Uri.parse('$_baseUrl/auth/login');

  static Uri get signUpUrl => Uri.parse('$_baseUrl/students/new');

  static Uri get findAllRoomsUrl => Uri.parse('$_baseUrl/rooms');

  static Uri findUserByEmailUrl(String email) => Uri.parse('$_baseUrl/students/find?email=$email');

  static Uri requestMaintenanceUrl(String studentId) => Uri.parse('$_baseUrl/maintenance/$studentId/request');
  static Uri fetchUserMaintenanceRequestsUrl(String studentId) => Uri.parse('$_baseUrl/maintenance/$studentId');

}