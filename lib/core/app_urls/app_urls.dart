import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppUrls {

  static final String _baseUrl = '${dotenv.env['BASE_ENDPOINT_URL']}';

  static Uri get loginUrl =>
      Uri.parse('$_baseUrl/auth/login');

  static Uri get signUpUrl =>
      Uri.parse('$_baseUrl/students/new');

  static Uri get findAllRoomsUrl =>
      Uri.parse('$_baseUrl/rooms');

  static Uri findUserByEmailUrl(String email) =>
      Uri.parse('$_baseUrl/students/find?email=$email');

  static Uri requestMaintenanceUrl(String studentId) =>
      Uri.parse('$_baseUrl/maintenance/$studentId/request');
  static Uri fetchUserMaintenanceRequestsUrl(String studentId) =>
      Uri.parse('$_baseUrl/maintenance/$studentId');

  static Uri get createBookingUrl =>
      Uri.parse('$_baseUrl/bookings');
  static Uri findStudentBookingsUrl(String studentId) =>
      Uri.parse('$_baseUrl/bookings/student/$studentId');

  static Uri get roommateRequestsUrl =>
      Uri.parse('$_baseUrl/roommate-requests');

  static Uri roommateRequestsByStudentUrl(String studentId) =>
      Uri.parse('$_baseUrl/roommate-requests/created/$studentId');

  static Uri joinedRequestsByStudentUrl(String studentId) =>
      Uri.parse('$_baseUrl/roommate-requests/joined/$studentId');

  static Uri joinRoommateRequestUrl(String requestId) =>
      Uri.parse('$_baseUrl/roommate-requests/$requestId/join');

  static Uri cancelRoommateRequestUrl(String requestId, String studentId) =>
      Uri.parse('$_baseUrl/roommate-requests/$requestId?studentId=$studentId');

  static Uri roommateRequestsByRoomIdUrl(String roomId) =>
      Uri.parse('$_baseUrl/roommate-requests/room/$roomId');
}