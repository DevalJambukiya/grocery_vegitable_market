import 'package:flutter/material.dart';

class FruitPage extends StatelessWidget {
  final List<Fruit> fruits = [
    Fruit("Apple", "assets/apple.png", 2.99, "1kg"),
    Fruit("Banana", "assets/banana.png", 1.50, "1kg"),
    Fruit("Mango", "assets/mango.png", 3.99, "1kg"),
    Fruit("Orange", "assets/orange.png", 2.50, "1kg"),
    Fruit("Strawberry", "assets/strawberry.png", 5.99, "500g"),
    Fruit("Pineapple", "assets/pineapple.png", 4.99, "1kg"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fruits'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Add your action here
            },
          )
        ],
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
          itemCount: fruits.length,
          itemBuilder: (context, index) {
            return FruitCard(fruit: fruits[index]);
          },
        ),
      ),
    );
  }
}

class Fruit {
  final String name;
  final String imagePath;
  final double price;
  final String size;

  Fruit(this.name, this.imagePath, this.price, this.size);
}

class FruitCard extends StatelessWidget {
  final Fruit fruit;

  const FruitCard({Key? key, required this.fruit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            fruit.imagePath,
            height: 80,
            fit: BoxFit.contain,
          ),
          Text(
            fruit.name,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            fruit.size,
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            "\$${fruit.price.toStringAsFixed(2)}",
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
