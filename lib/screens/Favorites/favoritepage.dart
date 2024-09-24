import 'package:flutter/material.dart';

class FavoritePage extends StatelessWidget {
  // Sample data for the list of favorite products
  final List<Map<String, dynamic>> favoriteItems = [
    {
      'name': 'Sprite Can',
      'size': '325ml',
      'price': 1.50,
      'image':
          'assets/sprite_can.png', // Ensure this path matches your project structure
    },
    {
      'name': 'Diet Coke',
      'size': '335ml',
      'price': 1.99,
      'image': 'assets/diet_coke.png',
    },
    {
      'name': 'Apple & Grape Juice',
      'size': '2L',
      'price': 15.50,
      'image': 'assets/apple_grape_juice.png',
    },
    {
      'name': 'Coca Cola Can',
      'size': '325ml',
      'price': 4.99,
      'image': 'assets/coca_cola_can.png',
    },
    {
      'name': 'Pepsi Can',
      'size': '330ml',
      'price': 4.99,
      'image': 'assets/pepsi_can.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Favorites',
              style: TextStyle(color: Colors.black), // Set text color to black
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 243, 248, 244),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                final item = favoriteItems[index];
                return Card(
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            item['image'],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                item['size'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '\$${item['price'].toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Full-width Add All to Cart Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  // Handle Add All to Cart functionality
                },
                child: const Text(
                  'Add All To Cart',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
