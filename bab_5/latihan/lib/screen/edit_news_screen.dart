// edit_news_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../service/news_service.dart';

class EditNewsScreen extends StatefulWidget {
  final Map<String, dynamic> news; // data berita yang mau diedit

  const EditNewsScreen({super.key, required this.news});

  @override
  _EditNewsScreenState createState() => _EditNewsScreenState();
}

class _EditNewsScreenState extends State<EditNewsScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _authorController;

  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.news['title'] ?? '');
    _descriptionController =
        TextEditingController(text: widget.news['description'] ?? '');
    _authorController =
        TextEditingController(text: widget.news['author'] ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = picked;
      });
    }
  }

  Future<void> _updateNews() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    Map<String, dynamic> result;

    // Jika gambar baru dipilih
    if (_pickedImage != null) {
      result = await NewsService.updateNewsWithImage(
        widget.news['id'],
        _titleController.text,
        _descriptionController.text,
        _authorController.text,
        File(_pickedImage!.path),
      );
    } else {
      result = await NewsService.updateNews(
        widget.news['id'],
        _titleController.text,
        _descriptionController.text,
        _authorController.text,
      );
    }

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message']),
        backgroundColor: result['success'] ? Colors.green : Colors.red,
      ),
    );

    if (result['success']) {
      Navigator.pop(context, true); // kembali ke HomeScreen & reload
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.news['image_url'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Berita'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Deskripsi wajib diisi' : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Penulis'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Penulis wajib diisi' : null,
              ),
              const SizedBox(height: 20),

              // PREVIEW GAMBAR
// PREVIEW GAMBAR
GestureDetector(
  onTap: _pickImage,
  child: _pickedImage != null
      ? Image.file(File(_pickedImage!.path), height: 150, width: double.infinity, fit: BoxFit.cover)
      : (imageUrl != null && imageUrl.isNotEmpty)
          ? Image.network(
              imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Jika gagal load dari URL, pakai gambar default dari assets
                return Image.asset(
                  'assets/images/tree.jpg', 
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                );
              },
            )
          : Image.asset(
              'assets/images/tree.jpg', 
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
),


              const SizedBox(height: 20),

              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _updateNews,
                      child: const Text('Update Berita'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
