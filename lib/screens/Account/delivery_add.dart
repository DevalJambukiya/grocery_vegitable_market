import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: DeliveryAddressPage(),
  ));
}

class DeliveryAddressPage extends StatefulWidget {
  @override
  _DeliveryAddressPageState createState() => _DeliveryAddressPageState();
}

class _DeliveryAddressPageState extends State<DeliveryAddressPage> {
  final TextEditingController _addressController = TextEditingController();
  String _savedAddress = '';

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

  void _editAddress() async {
    // Initialize the controller with the current saved address
    _addressController.text = _savedAddress;

    final updatedAddress = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditAddressPage(addressController: _addressController),
      ),
    );

    if (updatedAddress != null && updatedAddress is String) {
      setState(() {
        _savedAddress = updatedAddress;
      });
    }
  }

  void _deleteAddress() {
    setState(() {
      _savedAddress = '';
      _addressController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Address deleted successfully!")),
    );
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

            // Edit Button
            if (_savedAddress.isNotEmpty)
              ElevatedButton(
                onPressed: _editAddress,
                child: Text("Edit Address"),
              ),
            SizedBox(height: 20),

            // Delete Button
            if (_savedAddress.isNotEmpty)
              ElevatedButton(
                onPressed: _deleteAddress,
                child: Text("Delete Address"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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

class EditAddressPage extends StatelessWidget {
  final TextEditingController addressController;

  EditAddressPage({required this.addressController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Address"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: "Enter Delivery Address",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, addressController.text);
              },
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
