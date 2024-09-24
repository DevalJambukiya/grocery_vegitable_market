import 'package:flutter/material.dart';

// Main Application Entry Point
void main() {
  runApp(Account());
}

class Account extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(), // Main Page with navigation
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto', // You can include a custom font if you want
      ),
    );
  }
}

// Main Page with Bottom Navigation Bar
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  // List of Pages
  final List<Widget> _pages = [
    AccountPage(), // Account Page
    CartPage(), // Cart Page
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the current index
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Account",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
        ],
      ),
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
              colors: [Colors.green, Colors.teal], // Green gradient background
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
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

// Cart Page Placeholder (Add your existing CartPage code here)
class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Cart Page")); // Placeholder for CartPage
  }
}
