import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'https://hppms-sabala.my.id/api';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    print('✅ [AuthService] Token disimpan: $token');
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    print('✅ [AuthService] Token dihapus');
  }

  // ✅ PERBAIKAN: Register sesuai dokumentasi API
  static Future<Map<String, dynamic>> register(
    String name,
    String username,
    String email,
    String password,
    String confirmPassword,
    String phone,
  ) async {
    try {
      print('🚀 [AuthService] Register: $email');

      final response = await http
          .post(
            Uri.parse('$baseUrl/register'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode({
              'name': name,
              'username': username,
              'email': email,
              'password': password,
              'password_confirmation': confirmPassword,
              'phone': phone,
            }),
          )
          .timeout(Duration(seconds: 15));

      print('📨 [AuthService] Register status: ${response.statusCode}');
      print('📦 [AuthService] Register response: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);

        // Cari token di response
        final token =
            data['token'] ?? data['access_token'] ?? data['data']?['token'];

        if (token != null) {
          await saveToken(token);
          return {'success': true, 'message': 'Registrasi berhasil!'};
        } else {
          return {
            'success': true,
            'message': 'Registrasi berhasil, silakan login'
          };
        }
      } else {
        // Handle error
        try {
          final errorData = json.decode(response.body);
          final errorMessage = errorData['message'] ??
              errorData['errors']?.toString() ??
              'Registrasi gagal';

          return {'success': false, 'message': errorMessage};
        } catch (e) {
          return {'success': false, 'message': 'Registrasi gagal'};
        }
      }
    } catch (e) {
      print('💥 [AuthService] Register error: $e');
      if (e is TimeoutException) {
        return {'success': false, 'message': 'Timeout: Server tidak merespons'};
      }
      return {'success': false, 'message': 'Kesalahan koneksi: $e'};
    }
  }

  // Login method tetap sama
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      print('🚀 [AuthService] Login: $email');

      final response = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(Duration(seconds: 15));

      print('📨 [AuthService] Login status: ${response.statusCode}');
      print('📦 [AuthService] Login response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Cari token di response
        final token =
            data['token'] ?? data['access_token'] ?? data['data']?['token'];

        if (token != null) {
          await saveToken(token);
          return {'success': true, 'message': 'Login berhasil!'};
        } else {
          return {'success': false, 'message': 'Token tidak ditemukan'};
        }
      } else {
        // Handle error
        try {
          final errorData = json.decode(response.body);
          final errorMessage = errorData['message'] ??
              errorData['errors']?.toString() ??
              'Login gagal';

          return {'success': false, 'message': errorMessage};
        } catch (e) {
          return {'success': false, 'message': 'Login gagal'};
        }
      }
    } catch (e) {
      print('💥 [AuthService] Login error: $e');
      if (e is TimeoutException) {
        return {'success': false, 'message': 'Timeout: Server tidak merespons'};
      }
      return {'success': false, 'message': 'Kesalahan koneksi: $e'};
    }
  }

  static Future<void> logout() async {
    final token = await getToken();
    if (token != null) {
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/logout'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );
        print('📨 [AuthService] Logout status: ${response.statusCode}');
      } catch (e) {
        print('⚠️ [AuthService] Logout error: $e');
      }
    }
    await removeToken();
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}
