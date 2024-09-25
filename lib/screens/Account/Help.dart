import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Help"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Frequently Asked Questions",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "1. How do I track my order?",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "You can track your order in the Orders section of the app.",
            ),
            SizedBox(height: 10),
            Text(
              "2. How do I update my delivery address?",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Go to the Delivery Address section in your account settings.",
            ),
            SizedBox(height: 10),
            Text(
              "3. How can I contact support?",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "You can contact support by emailing support@example.com or calling +123456789.",
            ),
            // Add more help questions and answers here.
          ],
        ),
      ),
    );
  }
}
