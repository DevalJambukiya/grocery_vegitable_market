import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: CartPage()));
}

// Class representing an item in the cart
class CartItem {
  final String name;
  final String imagePath;
  int quantity;
  final double price;
  final int stock; // Stock available for the item

  CartItem({
    required this.name,
    required this.imagePath,
    required this.quantity,
    required this.price,
    required this.stock,
  });

  double get totalPrice => price * quantity;
}

// Cart Page
class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final List<CartItem> cartItems =
      []; // Fixed variable name and added semicolon

  @override
  void initState() {
    super.initState();
    // Add sample products to the cart
    cartItems.addAll([
      CartItem(
          name: "Apple",
          imagePath: "assets/images/apple.png",
          quantity: 1,
          price: 0.99,
          stock: 100),
      CartItem(
          name: "Banana",
          imagePath: "assets/images/banana.png",
          quantity: 1,
          price: 0.59,
          stock: 150),
      CartItem(
          name: "Orange",
          imagePath: "assets/images/orange.png",
          quantity: 1,
          price: 0.79,
          stock: 80),
      CartItem(
          name: "Strawberry",
          imagePath: "assets/images/strawberry.png",
          quantity: 1,
          price: 2.49,
          stock: 50),
      CartItem(
          name: "Grapes",
          imagePath: "assets/images/grapes.png",
          quantity: 1,
          price: 3.99,
          stock: 30),
      CartItem(
          name: "Watermelon",
          imagePath: "assets/images/watermelon.png",
          quantity: 1,
          price: 4.99,
          stock: 20),
    ]);
  }

  void _updateQuantity(int index, int newQuantity) {
    setState(() {
      if (newQuantity <= 0) {
        _confirmDelete(index);
      } else {
        cartItems[index].quantity = newQuantity;
      }
    });
  }

  void _clearCart() {
    setState(() {
      cartItems.clear();
    });
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Remove Item"),
          content: Text("Are you sure you want to remove this item?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Remove"),
              onPressed: () {
                setState(() {
                  cartItems.removeAt(index);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  double get total => cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Page'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 243, 248, 244),
      ),
      body: cartItems.isEmpty // Fixed variable name
          ? _buildEmptyCart()
          : Scrollbar(
              thumbVisibility: true,
              child: ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  return _buildCartItem(cartItems[index], index);
                },
              ),
            ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text('Your cart is empty.',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item, int index) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(item.imagePath, height: 80, fit: BoxFit.cover),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  SizedBox(height: 6),
                  Text('\$${item.price.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700])),
                  SizedBox(height: 8),
                  _buildQuantityControls(item, index),
                  Text('In Stock: ${item.stock}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic)),
                ],
              ),
            ),
            Text('\$${item.totalPrice.toStringAsFixed(2)}',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityControls(CartItem item, int index) {
    return Row(
      children: [
        IconButton(
          onPressed: () => _updateQuantity(index, item.quantity - 1),
          icon: Icon(Icons.remove, color: Colors.green),
        ),
        Text('${item.quantity}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        IconButton(
          onPressed: () => _updateQuantity(index, item.quantity + 1),
          icon: Icon(Icons.add, color: Colors.green),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 6,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Total: \$${total.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ElevatedButton(
            onPressed: () {
              // Handle checkout action
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              backgroundColor: Colors.green,
            ),
            child: Text('Checkout',
                style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
