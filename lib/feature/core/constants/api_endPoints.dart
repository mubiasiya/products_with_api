import 'package:with_api/feature/core/constants/api_constants.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static const String register = "${ApiConfig.baseUrl}/users/";
  static const String login = "${ApiConfig.baseUrl}/auth/login";
  static const String isEmailAvailable = "${ApiConfig.baseUrl}/users/is-available";
  static const String users = "${ApiConfig.baseUrl}/users";
  static const String products = "${ApiConfig.baseUrl}/products";
  static const String categories = "${ApiConfig.baseUrl}/categories";
  static const String profile = "${ApiConfig.baseUrl}/auth/profile";
}
