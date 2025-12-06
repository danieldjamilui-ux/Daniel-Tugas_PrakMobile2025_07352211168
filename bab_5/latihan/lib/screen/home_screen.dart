import 'package:flutter/material.dart';
import '../service/news_service.dart';
import '../service/auth_service.dart';
import 'detail_screen.dart';
import 'add_news_screen.dart';
import 'edit_profile_screen.dart';
import 'edit_news_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> _news = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final news = await NewsService.getNews();
      setState(() {
        _news = news;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      print('[HomeScreen] Load news error: $e');
    }
  }

  Future<void> _deleteNews(int id) async {
    final result = await NewsService.deleteNews(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'])),
    );
    if (result['success']) _loadNews();
  }

  void _showDeleteDialog(int id, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Berita'),
        content: Text('Yakin ingin menghapus "$title"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Batal')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteNews(id);
            },
            child: Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: $_error'),
                      SizedBox(height: 20),
                      ElevatedButton(
                          onPressed: _loadNews, child: Text('Coba Lagi')),
                    ],
                  ),
                )
              : _news.isEmpty
                  ? Center(child: Text('Tidak ada berita tersedia'))
                  : RefreshIndicator(
                      onRefresh: _loadNews,
                      child: ListView.builder(
  itemCount: _news.length,
  itemBuilder: (context, index) {
    final news = _news[index];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              title: news['title'] ?? '',
              description: news['description'] ?? '',
              imageUrl: news['image_url'],
            ),
          ),
        );
      },
      child: Card(
        elevation: 3,
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // GAMBAR (besar di atas)
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: news['image_url'] != null
                  ? Image.network(
                      news['image_url'],
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/tree.jpg',
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      'assets/images/tree.jpg',
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),

            // JUDUL & AUTHOR
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news['title'] ?? 'No Title',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '${news['author'] ?? 'unknown'} · ${news['created_at'] ?? ''}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),

            // DELETE BUTTON (seperti screenshot)
Align(
  alignment: Alignment.centerRight,
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      // Tombol Edit
      IconButton(
        icon: Icon(Icons.edit, color: Colors.blue),
        onPressed: () {
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => EditNewsScreen(news: news),
  ),
).then((value) {
  if (value == true) _loadNews(); // reload jika update sukses
});

        },
      ),

      // Tombol Hapus
      IconButton(
        icon: Icon(Icons.delete, color: Colors.red),
        onPressed: () => _showDeleteDialog(
          news['id'],
          news['title'] ?? '',
        ),
      ),
    ],
  ),
),


          ],
        ),
      ),
    );
  },
)

                    ),
      AddNewsScreen(onNewsAdded: _loadNews),
      EditProfileScreen(),
    ];

    return Scaffold(
appBar: AppBar(
  backgroundColor: Colors.white,
  elevation: 0,
  iconTheme: IconThemeData(color: Colors.black),

  // Ikon menu di kiri
  leading: IconButton(
    icon: Icon(Icons.menu),
    onPressed: () {},
  ),

  title: Row(
    children: [
      Text(
        "HMTI ",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      Text(
        "News",
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    ],
  ),

  actions: [
    IconButton(
      icon: Icon(Icons.logout, color: Colors.black),
      onPressed: () async {
        await AuthService.logout();
        Navigator.pushReplacementNamed(context, '/login');
      },
    ),
  ],
),

      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Tambah'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
