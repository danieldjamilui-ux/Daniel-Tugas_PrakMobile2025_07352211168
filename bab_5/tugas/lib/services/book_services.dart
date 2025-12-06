import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';
import 'dart:io';

/// Base URL API untuk posts (bukan root API)
const String baseUrl = 'https://hmti-news.hppms-sabala.my.id/api/posts';

/// Ambil semua postingan / buku
Future<List<Book>> fetchBooks() async {
  final response = await http.get(Uri.parse(baseUrl));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    if (data.isEmpty) {
      print("Tidak ada buku tersedia");
      return [];
    }
    return data.map((json) => Book.fromJson(json)).toList();
  } else {
    throw Exception('Gagal mengambil data buku (${response.statusCode})');
  }
}

/// Ambil detail postingan berdasarkan ID
Future<Book?> fetchBookById(int id) async {
  final response = await http.get(Uri.parse('$baseUrl/$id'));

  if (response.statusCode == 200) {
    return Book.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 404) {
    print("Buku tidak ditemukan");
    return null;
  } else {
    throw Exception('Gagal mengambil detail buku (${response.statusCode})');
  }
}

/// Tambah postingan baru (dengan/atau tanpa gambar)
Future<void> addBookWithImage(
    String title, String author, String content, File? image) async {
  final uri = Uri.parse(baseUrl);
  final request = http.MultipartRequest('POST', uri);

  request.fields['title'] = title;
  request.fields['author'] = author;
  request.fields['content'] = content;

  if (image != null) {
    request.files.add(await http.MultipartFile.fromPath('image', image.path));
  }

  final response = await request.send();

  if (response.statusCode == 201 || response.statusCode == 200) {
    print("Buku berhasil ditambahkan");
  } else {
    print("Gagal menambahkan buku (status: ${response.statusCode})");
  }
}

/// Update postingan berdasarkan ID (dengan/atau tanpa gambar baru)
Future<void> updateBook(int id, String title, String author, String content,
    [File? image]) async {
  final uri = Uri.parse('$baseUrl/$id');
  final request = http.MultipartRequest('POST', uri);
  request.fields['_method'] = 'PUT';
  

  request.fields['title'] = title;
  request.fields['author'] = author;
  request.fields['content'] = content;

  if (image != null) {
    request.files.add(await http.MultipartFile.fromPath('image', image.path));
  }

  final response = await request.send();

  if (response.statusCode == 200) {
    print("Buku berhasil diperbarui");
  } else if (response.statusCode == 404) {
    print("Buku tidak ditemukan");
  } else {
    print("Gagal memperbarui buku (status: ${response.statusCode})");
  }
}

/// Hapus postingan berdasarkan ID
Future<void> deleteBook(int id) async {
  final response = await http.delete(Uri.parse('$baseUrl/$id'));

  if (response.statusCode == 200) {
    print("Buku berhasil dihapus");
  } else if (response.statusCode == 404) {
    print("Buku tidak ditemukan");
  } else {
    print("Gagal menghapus buku (status: ${response.statusCode})");
  }
}

/// Alias untuk kompatibilitas dengan BookDetailScreen
Future<void> updateBookMultipart({
  required int id,
  required String title,
  required String content,
  required String author,
  File? image,
}) async {
  await updateBook(id, title, author, content, image);
}
