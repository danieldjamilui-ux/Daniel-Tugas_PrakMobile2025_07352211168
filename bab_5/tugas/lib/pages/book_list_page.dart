import 'dart:io';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../models/book.dart';
import '../services/book_services.dart';
import 'book_detail_page.dart';
import '../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  late Future<List<Book>> books;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    books = fetchBooks();
  }

  void _refreshBooks() {
    setState(() {
      books = fetchBooks();
    });
  }

  Future<void> _pickImageDesktop() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedImage = File(result.files.single.path!);
      });
    }
  }

  void _showAddBookDialog() {
    _titleController.clear();
    _authorController.clear();
    _descriptionController.clear();
    _selectedImage = null;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text("Tambah Buku Baru"),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: "Judul"),
                    validator: (value) =>
                        value == null || value.isEmpty ? "Judul wajib diisi" : null,
                  ),
                  TextFormField(
                    controller: _authorController,
                    decoration: const InputDecoration(labelText: "Penulis"),
                    validator: (value) =>
                        value == null || value.isEmpty ? "Penulis wajib diisi" : null,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: "Deskripsi"),
                    maxLines: 3,
                    validator: (value) => value == null || value.isEmpty
                        ? "Deskripsi wajib diisi"
                        : null,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (kIsWeb ||
                              Platform.isWindows ||
                              Platform.isLinux ||
                              Platform.isMacOS) {
                            await _pickImageDesktop();
                          } else {
                            final picked = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            if (picked != null) {
                              setStateDialog(() {
                                _selectedImage = File(picked.path);
                              });
                            }
                          }
                        },
                        child: const Text("Pilih Gambar"),
                      ),
                      const SizedBox(width: 10),
                      _selectedImage != null
                          ? const Text("Gambar dipilih")
                          : const Text("Belum ada gambar"),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    await addBookWithImage(
                      _titleController.text,
                      _authorController.text,
                      _descriptionController.text,
                      _selectedImage,
                    );
                    Navigator.pop(context);
                    _refreshBooks();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Buku berhasil ditambahkan")),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: $e")),
                    );
                  }
                }
              },
              child: const Text("Tambah"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Buku"),
        backgroundColor: const Color.fromARGB(255, 69, 123, 185),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final token = prefs.getString('token');

              if (token != null) {
                final result = await AuthService.logoutUser(token: token);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result['message'] ?? 'Logout gagal')),
                );

                if (result['success']) {
                  await prefs.remove('token');
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                }
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddBookDialog,
          ),
        ],
      ),
      body: FutureBuilder<List<Book>>(
        future: books,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "Tidak ada buku tersedia",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            );
          } else {
            final list = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final book = list[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    title: Text(
                      book.title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          book.author,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          book.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookDetailScreen(bookId: book.id),
                        ),
                      ).then((_) => _refreshBooks());
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
