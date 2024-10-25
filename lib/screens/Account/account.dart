import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_vegitable_market/screens/Account/About.dart';
import 'package:grocery_vegitable_market/screens/Account/Help.dart';
import 'package:grocery_vegitable_market/screens/Account/delivery_add.dart';
import 'package:grocery_vegitable_market/screens/Account/order.dart';
import 'package:grocery_vegitable_market/screens/Account/payment.dart';
import 'package:grocery_vegitable_market/screens/Account/profile.dart';
import 'package:grocery_vegitable_market/screens/login.dart'; // Assuming you have a login page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthWrapper(), // Use AuthWrapper for authentication handling
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return LoginPage(); // Redirect to Login Page if not logged in
          } else {
            return AccountPage(); // Redirect to Account Page if logged in
          }
        }
        return Center(child: CircularProgressIndicator()); // Loading state
      },
    );
  }
}

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late Future<DocumentSnapshot> _userDataFuture;
  User? user;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    if (user != null) {
      _userDataFuture = _firestore.collection('users').doc(user!.uid).get();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        body: Center(child: Text("Please log in to view your account.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 243, 248, 244)],
              begin: Alignment.center,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: _userDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error fetching data"));
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(child: Text("No user data found"));
            }

            var userData = snapshot.data!.data() as Map<String, dynamic>;

            return Column(
              children: [
                // User Info Section
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
                            backgroundImage: userData['profileImage'] != null &&
                                    userData['profileImage'] != ''
                                ? NetworkImage(userData['profileImage'])
                                : AssetImage('assets/Logo/welcome.jpg')
                                    as ImageProvider,
                          ),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userData['fullName'] ?? 'No Name',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                user!.email ?? 'No Email',
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
                // Account Options
                ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  children: [
                    buildListTile(Icons.shopping_bag, "Orders", context),
                    buildListTile(Icons.person, "My Details", context),
                    buildListTile(
                        Icons.location_on, "Delivery Address", context),
                    buildListTile(
                        Icons.credit_card, "Payment Methods", context),
                    buildListTile(Icons.card_giftcard, "Promo Code", context),
                    buildListTile(
                        Icons.notifications, "Notifications", context),
                    buildListTile(Icons.help, "Help", context),
                    buildListTile(Icons.info, "About", context),
                  ],
                ),
                // Logout Button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await _auth.signOut(); // Log out action
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LoginPage()), // Navigate to Login Page
                      );
                    },
                    icon: Icon(Icons.logout),
                    label: Text("Log Out"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 24.0),
                      side: BorderSide(color: Colors.green),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            );
          },
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
      },
    );
  }
}
