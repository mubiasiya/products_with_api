// lib/core/services/preference_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  PreferenceService._();

  static const String _tokenKey = "auth_token";
  static const String _isLoggedInKey = "is_logged_in";
  static const String _emailKey = "user_email";

  static Future<void> saveLoginDetails({
    required String token,
    required String email,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_emailKey, email.trim().toLowerCase());
  }

  static Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<String?> getUserEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  static Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey)!;
  }

  static Future<void> clearAuthData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_emailKey);
    await prefs.setBool(_isLoggedInKey, false);
  }
}
