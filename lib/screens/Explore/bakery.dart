import 'package:flutter/material.dart';
import 'package:grocery_vegitable_market/screens/Explore/fruit.dart';
import 'package:provider/provider.dart';
import 'package:grocery_vegitable_market/screens/Home/productdetailspage.dart';

// Bakery model
class BakeryItem {
  final String name;
  final double price;
  final String imagePath;

  BakeryItem(
      {required this.name, required this.price, required this.imagePath});
}

// BakeryPage
class BakeryPage extends StatelessWidget {
  final List<BakeryItem> bakeryItems = [
    BakeryItem(
        name: 'Bread', price: 2.0, imagePath: 'assets/Bakery/bread.jpeg'),
    BakeryItem(
        name: 'Croissant',
        price: 1.5,
        imagePath: 'assets/Bakery/croissant.jpeg'),
    BakeryItem(
        name: 'Muffin', price: 1.0, imagePath: 'assets/Bakery/muffin.jpeg'),
    BakeryItem(
        name: 'Cookies', price: 1.2, imagePath: 'assets/Bakery/cookies.jpeg'),
    BakeryItem(name: 'Cake', price: 3.5, imagePath: 'assets/Bakery/cake.jpeg'),
    // Add more bakery items as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bakery & Snacks'),
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
        itemCount: bakeryItems.length,
        itemBuilder: (context, index) {
          final bakeryItem = bakeryItems[index];
          return _buildBakeryCard(context, bakeryItem);
        },
      ),
    );
  }

  Widget _buildBakeryCard(BuildContext context, BakeryItem bakeryItem) {
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
                image: AssetImage(bakeryItem.imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              bakeryItem.name,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Text(
            '\$${bakeryItem.price.toStringAsFixed(2)}',
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
                      'name': bakeryItem.name,
                      'price': bakeryItem.price,
                      'image': bakeryItem.imagePath,
                      'description':
                          'Enjoy a delicious ${bakeryItem.name}.', // Example description
                    },
                    onAddToCart: (product) {
                      Provider.of<CartProvider>(context, listen: false)
                          .addToCart(Bakery(
                        name: product['name'],
                        price: product['price'],
                        imagePath: product['image'],
                      ) as Fruit);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('${bakeryItem.name} added to cart!')),
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

  Bakery({required name, required price, required imagePath}) {}
}
