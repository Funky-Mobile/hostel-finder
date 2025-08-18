import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service to securely cache and retrieve the authentication token.
class TokenCacheService {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'authToken';

  /// Saves the token to secure storage.
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Retrieves the cached token.
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Clears the cached token.
  static Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
