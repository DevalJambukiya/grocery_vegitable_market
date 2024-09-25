import 'package:flutter/material.dart';

class DeliveryAddressPage extends StatefulWidget {
  @override
  _DeliveryAddressPageState createState() => _DeliveryAddressPageState();
}

class _DeliveryAddressPageState extends State<DeliveryAddressPage> {
  final TextEditingController _addressController = TextEditingController();
  String _savedAddress = '';

  // Function to handle form submission
  void _submitAddress() {
    if (_addressController.text.isNotEmpty) {
      setState(() {
        _savedAddress = _addressController.text;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Address saved successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter an address")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delivery Address"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Address Input
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: "Enter Delivery Address",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Save Button
            ElevatedButton(
              onPressed: _submitAddress,
              child: Text("Save Address"),
            ),
            SizedBox(height: 20),

            // Display saved address
            if (_savedAddress.isNotEmpty)
              Text(
                "Saved Address: $_savedAddress",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DeliveryAddressPage(),
  ));
}
