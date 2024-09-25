// explore_page.dart
import 'package:flutter/material.dart';
import 'package:grocery_vegitable_market/screens/Explore/beverages%20.dart';
import 'package:grocery_vegitable_market/screens/Explore/oil.dart';
import 'vegetables.dart'; // Import the Vegetables Page
import 'bakery.dart'; // Import the Bakery Page
import 'atta.dart'; // Import the Atta Page
import 'chocolate.dart'; // Import the Chocolate Page
import 'fruit.dart'; // Import the Fruit Page

void main() {
  runApp(MaterialApp(home: ExplorePage()));
}

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final List<String> _products = [
    'Fruits',
    'Cooking Oil & Ghee',
    'Vegetables',
    'Bakery & Snacks',
    'Atta',
    'Beverages',
    'Chocolate'
  ];

  final List<String> _productImages = [
    'assets/explore/fruits.png',
    'assets/explore/oil.png',
    'assets/explore/vegitable.png',
    'assets/explore/bakery.png',
    'assets/explore/atta.png',
    'assets/explore/beverages.png',
    'assets/explore/chocolate.png'
  ];

  List<String> _filteredProducts = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredProducts = _products; // Show all products initially
  }

  void _filterProducts(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredProducts = _products; // Show all products if query is empty
      } else {
        // Filter products based on the search query
        _filteredProducts = _products
            .where((product) =>
                product.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Products'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 243, 248, 244),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterProducts,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search Store',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              padding: const EdgeInsets.all(8.0),
              children: _filteredProducts.map((product) {
                int index = _products.indexOf(product);
                return _buildCategoryCard(product, _productImages[index]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, String imagePath) {
    return GestureDetector(
      onTap: () {
        // Handle navigation based on product title
        if (title == 'Fruits') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FruitPage(),
            ),
          );
        } else if (title == 'Cooking Oil & Ghee') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CookingOilPage(),
            ),
          );
        } else if (title == 'Vegetables') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VegetablesPage(),
            ),
          );
        } else if (title == 'Bakery & Snacks') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BakeryPage(),
            ),
          );
        } else if (title == 'Atta') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AttaPage(),
            ),
          );
        } else if (title == 'Beverages') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BeverageScreen(),
            ),
          );
        } else if (title == 'Chocolate') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChocolatePage(),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailPage(productName: title),
            ),
          );
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ProductDetailPage for generic product categories
class ProductDetailPage extends StatelessWidget {
  final String productName;

  ProductDetailPage({required this.productName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productName),
      ),
      body: Center(
        child: Text(
          'Details for $productName',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
