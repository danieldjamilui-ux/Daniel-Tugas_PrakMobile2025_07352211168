import 'package:flutter/material.dart';

class FreelancerList extends StatelessWidget {
  const FreelancerList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> freelancers = [
      {
        'name': 'Billie Elish',
        'job': 'Beautician',
        'rating': 4.9,
        'image': 'assets/images/billi.jpeg'
      },
      {
        'name': 'Emma Watson',
        'job': 'Stylist',
        'rating': 4.8,
        'image': 'assets/images/model1.png'
      },
      {
        'name': 'Alex Doe',
        'job': 'Makeup Artist',
        'rating': 4.7,
        'image': 'assets/images/hoodie.jpg'
      },
      {
        'name': 'John Lee',
        'job': 'Hair Expert',
        'rating': 4.9,
        'image': 'assets/images/jam.jpg'
      },
    ];


    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: freelancers.length,
        itemBuilder: (context, index) {
          final freelancer = freelancers[index];

          return Container(
            width: 110,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(freelancer['image']!),
                  radius: 28,
                ),
                const SizedBox(height: 6),
                Text(
                  freelancer['name']!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  freelancer['job']!,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.star,
                      color: Color.fromARGB(255, 143, 7, 255),
                      size: 14,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      freelancer['rating'].toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
