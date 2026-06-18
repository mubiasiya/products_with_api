import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:with_api/feature/core/constants/api_endPoints.dart';

class AuthRepository {
  Future<String> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(ApiEndpoints.register);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'avatar': "https://picsum.photos/640/480",
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> body = jsonDecode(response.body);

      if (body.containsKey('errors')) {
        final errorMessage = body['errors'][0]['message'];
        throw Exception(errorMessage ?? 'Registration failed');
      }

      // print(response);

      return body['id'].toString();
    } else {
      throw Exception(
        'Server communication error: HTTP ${response.statusCode}',
      );
    }
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(ApiEndpoints.login);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> body = jsonDecode(response.body);

      if (body.containsKey('errors')) {
        final errorMessage = body['errors'][0]['message'];
        throw Exception(errorMessage ?? 'Invalid email or password');
      }

      final accessToken = body['access_token'].toString();
      return fetchUserId(accessToken);
    } else if (response.statusCode == 401) {
      throw Exception('Invalid email or password');
    } else {
      throw Exception(
        'Server communication error: HTTP ${response.statusCode}',
      );
    }
  }

  Future<bool> checkIfUserExists(String email) async {
    final response = await http.get(
      Uri.parse(ApiEndpoints.users),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> users = jsonDecode(response.body);

      final bool emailTaken = users.any(
        (user) =>
            user['email'].toString().toLowerCase().trim() ==
            email.toLowerCase().trim(),
      );

      return emailTaken;
    } else {
      throw Exception('Server lookup error: HTTP ${response.statusCode}');
    }
  }

  Future<String> fetchUserId(String accessToken) async {
    final url = Uri.parse(ApiEndpoints.profile);

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      return body['id'].toString();
    } else {
      throw Exception('Failed to fetch profile ID');
    }
  }
}
