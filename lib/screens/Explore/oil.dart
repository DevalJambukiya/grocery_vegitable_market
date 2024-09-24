import 'package:flutter/material.dart';

class Oil extends StatelessWidget {
  final List<Map<String, dynamic>> beverages = [
    {
      "name": "Diet Coke",
      "image": "assets/diet_coke.png",
      "size": "355ml",
      "price": 1.99,
    },
    {
      "name": "Sprite Can",
      "image": "assets/sprite.png",
      "size": "355ml",
      "price": 1.50,
    },
    {
      "name": "Apple & Grape Juice",
      "image": "assets/apple_grape_juice.png",
      "size": "2L",
      "price": 15.99,
    },
    {
      "name": "Orange Juice",
      "image": "assets/orange_juice.png",
      "size": "2L",
      "price": 15.99,
    },
    {
      "name": "Coca Cola Can",
      "image": "assets/coca_cola.png",
      "size": "355ml",
      "price": 4.99,
    },
    {
      "name": "Pepsi Can",
      "image": "assets/pepsi.png",
      "size": "330ml",
      "price": 4.99,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cooking Oil & Ghee'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Add functionality for settings if needed
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.6,
          ),
          itemCount: beverages.length,
          itemBuilder: (context, index) {
            final beverage = beverages[index];
            return BeverageCard(
              name: beverage['name'],
              image: beverage['image'],
              size: beverage['size'],
              price: beverage['price'],
            );
          },
        ),
      ),
    );
  }
}

class BeverageCard extends StatelessWidget {
  final String name;
  final String image;
  final String size;
  final double price;

  BeverageCard({
    required this.name,
    required this.image,
    required this.size,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image.asset(
              image,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 8.0),
            Text(
              name,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.0),
            Text(
              size,
              style: TextStyle(fontSize: 12.0, color: Colors.grey),
            ),
            SizedBox(height: 8.0),
            Text(
              '\$$price',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Add functionality for adding to cart
              },
              child: Icon(Icons.add, color: Colors.white),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(10),
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
