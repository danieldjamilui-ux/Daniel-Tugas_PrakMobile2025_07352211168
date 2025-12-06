import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class NewsService {
  static const String baseUrl = 'https://hppms-sabala.my.id/api';

static Future<List<Map<String, dynamic>>> getNews(
    {int page = 1, int perPage = 10}) async {
  try {
    final token = await AuthService.getToken();

    final headers = {
      'Accept': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http
        .get(
          Uri.parse('$baseUrl/news?page=$page&per_page=$perPage'),
          headers: headers,
        )
        .timeout(Duration(seconds: 15));

    print('📰 [NewsService] Response status: ${response.statusCode}');
    print('📰 [NewsService] Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Ambil list news dari response['data']['data']
      final newsList = data['data']?['data'] as List<dynamic>?;

      if (newsList != null) {
        return newsList
            .map<Map<String, dynamic>>((item) => (item as Map).cast<String, dynamic>())
            .toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load news: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ [NewsService] Error: $e');
    throw Exception('Failed to load news: $e');
  }
}


  // GET news by ID
  static Future<Map<String, dynamic>> getNewsById(int id) async {
    try {
      final token = await AuthService.getToken();

      final headers = {
        'Accept': 'application/json',
      };

      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http
          .get(
            Uri.parse('$baseUrl/news/$id'),
            headers: headers,
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is Map) {
          return data.cast<String, dynamic>();
        } else if (data['data'] is Map) {
          return (data['data'] as Map).cast<String, dynamic>();
        } else {
          throw Exception('Invalid response format');
        }
      } else if (response.statusCode == 404) {
        throw Exception('News not found');
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ [NewsService] Get by ID error: $e');
      rethrow;
    }
  }

  // CREATE news baru - SESUAI DOKUMENTASI API
  static Future<Map<String, dynamic>> createNews(
      String title, String description, String author, File imageFile) async {
    try {
      final token = await AuthService.getToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'Anda harus login terlebih dahulu'
        };
      }

      // Buat multipart request - endpoint: /news
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/news'));

      // Tambahkan headers
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // ✅ SESUAI DOKUMENTASI: Tambahkan fields yang required
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['author'] = author;

      // ✅ Tambahkan file gambar
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        filename: 'news_${DateTime.now().millisecondsSinceEpoch}.jpg',
      ));

      print('📤 [NewsService] Uploading news: $title');
      print('📤 [NewsService] Author: $author');
      print('📤 [NewsService] Image: ${imageFile.path}');

      // Kirim request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('📝 [NewsService] Create status: ${response.statusCode}');
      print('📝 [NewsService] Create body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {'success': true, 'message': 'Berita berhasil dibuat'};
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Gagal membuat berita'
        };
      }
    } catch (e) {
      print('❌ [NewsService] Create error: $e');
      return {'success': false, 'message': 'Kesalahan upload berita: $e'};
    }
  }

  // UPDATE news - SESUAI DOKUMENTASI API (JSON)
  static Future<Map<String, dynamic>> updateNews(
      int id, String title, String description, String author) async {
    try {
      final token = await AuthService.getToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'Anda harus login terlebih dahulu'
        };
      }

      // ✅ SESUAI DOKUMENTASI: PUT /news/{id} dengan JSON
      final response = await http
          .put(
            Uri.parse('$baseUrl/news/$id'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode({
              'title': title,
              'description': description,
              'author': author,
            }),
          )
          .timeout(Duration(seconds: 15));

      print('📝 [NewsService] Update status: ${response.statusCode}');
      print('📝 [NewsService] Update body: ${response.body}');

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Berita berhasil diupdate'};
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Gagal mengupdate berita'
        };
      }
    } catch (e) {
      print('❌ [NewsService] Update error: $e');
      return {'success': false, 'message': 'Kesalahan: $e'};
    }
  }

  // UPDATE news dengan gambar baru
  static Future<Map<String, dynamic>> updateNewsWithImage(int id, String title,
      String description, String author, File imageFile) async {
    try {
      final token = await AuthService.getToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'Anda harus login terlebih dahulu'
        };
      }

      // Untuk update dengan file, gunakan POST dengan _method=PUT
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/news/$id'));

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // Tambahkan fields dengan _method=PUT
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['author'] = author;
      request.fields['_method'] = 'PUT';

      // Tambahkan file gambar
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        filename: 'news_${DateTime.now().millisecondsSinceEpoch}.jpg',
      ));

      print('📤 [NewsService] Updating news with image: $title');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('📝 [NewsService] UpdateWithImage status: ${response.statusCode}');
      print('📝 [NewsService] UpdateWithImage body: ${response.body}');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Berita berhasil diupdate dengan gambar'
        };
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Gagal mengupdate berita'
        };
      }
    } catch (e) {
      print('❌ [NewsService] UpdateWithImage error: $e');
      return {'success': false, 'message': 'Kesalahan upload gambar: $e'};
    }
  }

  // DELETE news
  static Future<Map<String, dynamic>> deleteNews(int id) async {
    try {
      final token = await AuthService.getToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'Anda harus login terlebih dahulu'
        };
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/news/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Berita berhasil dihapus'};
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Gagal menghapus berita'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Kesalahan: $e'};
    }
  }

  // ✅ METHOD UTILITY: Cek apakah platform mendukung file upload
  static bool get supportsFileUpload {
    return !kIsWeb;
  }
}
