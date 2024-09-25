import 'package:flutter/material.dart';

class PaymentMethodsPage extends StatefulWidget {
  @override
  _PaymentMethodsPageState createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  String? _selectedPaymentMethod;

  // List of payment methods
  final List<String> _paymentMethods = [
    'Credit/Debit Card',
    'Online Payment (PayPal, Google Pay)',
    'Cash on Delivery',
    'Bank Transfer',
  ];

  // Function to handle selection of payment method
  void _handlePaymentMethodChange(String? value) {
    setState(() {
      _selectedPaymentMethod = value;
    });
  }

  // Function to handle confirm button click
  void _confirmPaymentMethod() {
    if (_selectedPaymentMethod != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Payment method selected: $_selectedPaymentMethod")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a payment method")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Methods"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select a payment method:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Display list of payment methods with radio buttons
            Column(
              children: _paymentMethods.map((method) {
                return RadioListTile<String>(
                  title: Text(method),
                  value: method,
                  groupValue: _selectedPaymentMethod,
                  onChanged: _handlePaymentMethodChange,
                );
              }).toList(),
            ),
            SizedBox(height: 20),

            // Confirm Button
            ElevatedButton(
              onPressed: _confirmPaymentMethod,
              child: Text("Confirm Payment Method"),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PaymentMethodsPage(),
  ));
}
