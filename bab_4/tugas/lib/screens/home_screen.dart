import 'package:flutter/material.dart';
import '../widgets/search_bar.dart';
import '../widgets/deal_section.dart';
import '../widgets/section_title.dart';
import '../widgets/freelancer_list.dart';
import '../widgets/service_list.dart';
import '../widgets/best_booking.dart';
import '../widgets/recommended_workshops.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // ✅ Preload semua gambar agar tidak lag di awal (dijalankan setelah frame pertama siap)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final images = [
        'assets/images/airpods.jpg',
        'assets/images/billi.jpeg',
        'assets/images/hoodie.jpg',
        'assets/images/Picture3.png',
        'assets/images/model1.png',
        'assets/images/jam.jpg',
      ];

      for (final path in images) {
        precacheImage(AssetImage(path), context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("E-Commerce"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          const Icon(Icons.notifications, size: 24),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.shopping_cart, size: 24),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),

      // ✅ SingleChildScrollView agar bisa di-scroll, dan hapus `const` di list parent
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SearchBarWidget(),
            const DealSection(),
            const SectionTitle(title: "Top Rated Freelancers"),
            const FreelancerList(),
            const SectionTitle(title: "Top Services"),
            const ServiceList(),
            const SectionTitle(title: "Best Booking"),
            const BestBooking(),
            const SectionTitle(title: "Recommended Workshops"),
            RecommendedWorkshopsPage(),
          ],
        ),
      ),
    );
  }
}
