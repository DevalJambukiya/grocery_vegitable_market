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
  final int stock;

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
  final List<CartItem> cartItems = [];

  @override
  void initState() {
    super.initState();
    // Add sample products to the cart
    cartItems.addAll([
      CartItem(
          name: "Apple",
          imagePath: "assets/Fruit/red_apple.jpeg",
          quantity: 1,
          price: 0.99,
          stock: 100),
      CartItem(
          name: "Banana",
          imagePath: "assets/Fruit/organic_bananas.jpeg", // Fixed typo
          quantity: 1,
          price: 0.59,
          stock: 150),
      CartItem(
          name: "Ginger",
          imagePath: "assets/Vegitable/ginger.jpeg",
          quantity: 1,
          price: 0.79,
          stock: 80),
      CartItem(
          name: "Ginger",
          imagePath: "assets/Vegitable/bell_pepper_red.jpeg",
          quantity: 1,
          price: 0.79,
          stock: 80),
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

  void _showCheckoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Checkout'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select Address:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  items: ['Home', 'Office', 'Other'].map((String address) {
                    return DropdownMenuItem<String>(
                      value: address,
                      child: Text(address),
                    );
                  }).toList(),
                  onChanged: (value) {},
                  hint: Text('Select Address'),
                ),
                SizedBox(height: 16),
                Text('Payment Total: \$${total.toStringAsFixed(2)}',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle place order logic here
                Navigator.of(context).pop();
                _showOrderConfirmation();
              },
              child: Text('Place Order'),
            ),
          ],
        );
      },
    );
  }

  void _showOrderConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Order Placed'),
          content: Text('Your order has been successfully placed!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Page'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: cartItems.isEmpty
          ? _buildEmptyCart()
          : ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return _buildCartItem(cartItems[index], index);
              },
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
            onPressed:
                _showCheckoutDialog, // Show checkout dialog on button click
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
