import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grocery_vegitable_market/screens/Account/account.dart';
import 'package:grocery_vegitable_market/screens/Home/home.dart';
import 'package:grocery_vegitable_market/screens/login.dart';
import 'package:grocery_vegitable_market/screens/register.dart';
import 'package:grocery_vegitable_market/screens/splashscreen.dart';
import 'package:grocery_vegitable_market/screens/welcomescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hide debug banner
      title: 'Grocery Market',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      // Set initial route or page here
      home: LoginPage(),
      routes: {
        '/welcome': (context) => const Welcomescreen(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}
