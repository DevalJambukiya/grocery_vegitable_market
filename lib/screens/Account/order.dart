import 'package:flutter/material.dart';

// Sample order model
class Order {
  final String orderId;
  final String productName;
  final double amount;
  final DateTime orderDate;

  Order(
      {required this.orderId,
      required this.productName,
      required this.amount,
      required this.orderDate});
}

// Sample list of orders
List<Order> mockOrders = [
  Order(
      orderId: "123",
      productName: "Apple",
      amount: 5.99,
      orderDate: DateTime.now().subtract(Duration(days: 2))),
  Order(
      orderId: "124",
      productName: "Banana",
      amount: 2.50,
      orderDate: DateTime.now().subtract(Duration(days: 5))),
  Order(
      orderId: "125",
      productName: "Orange",
      amount: 4.75,
      orderDate: DateTime.now().subtract(Duration(days: 7))),
];

class OrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
      ),
      body: ListView.builder(
        itemCount: mockOrders.length,
        itemBuilder: (context, index) {
          final order = mockOrders[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(order.productName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Order ID: ${order.orderId}"),
                  Text("Amount: \$${order.amount.toStringAsFixed(2)}"),
                  Text("Date: ${order.orderDate.toLocal()}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: OrdersPage(),
  ));
}
