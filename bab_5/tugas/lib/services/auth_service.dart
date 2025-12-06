import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

// Base URL API (tanpa /register atau /login)
const String baseUrl = 'https://hppms-sabala.my.id/api';

class AuthService {
  /// Register user baru
  static Future<Map<String, dynamic>> registerUser({
    required String name,
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
  }) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'username': username,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'phone': phone,
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 201 && data['success'] == true) {
      return {
        'success': true,
        'message': data['message'] ?? 'Register success',
        'user': User.fromJson(data['data']['user']),
        'token': data['data']['token'],
      };
    } else {
      return {
        'success': false,
        'message': data['message'] ?? 'Register failed',
      };
    }
  }

  /// Login user
  static Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['success'] == true) {
      return {
        'success': true,
        'message': data['message'] ?? 'Login success',
        'user': User.fromJson(data['data']['user']),
        'token': data['data']['token'],
      };
    } else {
      return {
        'success': false,
        'message': data['message'] ?? 'Invalid credentials',
      };
    }
  }
    // Logout user
  static Future<Map<String, dynamic>> logoutUser({String? token}) async {
    final url = Uri.parse('$baseUrl/logout');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return {'success': true, 'message': 'Logout successful'};
    } else {
      final data = jsonDecode(response.body);
      return {'success': false, 'message': data['message'] ?? 'Logout failed'};
    }
  }  
}

