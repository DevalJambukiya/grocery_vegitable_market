import 'package:flutter/material.dart';

// Main Application Entry Point
void main() {
  runApp(Account());
}

class Account extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AccountPage(), // Directly navigate to the Account Page
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto', // You can include a custom font if you want
      ),
      debugShowCheckedModeBanner: false, // Remove the debug banner
    );
  }
}

// Account Page
class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 243, 248, 244),
              ], // Define the gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // User Info Section inside a Card with Shadow
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(
                          'https://example.com/avatar.jpg'), // Replace with actual image URL
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "TCC", // User name
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "tcc@gmail.com", // Email address
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(),
          // List of Account Options inside a Card
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                buildListTile(Icons.shopping_bag, "Orders"),
                buildListTile(Icons.person, "My Details"),
                buildListTile(Icons.location_on, "Delivery Address"),
                buildListTile(Icons.credit_card, "Payment Methods"),
                buildListTile(Icons.card_giftcard, "Promo Code"),
                buildListTile(Icons.notifications, "Notifications"),
                buildListTile(Icons.help, "Help"),
                buildListTile(Icons.info, "About"),
              ],
            ),
          ),
          // Logout Button with Custom Style
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: OutlinedButton.icon(
              onPressed: () {
                // Handle logout action
              },
              icon: Icon(Icons.logout),
              label: Text("Log Out"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                side: BorderSide(color: Colors.green),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ListTile buildListTile(IconData icon, String title) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      leading: Icon(icon, size: 28, color: Colors.teal),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
      onTap: () {
        // Handle tap
      },
    );
  }
}
