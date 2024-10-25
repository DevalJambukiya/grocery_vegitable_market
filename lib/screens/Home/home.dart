import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_adaptive_navigation/flutter_adaptive_navigation.dart';
import 'package:grocery_vegitable_market/banner/banner.dart';
import 'package:grocery_vegitable_market/screens/Account/account.dart';
import 'package:grocery_vegitable_market/screens/Cart/cart.dart';
import 'package:grocery_vegitable_market/screens/Explore/explore.dart';
import 'package:grocery_vegitable_market/screens/Favorites/favoritepage.dart';
import 'package:grocery_vegitable_market/screens/Home/productdetailspage.dart'
    as home;
import 'package:grocery_vegitable_market/screens/Cart/cart.dart'
    as cart; // Alias for CartPage
import 'package:grocery_vegitable_market/screens/Account/account.dart'
    as account; // Alias for Account

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _bannerTimer;

  final List<String> bannerImages = [
    'assets/banner/b1.jpg',
    'assets/banner/b2.jpeg',
    'assets/banner/b3.jpeg',
  ];

  final List<Map<String, dynamic>> allProducts = [
    {
      'name': 'Organic Bananas',
      'price': '\$4.99',
      'image': 'assets/Fruit/organic_bananas.jpeg',
      'rating': 4.5,
      'quantity': '1kg',
      'description': 'Fresh organic bananas from local farms.',
      'color': Colors.lightGreen[50],
    },
    {
      'name': 'Red Apple',
      'price': '\$3.99',
      'image': 'assets/Fruit/red_apple.jpeg',
      'rating': 4.8,
      'quantity': '500g',
      'description': 'Crispy and sweet red apples, great for snacks.',
      'color': Colors.red[50],
    },
    // Add more products as needed
  ];

  List<Map<String, dynamic>> searchResults = [];
  List<Map<String, dynamic>> cartItems = [];
  List<Map<String, dynamic>> favoriteItems = [];

  @override
  void initState() {
    super.initState();
    searchResults = allProducts;

    // Start the banner auto-scroll timer
    _bannerTimer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      setState(() {
        _currentPage = (_currentPage + 1) % bannerImages.length;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bannerTimer?.cancel();
    super.dispose();
  }

  void handleSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        searchResults = allProducts;
      } else {
        searchResults = allProducts.where((product) {
          return product['name'].toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void addToCart(Map<String, dynamic> product) {
    setState(() {
      cartItems.add(product);
    });
  }

  void addToFavorites(Map<String, dynamic> product) {
    setState(() {
      if (!favoriteItems.contains(product)) {
        favoriteItems.add(product);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return FlutterAdaptiveNavigationScaffold(
      labelDisplayType: LabelDisplayType.all,
      appBar: AppBar(
        title: const Text('Fresh Vegetables And Grocery'),
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
      ),
      drawerWidthFraction: 0.2,
      destinations: [
        NavigationElement(
          icon: const Icon(Icons.store),
          selectedIcon: const Icon(Icons.store_mall_directory),
          label: 'Home',
          builder: () => buildHomeContent(screenWidth),
        ),
        NavigationElement(
          icon: const Icon(Icons.explore),
          label: 'Explore',
          builder: () => ExplorePage(),
        ),
        NavigationElement(
          icon: const Icon(Icons.shopping_cart),
          label: 'Cart',
          builder: () => CartPage(), // Updated with alias
        ),
        NavigationElement(
          icon: const Icon(Icons.favorite),
          label: 'Favorites',
          builder: () => FavoritePage(),
        ),
        NavigationElement(
          icon: const Icon(Icons.person),
          label: 'Account',
          builder: () => AccountPage(), // Updated with alias
        ),
      ],
      backgroundColor: Colors.white,
    );
  }

  Widget buildHomeContent(double screenWidth) {
    return ListView(
      children: [
        buildSearchBar(),
        buildBanner(screenWidth),
        buildSectionHeader('Exclusive Offer'),
        buildProductList(),
        buildSectionHeader('Best Selling'),
        buildProductList(),
      ],
    );
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onChanged: handleSearch,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.green),
          hintText: 'Search Store',
          fillColor: Colors.green[50],
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget buildBanner(double screenWidth) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BannerDetails()),
        );
      },
      child: Column(
        children: [
          Container(
            width: screenWidth,
            height: 180,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemCount: bannerImages.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: AssetImage(bannerImages[index]),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          buildPageIndicators(),
        ],
      ),
    );
  }

  Widget buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(bannerImages.length, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          height: 8.0,
          width: _currentPage == index ? 12.0 : 8.0,
          decoration: BoxDecoration(
            color: _currentPage == index ? Colors.green : Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }),
    );
  }

  Widget buildProductList() {
    return Container(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          final product = searchResults[index];
          return SizedBox(
            width: 180,
            child: GestureDetector(
              onTap: () {
                // Navigate to ProductDetailPage with the selected product
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => home.ProductDetailPage(
                      product: product,
                      onAddToCart: addToCart,
                    ),
                  ),
                );
              },
              child: ProductCard(
                productName: product['name'],
                price: product['price'],
                image: product['image'],
                cardColor: product['color'],
                onAddToCart: () => addToCart(product),
                onFavorite: () => addToFavorites(product),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: () {
              // Implement 'See all' functionality if needed
            },
            child: Text('See all', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  Widget buildAccountContent() => Center(child: Text('Account Page'));
}

class ProductCard extends StatelessWidget {
  final String productName;
  final String price;
  final String image;
  final Color cardColor;
  final VoidCallback onAddToCart;
  final VoidCallback onFavorite;

  ProductCard({
    required this.productName,
    required this.price,
    required this.image,
    required this.cardColor,
    required this.onAddToCart,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(image, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(productName, style: TextStyle(fontSize: 16)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(price,
                style: TextStyle(fontSize: 14, color: Colors.green)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.favorite_border),
                onPressed: onFavorite,
              ),
              IconButton(
                icon: Icon(Icons.add_shopping_cart),
                onPressed: onAddToCart,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
