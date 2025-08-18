import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../user/user_model.dart';

/// Service to securely cache and retrieve the authentication token and user.
class TokenCacheService {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'authToken';
  static const _userKey = 'cachedUser';

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


  /// Clears both token and user (useful on logout)
  static Future<void> clearAll() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
  }
}
