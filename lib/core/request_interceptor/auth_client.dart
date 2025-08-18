import 'dart:async';
import 'package:http/http.dart' as http;

import '../cache/token_cache_service.dart';

/// A custom HTTP client that adds the JWT token to all requests.
class AuthClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = await TokenCacheService.getToken();

    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-type'] = 'application/json';
    }

    return _inner.send(request);
  }
}
