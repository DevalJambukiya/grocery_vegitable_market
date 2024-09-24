import 'package:flutter/material.dart';

class BakeryPage extends StatelessWidget {
  final List<Bakery> bakeryItems = [
    Bakery("Bread", "assets/bread.png", 2.99, "500g"),
    Bakery("Croissant", "assets/croissant.png", 1.50, "1 piece"),
    Bakery("Muffin", "assets/muffin.png", 3.99, "1 piece"),
    Bakery("Bagel", "assets/bagel.png", 2.50, "1 piece"),
    Bakery("Cake", "assets/cake.png", 15.99, "1kg"),
    Bakery("Doughnut", "assets/doughnut.png", 1.99, "1 piece"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bakery Items'),
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
          itemCount: bakeryItems.length,
          itemBuilder: (context, index) {
            return BakeryCard(bakery: bakeryItems[index]);
          },
        ),
      ),
    );
  }
}

class Bakery {
  final String name;
  final String imagePath;
  final double price;
  final String size;

  Bakery(this.name, this.imagePath, this.price, this.size);
}

class BakeryCard extends StatelessWidget {
  final Bakery bakery;

  const BakeryCard({Key? key, required this.bakery}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            bakery.imagePath,
            height: 80,
            fit: BoxFit.contain,
          ),
          Text(
            bakery.name,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            bakery.size,
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            "\$${bakery.price.toStringAsFixed(2)}",
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
