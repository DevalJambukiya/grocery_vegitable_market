import 'package:flutter/material.dart';
import 'package:grocery_vegitable_market/screens/Account/About.dart';
import 'package:grocery_vegitable_market/screens/Account/Help.dart';
import 'package:grocery_vegitable_market/screens/Account/delivery_add.dart';
import 'package:grocery_vegitable_market/screens/Account/order.dart';
import 'package:grocery_vegitable_market/screens/Account/payment.dart';
import 'package:grocery_vegitable_market/screens/Account/profile.dart';

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
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 243, 248, 244),
              ], // Define the gradient colors
              begin: Alignment.center,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
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
                        backgroundImage: AssetImage(
                            'assets/Logo/welcome.jpg'), // Replace with actual asset path
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
            ListView(
              shrinkWrap:
                  true, // Ensures ListView takes up only as much space as needed
              physics:
                  NeverScrollableScrollPhysics(), // Disable ListView's own scrolling
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                buildListTile(Icons.shopping_bag, "Orders", context),
                buildListTile(Icons.person, "My Details", context),
                buildListTile(Icons.location_on, "Delivery Address", context),
                buildListTile(Icons.credit_card, "Payment Methods", context),
                buildListTile(Icons.card_giftcard, "Promo Code", context),
                buildListTile(Icons.notifications, "Notifications", context),
                buildListTile(Icons.help, "Help", context),
                buildListTile(Icons.info, "About", context),
              ],
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
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
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
      ),
    );
  }

  ListTile buildListTile(IconData icon, String title, BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      leading: Icon(icon, size: 28, color: Colors.teal),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
      onTap: () {
        // Handle tap and navigate to the appropriate page
        if (title == "Orders") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OrdersPage()),
          );
        } else if (title == "My Details") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyDetailsPage()),
          );
        } else if (title == "Delivery Address") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DeliveryAddressPage()),
          );
        } else if (title == "Payment Methods") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PaymentMethodsPage()),
          );
        } else if (title == "Help") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HelpPage()),
          );
        } else if (title == "About") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AboutPage()),
          );
        }
        // Add similar logic for other tiles like Promo Code, Notifications, etc.
      },
    );
  }
}
