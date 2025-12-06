import 'package:flutter/material.dart';

class RecommendedWorkshopsPage extends StatelessWidget {
  const RecommendedWorkshopsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> workshops = [
      {
        'image': 'assets/images/Picture3.png',
        'name': 'Miss Zachary Will',
        'role': 'Beautician',
        'description': 'Occaecati aut nam beatae quo non deserunt consequatur.',
        'rating': 4.9,
      },
      {
        'image': 'assets/images/Picture3.png',
        'name': 'Miss Zachary Will',
        'role': 'Beautician',
        'description': 'Occaecati aut nam beatae quo non deserunt consequatur.',
        'rating': 4.9,
      },
      {
        'image': 'assets/images/Picture3.png',
        'name': 'Miss Zachary Will',
        'role': 'Beautician',
        'description': 'Occaecati aut nam beatae quo non deserunt consequatur.',
        'rating': 4.9,
      },
      {
        'image': 'assets/images/Picture3.png',
        'name': 'Miss Zachary Will',
        'role': 'Beautician',
        'description': 'Occaecati aut nam beatae quo non deserunt consequatur.',
        'rating': 4.9,
      },
    ];

    return SingleChildScrollView( // ✅ scroll agar tidak overflow
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Recommended Workshops",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "View All",
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Grid
            GridView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // biar scroll-nya dari SingleChildScrollView
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.62,
              ),
              itemCount: workshops.length,
              itemBuilder: (context, index) {
                final item = workshops[index];
                return _buildWorkshopCard(item);
              },
            ),
          ],
        ),
      ),
    );
  }

Widget _buildWorkshopCard(Map<String, dynamic> item) {
  return Card(
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    shadowColor: Colors.black26,
    child: Column(
      children: [
        // Gambar + Rating
        Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                item['image'],
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.blueAccent, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      item['rating'].toString(),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // Konten dan Tombol dalam Stack agar tombol tetap di bawah
        Expanded(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 60), // Sisakan ruang untuk tombol
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['name'],
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(item['role'],
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    Text(
                      item['description'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),

              // Tombol tetap di bawah
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: SizedBox(
                  height: 57.63, // Sesuai label pada gambar
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: const Text(
                      "Book Workshop",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}
