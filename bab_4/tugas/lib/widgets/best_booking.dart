import 'package:flutter/material.dart';

class BestBooking extends StatelessWidget {
  const BestBooking({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> bookings = [
      {
        'title': 'Deal Of The Day',
        'discount': 'Flat 60% OFF',
        'description':
            'Aliquid voluptas sed repellendus dignissimos culpa id dolorem molestiae itaque neque similique.',
        'time': '06 : 34 : 15',
        'image': 'assets/images/Picture3.png'
      },
      {
        'title': 'Miss Zachary Will',
        'role': 'Beautician',
        'rating': 4.9,
        'image': 'assets/images/Picture3.png'
      },
      {
        'title': 'Miss Zachary Will',
        'role': 'Beautician',
        'rating': 4.9,
        'image': 'assets/images/Picture3.png'
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Best Bookings",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "View All",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Booking cards list
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final item = bookings[index];
              if (index == 0) {
                // special deal style card
                return _buildDealCard(item);
              } else {
                // regular booking cards
                return _buildBookingCard(item);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDealCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'],
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['discount'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['description'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item['time'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                    ),
                    child: const Text(
                      "Shop Now",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ClipRRect(
            borderRadius:
                const BorderRadius.horizontal(right: Radius.circular(16)),
            child: Image.asset(
              item['image'],
              width: 110,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              item['image'],
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.black12,
                  backgroundImage: AssetImage('assets/images/user.png'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        item['role'],
                        style: const TextStyle(
                            color: Colors.blueAccent, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star,
                        color: Colors.blueAccent, size: 16),
                    const SizedBox(width: 4),
                    Text(item['rating'].toString()),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
