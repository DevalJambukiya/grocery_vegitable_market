import 'package:flutter/material.dart';
import 'package:grocery_vegitable_market/screens/Home/productdetailspage.dart';
import 'package:provider/provider.dart';

// Fruit model
class Fruit {
  final String name;
  final double price;
  final String imagePath;

  Fruit({required this.name, required this.price, required this.imagePath});
}

// Cart provider
class CartProvider with ChangeNotifier {
  List<Fruit> _cartItems = [];

  List<Fruit> get cartItems => _cartItems;

  void addToCart(Fruit fruit) {
    _cartItems.add(fruit);
    notifyListeners();
  }
}

// FruitPage
class FruitPage extends StatelessWidget {
  final List<Fruit> fruits = [
    Fruit(name: 'Apple', price: 1.0, imagePath: 'assets/Fruit/apple.jpeg'),
    Fruit(name: 'Banana', price: 0.5, imagePath: 'assets/Fruit/banana.jpeg'),
    Fruit(name: 'Orange', price: 0.75, imagePath: 'assets/Fruit/orange.jpeg'),
    Fruit(name: 'Mango', price: 1.2, imagePath: 'assets/Fruit/mango.jpeg'),
    Fruit(name: 'Grapes', price: 2.0, imagePath: 'assets/Fruit/grapes.jpeg'),
    // Add more fruits as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fruits'),
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
        itemCount: fruits.length,
        itemBuilder: (context, index) {
          final fruit = fruits[index];
          return _buildFruitCard(context, fruit);
        },
      ),
    );
  }

  Widget _buildFruitCard(BuildContext context, Fruit fruit) {
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
                image: AssetImage(fruit.imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              fruit.name,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Text(
            '\$${fruit.price.toStringAsFixed(2)}',
            style: TextStyle(color: Colors.green, fontSize: 14),
          ),
          SizedBox(height: 4),
          ElevatedButton(
            onPressed: () {
              // Navigate to ProductDetailPage when clicking "Add to Cart"
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(
                    product: {
                      'name': fruit.name,
                      'price': fruit.price,
                      'image': fruit.imagePath,
                      'description':
                          'This is a delicious ${fruit.name}.', // Example description
                    },
                    onAddToCart: (product) {
                      Provider.of<CartProvider>(context, listen: false)
                          .addToCart(Fruit(
                        name: product['name'],
                        price: product['price'],
                        imagePath: product['image'],
                      ));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${fruit.name} added to cart!')),
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
