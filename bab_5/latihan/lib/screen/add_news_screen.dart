import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../service/news_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AddNewsScreen extends StatefulWidget {
  final VoidCallback onNewsAdded;

  const AddNewsScreen({Key? key, required this.onNewsAdded}) : super(key: key);

  @override
  _AddNewsScreenState createState() => _AddNewsScreenState();
}

class _AddNewsScreenState extends State<AddNewsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _authorController = TextEditingController();

  File? _imageFile;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload gambar hanya tersedia di aplikasi mobile')),
      );
      return;
    }

    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );

    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<void> _submitNews() async {
    if (!_formKey.currentState!.validate()) return;

    if (!kIsWeb && _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gambar harus dipilih')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await NewsService.createNews(
        _titleController.text,
        _descriptionController.text,
        _authorController.text,
        _imageFile!,
      );

      setState(() => _isLoading = false);

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );

        _clearForm();
        widget.onNewsAdded();

        // Hanya pop jika ada navigator bisa kembali
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    _authorController.clear();
    setState(() {
      _imageFile = null;
    });
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_photo_alternate, size: 50, color: Colors.grey),
        SizedBox(height: 8),
        Text(
          kIsWeb ? 'Hanya tersedia di mobile' : 'Tap untuk pilih gambar',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Berita Baru'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _imageFile != null
                      ? Image.file(
                          _imageFile!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                        )
                      : _buildPlaceholder(),
                ),
              ),
              SizedBox(height: 8),
              Text(
                kIsWeb
                    ? 'Upload gambar hanya tersedia di aplikasi mobile'
                    : 'Tap untuk memilih gambar dari galeri',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Judul Berita *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Judul harus diisi' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _authorController,
                decoration: InputDecoration(
                  labelText: 'Penulis *',
                  border: OutlineInputBorder(),
                  hintText: 'Nama penulis berita',
                ),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Penulis harus diisi' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 10,
                decoration: InputDecoration(
                  labelText: 'Deskripsi Berita *',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                  hintText: 'Tulis deskripsi berita disini...',
                ),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Deskripsi harus diisi' : null,
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_isLoading || kIsWeb) ? null : _submitNews,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(kIsWeb ? 'Fitur hanya untuk Mobile' : 'Tambah Berita'),
                ),
              ),
              if (kIsWeb) ...[
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.orange),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Fitur upload gambar hanya tersedia di aplikasi mobile.',
                          style: TextStyle(color: Colors.orange[800]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _authorController.dispose();
    super.dispose();
  }
}
