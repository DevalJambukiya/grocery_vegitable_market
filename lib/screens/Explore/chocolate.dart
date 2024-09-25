import 'package:flutter/material.dart';
import 'package:grocery_vegitable_market/screens/Explore/fruit.dart';
import 'package:provider/provider.dart';
import 'package:grocery_vegitable_market/screens/Home/productdetailspage.dart';

// Chocolate model
class Chocolate {
  final String name;
  final double price;
  final String imagePath;

  Chocolate({required this.name, required this.price, required this.imagePath});
}

// ChocolatePage
class ChocolatePage extends StatelessWidget {
  final List<Chocolate> chocolates = [
    Chocolate(
        name: 'Milk Chocolate',
        price: 2.0,
        imagePath: 'assets/Chocolate/milk_chocolate.jpeg'),
    Chocolate(
        name: 'Dark Chocolate',
        price: 2.5,
        imagePath: 'assets/Chocolate/dark_chocolate.jpeg'),
    Chocolate(
        name: 'White Chocolate',
        price: 1.8,
        imagePath: 'assets/Chocolate/white_chocolate.jpeg'),
    Chocolate(
        name: 'Hazelnut Chocolate',
        price: 3.0,
        imagePath: 'assets/Chocolate/hazelnut_chocolate.jpeg'),
    // Add more chocolate items as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chocolate'),
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
        itemCount: chocolates.length,
        itemBuilder: (context, index) {
          final chocolate = chocolates[index];
          return _buildChocolateCard(context, chocolate);
        },
      ),
    );
  }

  Widget _buildChocolateCard(BuildContext context, Chocolate chocolate) {
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
                image: AssetImage(chocolate.imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              chocolate.name,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Text(
            '\$${chocolate.price.toStringAsFixed(2)}',
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
                      'name': chocolate.name,
                      'price': chocolate.price,
                      'image': chocolate.imagePath,
                      'description':
                          'Indulge in delicious ${chocolate.name}.', // Example description
                    },
                    onAddToCart: (product) {
                      Provider.of<CartProvider>(context, listen: false)
                          .addToCart(Chocolate(
                        name: product['name'],
                        price: product['price'],
                        imagePath: product['image'],
                      ) as Fruit);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('${chocolate.name} added to cart!')),
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
