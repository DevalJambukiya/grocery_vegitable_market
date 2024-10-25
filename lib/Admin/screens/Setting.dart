import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_vegitable_market/screens/login.dart';

class SettingsPage extends StatelessWidget {
  final List<String> bannerImages = [
    'assets/banner/b1.jpg',
    'assets/banner/b2.jpeg',
    'assets/banner/b3.jpeg',
  ];

  final List<String> placeImages = [
    'assets/Logo/welcome.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Welcome Screen Settings'),
              const SizedBox(height: 10),
              _buildHorizontalImageList(placeImages, 200),
              const SizedBox(height: 16),
              _buildButton('Get Started', Colors.blue, () {
                print('Get Started clicked');
              }),
              const SizedBox(height: 30),
              _buildSectionTitle('Admin Settings'),
              const SizedBox(height: 10),
              Center(
                child: GestureDetector(
                  onTap: () => _showAdminDetails(context),
                  child: const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/Logo/welcome.jpg'),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _buildSectionTitle('Banner Settings'),
              const SizedBox(height: 10),
              _buildHorizontalImageList(bannerImages, 200),
              const SizedBox(height: 16),
              _buildBannerButtons(),
              const SizedBox(height: 30),
              _buildSectionTitle('Additional Settings'),
              _buildSettingOption('Notification Settings', Icons.notifications),
              _buildSettingOption('Privacy Policy', Icons.privacy_tip),
              _buildSettingOption('Help & Support', Icons.help_outline),
              const SizedBox(height: 30),
              _buildLogoutButton('Logout', () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.2),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildHorizontalImageList(List<String> images, double height) {
    return Container(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Container(
            width: 300,
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                images[index],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return Center(
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildBannerButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildButton('Add Banner', Colors.green, () {
          print('Add Banner clicked');
        }),
        _buildButton('Remove Banner', Colors.red, () {
          print('Remove Banner clicked');
        }),
      ],
    );
  }

  Widget _buildSettingOption(String title, IconData icon) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon, color: Colors.green),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      onTap: () {
        print('$title tapped');
      },
    );
  }

  Widget _buildLogoutButton(String text, VoidCallback onPressed) {
    return Center(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFff616f), Color(0xFFd83a56)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.logout, color: Colors.white),
          label: Text(text),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void _showAdminDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Admin Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Name: Admin User'),
              const Text('Email: admin@example.com'),
              const Text('Phone: +123 456 7890'),
              const SizedBox(height: 10),
              const Text('Update Details:'),
              const TextField(decoration: InputDecoration(labelText: 'Name')),
              const TextField(decoration: InputDecoration(labelText: 'Email')),
              const TextField(decoration: InputDecoration(labelText: 'Phone')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                print('Admin details updated');
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
