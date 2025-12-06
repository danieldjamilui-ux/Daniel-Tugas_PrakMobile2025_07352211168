import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final String? imageUrl; // nullable supaya bisa null atau kosong

  DetailScreen({
    required this.title,
    required this.description,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Berita'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              height: 250,
              width: double.infinity,
              child: (imageUrl != null && imageUrl!.isNotEmpty)
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // fallback ke asset jika gagal load
                        return Image.asset(
                          'assets/images/tree.jpg',
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      'assets/images/default_image.png',
                      fit: BoxFit.cover,
                    ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  SizedBox(height: 16),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
