import 'package:flutter/material.dart';

class VegetablePage extends StatelessWidget {
  final List<Vegetable> vegetables = [
    Vegetable("Carrot", "assets/carrot.png", 1.99, "1kg"),
    Vegetable("Tomato", "assets/tomato.png", 2.50, "1kg"),
    Vegetable("Potato", "assets/potato.png", 3.00, "2kg"),
    Vegetable("Onion", "assets/onion.png", 1.50, "1kg"),
    Vegetable("Broccoli", "assets/broccoli.png", 4.99, "500g"),
    Vegetable("Spinach", "assets/spinach.png", 2.99, "300g"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vegetables'),
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
          itemCount: vegetables.length,
          itemBuilder: (context, index) {
            return VegetableCard(vegetable: vegetables[index]);
          },
        ),
      ),
    );
  }
}

class Vegetable {
  final String name;
  final String imagePath;
  final double price;
  final String size;

  Vegetable(this.name, this.imagePath, this.price, this.size);
}

class VegetableCard extends StatelessWidget {
  final Vegetable vegetable;

  const VegetableCard({Key? key, required this.vegetable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            vegetable.imagePath,
            height: 80,
            fit: BoxFit.contain,
          ),
          Text(
            vegetable.name,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            vegetable.size,
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            "\$${vegetable.price.toStringAsFixed(2)}",
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
