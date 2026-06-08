import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:with_api/feature/core/constants/api_constants.dart';

class AuthRepository {
  Future<String> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    const String mutation = r'''
      mutation AddUser($name: String!, $email: String!, $password: String!, $avatar: String!) {
        addUser(
          data: {
            name: $name
            email: $email
            password: $password
            avatar: $avatar
          }
        ) {
          id
          name
        }
      }
    ''';

    final response = await http.post(
      Uri.parse(ApiConstant.baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'query': mutation,
        'variables': {
          'name': name,
          'email': email,
          'password': password,
          'avatar': "https://picsum.photos/640/480",
        },
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);

      if (body.containsKey('errors')) {
        final errorMessage = body['errors'][0]['message'];
        throw Exception(errorMessage ?? 'Registration failed');
      }

      final userData = body['data']['addUser'];
      return userData['id'].toString();
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
    const String loginMutation = r'''
      mutation Login($email: String!, $password: String!) {
        login(email: $email, password: $password) {
          access_token
          refresh_token
        }
      }
    ''';

    final response = await http.post(
      Uri.parse(ApiConstant.baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'query': loginMutation,
        'variables': {'email': email, 'password': password},
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);

      if (body.containsKey('errors')) {
        final errorMessage = body['errors'][0]['message'];
        throw Exception(errorMessage ?? 'Invalid email or password');
      }

      final loginData = body['data']['login'];
      return loginData['access_token'].toString();
    } else {
      throw Exception(
        'Server communication error: HTTP ${response.statusCode}',
      );
    }
  }

  Future<bool> checkIfUserExists(String email) async {
    const String query = r'''
      query GetUsers {
        users {
          email
        }
      }
    ''';

    final response = await http.post(
      Uri.parse(ApiConstant.baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'query': query}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);

      if (body.containsKey('errors')) {
        throw Exception(
          body['errors'][0]['message'] ?? 'Failed to verify user records',
        );
      }

      final List users = body['data']['users'] ?? [];

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
}
