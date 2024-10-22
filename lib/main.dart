import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grocery_vegitable_market/screens/login.dart';
import 'package:grocery_vegitable_market/screens/register.dart';
import 'package:grocery_vegitable_market/screens/splashscreen.dart';
import 'package:grocery_vegitable_market/screens/welcomescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
    // Firebase initialization for web
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAag9sX1VGnL013PEpLuLil403KbmkqejI",
        authDomain:
            "grocery-vegetable-market-215f9.firebaseapp.com", // Firebase Auth domain for web
        projectId: "grocery-vegetable-market-215f9",
        storageBucket:
            "grocery-vegetable-market-215f9.appspot.com", // Firebase Storage
        messagingSenderId: "243939484600",
        appId: "1:243939484600:android:27da5344c5ba7a9593254d",
        measurementId:
            "G-XXXXXXXXXX", // Optional: Use your Firebase Analytics measurement ID
        databaseURL:
            "https://grocery-vegetable-market-215f9.firebaseio.com", // Realtime Database URL (if needed)
      ),
    );
  } else {
    // Firebase initialization for mobile (Android/iOS)
    await Firebase.initializeApp();
  }

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
      home: Register(),
      routes: {
        '/welcome': (context) => const Welcomescreen(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}
