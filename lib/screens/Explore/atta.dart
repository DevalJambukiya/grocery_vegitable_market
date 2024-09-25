import 'package:flutter/material.dart';
import 'package:grocery_vegitable_market/screens/Explore/fruit.dart';
import 'package:provider/provider.dart';
import 'package:grocery_vegitable_market/screens/Home/productdetailspage.dart';

// Atta model
class Atta {
  final String name;
  final double price;
  final String imagePath;

  Atta({required this.name, required this.price, required this.imagePath});
}

// AttaPage
class AttaPage extends StatelessWidget {
  final List<Atta> attas = [
    Atta(
        name: 'Wheat Flour',
        price: 2.0,
        imagePath: 'assets/Atta/wheat_flour.jpeg'),
    Atta(
        name: 'Chickpea Flour',
        price: 2.5,
        imagePath: 'assets/Atta/chickpea_flour.jpeg'),
    Atta(
        name: 'Rice Flour',
        price: 3.0,
        imagePath: 'assets/Atta/rice_flour.jpeg'),
    Atta(
        name: 'Multigrain Flour',
        price: 2.8,
        imagePath: 'assets/Atta/multigrain_flour.jpeg'),
    // Add more atta products as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Atta'),
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
        itemCount: attas.length,
        itemBuilder: (context, index) {
          final atta = attas[index];
          return _buildAttaCard(context, atta);
        },
      ),
    );
  }

  Widget _buildAttaCard(BuildContext context, Atta atta) {
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
                image: AssetImage(atta.imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              atta.name,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Text(
            '\$${atta.price.toStringAsFixed(2)}',
            style: TextStyle(color: Colors.brown, fontSize: 14),
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
                      'name': atta.name,
                      'price': atta.price,
                      'image': atta.imagePath,
                      'description':
                          'High-quality ${atta.name} for your cooking needs.', // Example description
                    },
                    onAddToCart: (product) {
                      Provider.of<CartProvider>(context, listen: false)
                          .addToCart(Atta(
                        name: product['name'],
                        price: product['price'],
                        imagePath: product['image'],
                      ) as Fruit);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${atta.name} added to cart!')),
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
