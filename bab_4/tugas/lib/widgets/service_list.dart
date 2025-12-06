import 'package:flutter/material.dart';

class ServiceList extends StatelessWidget {
  const ServiceList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> services = [
      {
        'title': 'Manicure',
        'subtitle': 'Beautician',
        'image': 'assets/images/Picture3.png'
      },
      {
        'title': 'Makeup',
        'subtitle': 'Beautician',
        'image': 'assets/images/Picture3.png'
      },
      {
        'title': 'Spa Treatment',
        'subtitle': 'Beautician',
        'image': 'assets/images/Picture3.png'
      },
    ];

    return SizedBox(
      height: 240, // ✅ tambahkan tinggi lebih besar agar tidak overflow
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: services.length,
        padding: const EdgeInsets.only(left: 16),
        itemBuilder: (context, index) {
          final service = services[index];
          return Container(
            width: 260,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar bagian atas
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(
                    service['image'],
                    height: 120, // ✅ sedikit lebih tinggi biar proporsional
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                // Konten teks dan tombol
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          service['subtitle'],
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurpleAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8),
                            ),
                            child: const Text(
                              "Book Now",
                              style: TextStyle(
                                  fontSize: 12, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
