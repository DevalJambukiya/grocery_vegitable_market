import 'package:flutter/material.dart';
import 'package:grocery_vegitable_market/screens/Home/productdetailspage.dart';

// Main entry point
void main() {
  runApp(MaterialApp(home: CartPage()));
}

// Cart Page
class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final List<CartItem> cartItems = [];
  final TextEditingController _addressController = TextEditingController();
  String _selectedPaymentMethod = 'Credit Card'; // Default payment method

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
      ),
      CartItem(
        name: "Banana",
        imagePath: "assets/Fruit/organic_bananas.jpeg",
        quantity: 1,
        price: 0.59,
      ),
      CartItem(
        name: "Ginger",
        imagePath: "assets/Vegitable/ginger.jpeg",
        quantity: 1,
        price: 0.79,
      ),
      CartItem(
        name: "Bell Pepper",
        imagePath: "assets/Vegitable/bell_pepper_red.jpeg",
        quantity: 1,
        price: 0.79,
      ),
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

  void _navigateToProductDetail(CartItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(
          product: {
            'name': item.name,
            'image': item.imagePath,
            'price': item.price,
            'description': 'A delicious ${item.name}.', // Example description
          },
          onAddToCart: (Map<String, dynamic> product) {
            setState(() {
              // Increment the quantity of the product in the cart
              cartItems
                  .firstWhere((cartItem) => cartItem.name == product['name'])
                  .quantity += 1;
            });
          },
        ),
      ),
    );
  }

  double get total {
    double total = 0.0;
    for (var item in cartItems) {
      total += item.totalPrice;
    }
    return total;
  }

  void _showCheckoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Checkout"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _addressController,
                decoration: InputDecoration(labelText: "Delivery Address"),
              ),
              DropdownButton<String>(
                value: _selectedPaymentMethod,
                items: <String>['Credit Card', 'PayPal', 'Cash on Delivery']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPaymentMethod = newValue!;
                  });
                },
              ),
              SizedBox(height: 10),
              Text("Total: \$${total.toStringAsFixed(2)}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_addressController.text.isNotEmpty) {
                  Navigator.of(context).pop();
                  _showOrderConfirmationDialog();
                  _clearCart(); // Clear the cart after checkout
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter your address.')),
                  );
                }
              },
              child: Text("Place Order"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _showOrderConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Order Successful"),
          content: Text("Your order has been placed successfully!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _clearCart() {
    setState(() {
      cartItems.clear();
      _addressController.clear(); // Clear the address field
      _selectedPaymentMethod = 'Credit Card'; // Reset to default payment method
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cart has been cleared!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Page'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 243, 248, 244),
      ),
      body: cartItems.isEmpty
          ? _buildEmptyCart()
          : ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _navigateToProductDetail(cartItems[index]),
                  child: _buildCartItem(cartItems[index], index),
                );
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
          icon: Icon(Icons.remove, color: Colors.red),
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
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          ElevatedButton(
            onPressed: () {
              if (cartItems.isNotEmpty) {
                _showCheckoutDialog();
              }
            },
            child: Text('Checkout'),
          ),
        ],
      ),
    );
  }
}

// CartItem Class
class CartItem {
  final String name;
  final String imagePath;
  int quantity;
  final double price;

  CartItem({
    required this.name,
    required this.imagePath,
    required this.quantity,
    required this.price,
  });

  double get totalPrice => price * quantity;
}
