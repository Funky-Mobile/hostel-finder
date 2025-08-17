import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppUrls {

  static final String _baseUrl = '${dotenv.env['BASE_ENDPOINT_URL']}';

  static Uri get loginUrl => Uri.parse('$_baseUrl/auth/login');

  static Uri get signUpUrl => Uri.parse('$_baseUrl/students/new');

}