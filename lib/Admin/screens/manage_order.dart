import 'package:flutter/material.dart';

class ManageOrderPage extends StatelessWidget {
  final List<Map<String, dynamic>> orders = [
    {
      'id': 1,
      'customerName': 'John Doe',
      'orderDetails': '2 Pizzas, 1 Coke',
      'status': 'Pending',
      'address': '123 Main St, Cityville',
    },
    {
      'id': 2,
      'customerName': 'Alex Smith',
      'orderDetails': '1 Burger, 1 Fries',
      'status': 'Pending',
      'address': '456 Elm St, Townsville',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Count accepted and pending orders
    int acceptedCount =
        orders.where((order) => order['status'] == 'Accepted').length;
    int pendingCount =
        orders.where((order) => order['status'] == 'Pending').length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Order'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Accepted Orders: $acceptedCount',
                    style: TextStyle(fontSize: 16)),
                Text('Total Pending Orders: $pendingCount',
                    style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return OrderCard(
                  order: orders[index],
                  onAccept: () {
                    _showMessage(
                        context, 'Order ${orders[index]['id']} accepted');
                    // Update order status to Accepted
                    orders[index]['status'] = 'Accepted';
                  },
                  onReject: () {
                    _showMessage(
                        context, 'Order ${orders[index]['id']} rejected');
                    // Update order status to Rejected
                    orders[index]['status'] = 'Rejected';
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const OrderCard({
    Key? key,
    required this.order,
    required this.onAccept,
    required this.onReject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            SizedBox(width: 16), // Space between image and text
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order ID: ${order['id']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text('Customer: ${order['customerName']}'),
                    Text('Address: ${order['address']}'),
                    Text('Details: ${order['orderDetails']}'),
                    Text('Status: ${order['status']}'),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: onAccept,
                  child: Text('Accept'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: onReject,
                  child: Text('Reject'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ManageOrderPage(),
  ));
}
