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
        visualDensity: VisualDensity.adaptivePlatformDensity,
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
      'image': 'assets/Beverages/sprite_can.jpeg',
    },
    {
      'name': 'Diet Coke',
      'size': '335ml',
      'price': 1.99,
      'image': 'assets/Beverages/diet_coke.jpeg',
    },
    {
      'name': 'Apple & Grape Juice',
      'size': '3 kg',
      'price': 15.50,
      'image': 'assets/Fruit/red_apple.jpeg',
    },
    {
      'name': 'Coca Cola Can',
      'size': '325ml',
      'price': 4.99,
      'image': 'assets/Beverages/coca_cola_can.jpeg',
    },
    {
      'name': 'Ladie Finger',
      'size': '2 kg',
      'price': 4.99,
      'image': 'assets/Vegitable/ladies_finger.jpeg',
    },
    {
      'name': 'Ginger',
      'size': '2 kg',
      'price': 4.99,
      'image': 'assets/Vegitable/ginger.jpeg',
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
        centerTitle: true,
        elevation: 1,
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
                    int columnCount = constraints.maxWidth < 600 ? 2 : 4;
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columnCount,
                        childAspectRatio: 0.7, // Adjusted for more balance
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
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
      elevation: 5,
      shadowColor: Colors.grey.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: AspectRatio(
                aspectRatio: 1.3, // Consistent aspect ratio for images
                child: Image.asset(
                  item['image'],
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      alignment: Alignment.center,
                      child: const Text(
                        'Image not found',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              item['name'],
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width < 400 ? 12 : 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              item['size'],
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width < 400 ? 10 : 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '\$${item['price'].toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width < 400 ? 12 : 14,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddAllToCartButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: Offset(0, -2),
            blurRadius: 6,
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.shopping_cart, size: 24),
          label: const Text(
            'Add All To Cart',
            style: TextStyle(
              fontSize: 18, // Larger font for better visibility
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            backgroundColor: Colors.green.shade700,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
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
