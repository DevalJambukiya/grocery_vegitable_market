import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Favorites Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: FavoritePage(),
    );
  }
}

class FavoritePage extends StatelessWidget {
  final List<Map<String, dynamic>> favoriteItems = [
    {
      'name': 'Sprite Can',
      'size': '325ml',
      'price': 1.50,
      'image': 'assets/Beverages/sprite can.jpeg',
    },
    {
      'name': 'Diet Coke',
      'size': '335ml',
      'price': 1.99,
      'image': 'assets/Beverages/Diet Coke.jpeg',
    },
    {
      'name': 'Apple & Grape Juice',
      'size': '3 kg',
      'price': 15.50,
      'image': 'assets/fruit/red_apple.jpeg',
    },
    {
      'name': 'Coca Cola Can',
      'size': '325ml',
      'price': 4.99,
      'image': 'assets/Beverages/Coca Cola Can.jpeg',
    },
    {
      'name': 'Ladie Finger',
      'size': '2 kg',
      'price': 4.99,
      'image': 'assets/Vegitable/ladies finger.jpeg',
    },
    {
      'name': 'Ginger',
      'size': '2 kg',
      'price': 4.99,
      'image': 'assets/Vegitable/ginger.jpeg',
    },
    {
      'name': 'Cucumber',
      'size': '2 kg',
      'price': 4.99,
      'image': 'assets/Vegitable/consumer.jpeg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(255, 243, 248, 244),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.green.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Scrollbar(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    int columnCount = (constraints.maxWidth / 180).floor();
                    return GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columnCount,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: favoriteItems.length,
                      itemBuilder: (context, index) {
                        return _buildFavoriteItem(
                            context, favoriteItems[index]);
                      },
                    );
                  },
                ),
              ),
            ),
            _buildAddAllToCartButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteItem(BuildContext context, Map<String, dynamic> item) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                item['image'],
                width: double.infinity,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item['name'],
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width < 400 ? 12 : 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              item['size'],
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width < 400 ? 10 : 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              '\$${item['price'].toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width < 400 ? 12 : 14,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddAllToCartButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.shopping_cart, size: 18),
          label: const Text(
            'Add All To Cart',
            style: TextStyle(fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('All items added to cart!'),
              ),
            );
          },
        ),
      ),
    );
  }
}
