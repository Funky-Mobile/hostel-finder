import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../user/user_model.dart';

/// Service to securely cache and retrieve the authentication token and user.
class UserCacheService {
  static const _storage = FlutterSecureStorage();
  static const _userKey = 'cachedUser';

  /// Saves the user to secure storage.
  static Future<void> saveUser(User user) async {
    final userJson = jsonEncode(user.toJson());
    await _storage.write(key: _userKey, value: userJson);
  }

  /// Retrieves the cached user.
  static Future<User?> getUser() async {
    final userJson = await _storage.read(key: _userKey);
    if (userJson == null) return null;
    return User.fromJson(jsonDecode(userJson));
  }

  /// Clears the cached user.
  static Future<void> clearUser() async {
    await _storage.delete(key: _userKey);
  }

  /// Clears both token and user (useful on logout)
  static Future<void> clearAll() async {
    await _storage.delete(key: _userKey);
  }
}
