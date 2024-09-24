import 'package:flutter/material.dart';
import 'package:grocery_vegitable_market/screens/Explore/fruit.dart';

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
    'assets/explore/vegetable.png',
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
        } else if (title == 'Beverages') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BeverageScreen(),
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

// FruitPage

// BeveragePage (already implemented previously)
class BeverageScreen extends StatelessWidget {
  final List<Beverage> beverages = [
    Beverage("Diet Coke", "assets/diet_coke.png", 1.99, "355ml"),
    Beverage("Sprite Can", "assets/sprite_can.png", 1.50, "325ml"),
    Beverage(
        "Apple & Grape Juice", "assets/apple_grape_juice.png", 15.99, "2L"),
    Beverage("Orange Juice", "assets/orange_juice.png", 15.99, "2L"),
    Beverage("Coca Cola Can", "assets/coca_cola_can.png", 4.99, "325ml"),
    Beverage("Pepsi Can", "assets/pepsi_can.png", 4.99, "330ml"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beverages'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.7, // Adjust for spacing between items
          ),
          itemCount: beverages.length,
          itemBuilder: (context, index) {
            return BeverageCard(beverage: beverages[index]);
          },
        ),
      ),
    );
  }
}

class Beverage {
  final String name;
  final String imagePath;
  final double price;
  final String size;

  Beverage(this.name, this.imagePath, this.price, this.size);
}

class BeverageCard extends StatelessWidget {
  final Beverage beverage;

  const BeverageCard({Key? key, required this.beverage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            beverage.imagePath,
            height: 80,
            fit: BoxFit.contain,
          ),
          Text(
            beverage.name,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            beverage.size,
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            "\$${beverage.price.toStringAsFixed(2)}",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () {
              // Add to cart logic here
            },
            icon: Icon(Icons.add_circle, color: Colors.green),
          ),
        ],
      ),
    );
  }
}
