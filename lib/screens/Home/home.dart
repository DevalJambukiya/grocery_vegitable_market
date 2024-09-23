import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_adaptive_navigation/flutter_adaptive_navigation.dart';
import 'package:grocery_vegitable_market/banner/banner.dart';

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
      'color': Colors.lightGreen[50],
    },
    {
      'name': 'Red Apple',
      'price': '\$4.99',
      'image': 'assets/Fruit/red_apple.jpeg',
      'color': Colors.red[50],
    },
  ];

  List<Map<String, dynamic>> searchResults = [];

  @override
  void initState() {
    super.initState();
    searchResults = allProducts;

    _bannerTimer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      setState(() {
        _currentPage = (_currentPage + 1) % bannerImages.length;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
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

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return FlutterAdaptiveNavigationScaffold(
      labelDisplayType: LabelDisplayType.all,
      appBar: AppBar(
        title: const Text('Fresh Vegetables'),
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
          builder: () => buildExploreContent(),
        ),
        NavigationElement(
          icon: const Icon(Icons.shopping_cart),
          label: 'Cart',
          builder: () => buildCartContent(),
        ),
        NavigationElement(
          icon: const Icon(Icons.favorite),
          label: 'Favorites',
          builder: () => buildFavoritesContent(),
        ),
        NavigationElement(
          icon: const Icon(Icons.person),
          label: 'Account',
          builder: () => buildAccountContent(),
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
            width: 180, // Adjust width for responsive design
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailPage(product: product),
                  ),
                );
              },
              child: ProductCard(
                productName: product['name'],
                price: product['price'],
                image: product['image'],
                cardColor: product['color'],
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
            onTap: () {},
            child: Text('See all', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  Widget buildExploreContent() => Center(child: Text('Explore Page'));
  Widget buildCartContent() => Center(child: Text('Cart Page'));
  Widget buildFavoritesContent() => Center(child: Text('Favorites Page'));
  Widget buildAccountContent() => Center(child: Text('Account Page'));
}

class ProductCard extends StatelessWidget {
  final String productName;
  final String price;
  final String image;
  final Color cardColor;

  ProductCard({
    required this.productName,
    required this.price,
    required this.image,
    required this.cardColor,
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
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(image,
                height: 120, width: 120), // Increased image size
          ),
          Text(
            productName,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18), // Increased font size
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // Adjusts spacing between elements
            children: [
              Text(price,
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 18)), // Increased font size
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Add to cart logic here
                  },
                  child: Icon(Icons.add_shopping_cart,
                      size: 20), // Icon size can be adjusted
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: CircleBorder(), // Makes button circular
                    padding: EdgeInsets.all(12), // Increases button size
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> product;

  ProductDetailPage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(product['image'], height: 200, width: 200),
            Text(product['name'],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(product['price'],
                style: TextStyle(fontSize: 20, color: Colors.green)),
            ElevatedButton(
              onPressed: () {
                // Add to cart logic here
              },
              child: Text("Add to Cart"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}
