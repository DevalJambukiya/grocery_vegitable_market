import 'package:flutter/material.dart';
import 'package:grocery_vegitable_market/screens/Explore/fruit.dart';
import 'package:provider/provider.dart';
import 'package:grocery_vegitable_market/screens/Home/productdetailspage.dart';

// Beverage model
class Beverage {
  final String name;
  final double price;
  final String imagePath;

  Beverage({required this.name, required this.price, required this.imagePath});
}

// BeverageScreen
class BeverageScreen extends StatelessWidget {
  final List<Beverage> beverages = [
    Beverage(
        name: 'Orange Juice',
        price: 2.5,
        imagePath: 'assets/Beverages/orange_juice.jpeg'),
    Beverage(
        name: 'Apple Juice',
        price: 2.0,
        imagePath: 'assets/Beverages/apple_juice.jpeg'),
    Beverage(
        name: 'Lemonade',
        price: 1.5,
        imagePath: 'assets/Beverages/lemonade.jpeg'),
    Beverage(
        name: 'Iced Tea',
        price: 1.8,
        imagePath: 'assets/Beverages/iced_tea.jpeg'),
    // Add more beverage items as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beverages'),
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
        itemCount: beverages.length,
        itemBuilder: (context, index) {
          final beverage = beverages[index];
          return _buildBeverageCard(context, beverage);
        },
      ),
    );
  }

  Widget _buildBeverageCard(BuildContext context, Beverage beverage) {
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
                image: AssetImage(beverage.imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              beverage.name,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Text(
            '\$${beverage.price.toStringAsFixed(2)}',
            style: TextStyle(color: Colors.blue, fontSize: 14),
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
                      'name': beverage.name,
                      'price': beverage.price,
                      'image': beverage.imagePath,
                      'description':
                          'Refreshing ${beverage.name} for hot days.', // Example description
                    },
                    onAddToCart: (product) {
                      Provider.of<CartProvider>(context, listen: false)
                          .addToCart(Beverage(
                        // Use Beverage instead of beverages
                        name: product['name'],
                        price: product['price'],
                        imagePath: product['image'],
                      ) as Fruit);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('${beverage.name} added to cart!')),
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
