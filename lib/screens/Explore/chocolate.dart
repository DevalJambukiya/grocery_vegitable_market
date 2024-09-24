import 'package:flutter/material.dart';

class ChocolatePage extends StatelessWidget {
  final List<Chocolate> chocolateItems = [
    Chocolate("Dark Chocolate", "assets/dark_chocolate.png", 2.99, "100g"),
    Chocolate("Milk Chocolate", "assets/milk_chocolate.png", 1.50, "100g"),
    Chocolate("White Chocolate", "assets/white_chocolate.png", 2.50, "100g"),
    Chocolate("Chocolate Bars", "assets/chocolate_bars.png", 3.99, "200g"),
    Chocolate(
        "Chocolate Truffles", "assets/chocolate_truffles.png", 4.99, "150g"),
    Chocolate("Chocolate Chip Cookies", "assets/chocolate_chip_cookies.png",
        3.50, "300g"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chocolate Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Add your action here
            },
          ),
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
          itemCount: chocolateItems.length,
          itemBuilder: (context, index) {
            return ChocolateCard(chocolate: chocolateItems[index]);
          },
        ),
      ),
    );
  }
}

class Chocolate {
  final String name;
  final String imagePath;
  final double price;
  final String size;

  Chocolate(this.name, this.imagePath, this.price, this.size);
}

class ChocolateCard extends StatelessWidget {
  final Chocolate chocolate;

  const ChocolateCard({Key? key, required this.chocolate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            chocolate.imagePath,
            height: 80,
            fit: BoxFit.contain,
          ),
          Text(
            chocolate.name,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            chocolate.size,
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            "\$${chocolate.price.toStringAsFixed(2)}",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () {
              // Add to cart logic here
            },
            icon: Icon(Icons.add_circle, color: Colors.brown),
          ),
        ],
      ),
    );
  }
}
