import 'package:flutter/material.dart';

class AttaPage extends StatelessWidget {
  final List<Atta> attaItems = [
    Atta("Wheat Flour", "assets/wheat_flour.png", 2.99, "1kg"),
    Atta("Rice Flour", "assets/rice_flour.png", 3.50, "1kg"),
    Atta("Besan (Gram Flour)", "assets/besan.png", 4.99, "1kg"),
    Atta("Maida (All-Purpose Flour)", "assets/maida.png", 2.50, "1kg"),
    Atta("Oats Flour", "assets/oats_flour.png", 5.99, "500g"),
    Atta("Barley Flour", "assets/barley_flour.png", 6.99, "1kg"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Atta Products'),
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
          itemCount: attaItems.length,
          itemBuilder: (context, index) {
            return AttaCard(atta: attaItems[index]);
          },
        ),
      ),
    );
  }
}

class Atta {
  final String name;
  final String imagePath;
  final double price;
  final String size;

  Atta(this.name, this.imagePath, this.price, this.size);
}

class AttaCard extends StatelessWidget {
  final Atta atta;

  const AttaCard({Key? key, required this.atta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            atta.imagePath,
            height: 80,
            fit: BoxFit.contain,
          ),
          Text(
            atta.name,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            atta.size,
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            "\$${atta.price.toStringAsFixed(2)}",
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
