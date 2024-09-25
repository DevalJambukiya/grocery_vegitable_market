import 'package:flutter/material.dart';
import 'package:grocery_vegitable_market/Admin/screens/dashboard.dart';
import 'package:grocery_vegitable_market/screens/Account/account.dart';
import 'package:grocery_vegitable_market/screens/Explore/beverages%20.dart';
import 'package:grocery_vegitable_market/screens/Explore/explore.dart';
import 'package:grocery_vegitable_market/screens/Explore/fruit.dart';
import 'package:grocery_vegitable_market/screens/Favorites/favoritepage.dart';

import 'package:grocery_vegitable_market/screens/home/Home.dart';
// import 'package:grocery_vegitable_market/screens/selectlocation';
// import 'package:grocery_vegitable_market/screens/splashscreen.dart';
import 'package:grocery_vegitable_market/screens/login.dart';
import 'package:grocery_vegitable_market/screens/splashscreen.dart';
import 'package:grocery_vegitable_market/screens/welcomescreen.dart';
import 'package:grocery_vegitable_market/navigation/navigation_bar.dart';

void main() {
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
      home: const Splashscreen(),
      //home: LoginPage(),
      //home: SelectLocationPage(),
      //home: Home(),
      //home: Account(),
      //home: ExplorePage(),
      //home: BeverageScreen(),
      //home: FruitPage(),
      //home: FavoritePage(),
      //home: DashboardApp(),

      routes: {
        '/welcome': (context) => const Welcomescreen(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}
