import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: BeverageScreen()));
}

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
