import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const ListTile(
              leading: Icon(Icons.person, color: Colors.deepPurple),
              title: Text(
                'Profile',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const ListTile(
              leading: Icon(Icons.notifications, color: Colors.deepPurple),
              title: Text(
                'Notifications',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const ListTile(
              leading: Icon(Icons.info, color: Colors.deepPurple),
              title: Text(
                'About App',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}