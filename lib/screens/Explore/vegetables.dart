import 'package:flutter/material.dart';
import 'package:grocery_vegitable_market/screens/Explore/fruit.dart';
import 'package:provider/provider.dart';
import 'package:grocery_vegitable_market/screens/Home/productdetailspage.dart';

// Vegetable model
class Vegetable {
  final String name;
  final double price;
  final String imagePath;

  Vegetable({required this.name, required this.price, required this.imagePath});
}

// VegetablesPage
class VegetablesPage extends StatelessWidget {
  final List<Vegetable> vegetables = [
    Vegetable(
        name: 'Carrot', price: 1.0, imagePath: 'assets/Vegitable/carrot.jpeg'),
    Vegetable(
        name: 'Tomato', price: 0.75, imagePath: 'assets/Vegitable/tomato.jpeg'),
    Vegetable(
        name: 'Broccoli',
        price: 1.5,
        imagePath: 'assets/Vegitable/broccoli.jpeg'),
    Vegetable(
        name: 'Spinach',
        price: 2.0,
        imagePath: 'assets/Vegitable/spinach.jpeg'),
    Vegetable(
        name: 'Potato', price: 0.5, imagePath: 'assets/Vegitable/potato.jpeg'),
    // Add more vegetables as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vegetables'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.7,
        ),
        padding: const EdgeInsets.all(8.0),
        itemCount: vegetables.length,
        itemBuilder: (context, index) {
          final vegetable = vegetables[index];
          return _buildVegetableCard(context, vegetable);
        },
      ),
    );
  }

  Widget _buildVegetableCard(BuildContext context, Vegetable vegetable) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
              image: DecorationImage(
                image: AssetImage(vegetable.imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              vegetable.name,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Text(
            '\$${vegetable.price.toStringAsFixed(2)}',
            style: TextStyle(color: Colors.green, fontSize: 14),
          ),
          SizedBox(height: 4),
          ElevatedButton(
            onPressed: () {
              // Navigate to ProductDetailPage when clicking "View Details"
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(
                    product: {
                      'name': vegetable.name,
                      'price': vegetable.price,
                      'image': vegetable.imagePath,
                      'description':
                          'This is fresh ${vegetable.name}.', // Example description
                    },
                    onAddToCart: (product) {
                      Provider.of<CartProvider>(context, listen: false)
                          .addToCart(Vegetable(
                        name: product['name'],
                        price: product['price'],
                        imagePath: product['image'],
                      ) as Fruit);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('${vegetable.name} added to cart!')),
                      );
                    },
                  ),
                ),
              );
            },
            child: Text('View Details'),
          ),
        ],
      ),
    );
  }
}
