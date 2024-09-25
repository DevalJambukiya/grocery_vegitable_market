import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "About This App",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "This app is designed to provide you with a seamless shopping experience. "
              "You can browse products, place orders, and track them in real-time.",
            ),
            SizedBox(height: 20),
            Text(
              "Version",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("1.0.0"), // Replace with the actual app version.
            SizedBox(height: 20),
            Text(
              "Developed by",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("TCC Development Team"),
            SizedBox(height: 20),
            Text(
              "Contact Us",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "For support, contact us at support@example.com or call +123456789.",
            ),
          ],
        ),
      ),
    );
  }
}
