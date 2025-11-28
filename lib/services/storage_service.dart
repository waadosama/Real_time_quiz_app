import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_app/models/user_model.dart';

class StorageService {
  static const String _userKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  Future<void> saveUser(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await _prefs.setString(_userKey, userJson);
      await _prefs.setBool(_isLoggedInKey, true);
    } catch (e) {
      throw Exception('Failed to save user: $e');
    }
  }

  UserModel? getUser() {
    try {
      final userJson = _prefs.getString(_userKey);
      if (userJson == null) return null;
      final decoded = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(decoded);
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Clear user data (logout)
  Future<void> clearUser() async {
    try {
      await _prefs.remove(_userKey);
      await _prefs.remove(_isLoggedInKey);
    } catch (e) {
      throw Exception('Failed to clear user: $e');
    }
  }

  // Save auth token
  Future<void> saveToken(String token) async {
    try {
      final user = getUser();
      if (user != null) {
        final updatedUser = UserModel(
          username: user.username,
          email: user.email,
          token: token,
          loginTime: user.loginTime,
        );
        await saveUser(updatedUser);
      }
    } catch (e) {
      throw Exception('Failed to save token: $e');
    }
  }

  // Get auth token
  String? getToken() {
    return getUser()?.token;
  }
}
