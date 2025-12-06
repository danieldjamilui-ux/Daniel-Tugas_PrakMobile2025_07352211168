import 'package:flutter/material.dart';
import '../services/book_services.dart';
import '../models/book.dart';

class BookDetailScreen extends StatefulWidget {
  final int bookId;

  const BookDetailScreen({required this.bookId, Key? key}) : super(key: key);

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  late Future<Book?> book;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    book = fetchBookById(widget.bookId);
    book.then((b) {
      if (b != null) {
        _titleController.text = b.title;
        _authorController.text = b.author;
        _descriptionController.text = b.description;
      }
    });
  }

  void _updateBook() async {
    if (_formKey.currentState!.validate()) {
      try {
        await updateBookMultipart(
          id: widget.bookId,
          title: _titleController.text,
          content: _descriptionController.text,
          author: _authorController.text,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Buku berhasil diperbarui')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal update: $e')),
        );
      }
    }
  }

  void _deleteBook() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Buku'),
        content: const Text('Apakah Anda yakin ingin menghapus buku ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await deleteBook(widget.bookId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Buku berhasil dihapus')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Buku'),
        centerTitle: true,
        backgroundColor: Colors.white, // warna terang supaya ikon kontras
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), 
          onPressed: () => Navigator.pop(context),
          tooltip: 'Kembali',
        ),
        iconTheme: const IconThemeData(color: Colors.black), 
      ),
      body: FutureBuilder<Book?>(
        future: book,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Buku tidak ditemukan'));
          } else {
            final currentBook = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    if (currentBook.image != null && currentBook.image!.isNotEmpty)
                      Image.network(
                        currentBook.image!, // sudah lengkap dari model
                        height: 200,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/no-image.jpg',
                            height: 200,
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    else
                      Image.asset(
                        'assets/no-image.jpg',
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Judul',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Judul wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _authorController,
                      decoration: const InputDecoration(
                        labelText: 'Penulis',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Penulis wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Deskripsi',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 5,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Deskripsi wajib diisi' : null,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _updateBook,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade50,
                          ),
                          child: const Text(
                            'Update',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _deleteBook,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Hapus'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
