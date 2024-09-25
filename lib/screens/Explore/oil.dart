import 'package:flutter/material.dart';
import 'package:grocery_vegitable_market/screens/Explore/fruit.dart';
import 'package:provider/provider.dart';
import 'package:grocery_vegitable_market/screens/Home/productdetailspage.dart';

// Oil model
class Oil {
  final String name;
  final double price;
  final String imagePath;

  Oil({required this.name, required this.price, required this.imagePath});
}

// CookingOilPage
class CookingOilPage extends StatelessWidget {
  final List<Oil> oils = [
    Oil(
        name: 'Sunflower Oil',
        price: 3.0,
        imagePath: 'assets/Oil/sunflower.jpeg'),
    Oil(name: 'Olive Oil', price: 5.0, imagePath: 'assets/Oil/olive.jpeg'),
    Oil(name: 'Coconut Oil', price: 4.5, imagePath: 'assets/Oil/coconut.jpeg'),
    Oil(name: 'Palm Oil', price: 2.5, imagePath: 'assets/Oil/palm.jpeg'),
    Oil(name: 'Ghee', price: 7.0, imagePath: 'assets/Oil/ghee.jpeg'),
    // Add more oils as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cooking Oil & Ghee'),
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
        itemCount: oils.length,
        itemBuilder: (context, index) {
          final oil = oils[index];
          return _buildOilCard(context, oil);
        },
      ),
    );
  }

  Widget _buildOilCard(BuildContext context, Oil oil) {
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
                image: AssetImage(oil.imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              oil.name,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Text(
            '\$${oil.price.toStringAsFixed(2)}',
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
                      'name': oil.name,
                      'price': oil.price,
                      'image': oil.imagePath,
                      'description':
                          'This is high-quality ${oil.name}.', // Example description
                    },
                    onAddToCart: (product) {
                      Provider.of<CartProvider>(context, listen: false)
                          .addToCart(Oil(
                        name: product['name'],
                        price: product['price'],
                        imagePath: product['image'],
                      ) as Fruit);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${oil.name} added to cart!')),
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
