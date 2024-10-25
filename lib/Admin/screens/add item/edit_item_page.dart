import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_vegitable_market/Admin/screens/Add_item.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class EditItemPage extends StatefulWidget {
  final Map<String, dynamic> item;
  final Function(Map<String, dynamic>) onEditItem;

  const EditItemPage({Key? key, required this.item, required this.onEditItem})
      : super(key: key);

  @override
  _EditItemPageState createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  late TextEditingController _nameController;
  late TextEditingController _stockController;
  late TextEditingController _priceController;
  late TextEditingController _detailsController;
  String? _selectedCategory;
  Uint8List? _imageData;
  final ImagePicker _picker = ImagePicker();
  List<String> _categories = []; // List to hold categories

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item['name']);
    _stockController =
        TextEditingController(text: widget.item['stock'].toString());
    _priceController =
        TextEditingController(text: widget.item['price'].toString());
    _detailsController = TextEditingController(text: widget.item['details']);
    _selectedCategory = widget.item['category'];
    _fetchCategories(); // Fetch categories on init
  }

  Future<void> _fetchCategories() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    setState(() {
      _categories = snapshot.docs.map((doc) => doc['name'] as String).toList();
    });
  }

  void _saveItem() {
    final updatedItem = {
      'name': _nameController.text,
      'stock': int.tryParse(_stockController.text),
      'price': double.tryParse(_priceController.text),
      'details': _detailsController.text,
      'category': _selectedCategory,
    };

    // Call the provided callback function to handle the updated item.
    widget.onEditItem(updatedItem);

    // Show confirmation dialog
    _showConfirmationDialog();
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Changes saved successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Navigate back to AddItemPage
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => AddItemPage()),
                );
              },
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
      appBar: AppBar(title: Text('Edit Item')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(_nameController, 'Item Name', Icons.label),
              SizedBox(height: 16.0),
              _buildTextField(
                  _stockController, 'Stock', Icons.store, TextInputType.number),
              SizedBox(height: 16.0),
              _buildTextField(_priceController, 'Price', Icons.monetization_on,
                  TextInputType.number),
              SizedBox(height: 16.0),
              _buildTextField(
                  _detailsController, 'Product Details', Icons.info),
              SizedBox(height: 16.0),
              _buildCategoryDropdown(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _saveItem();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      [TextInputType keyboardType = TextInputType.text]) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      keyboardType: keyboardType,
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      onChanged: (String? newValue) {
        setState(() {
          _selectedCategory = newValue;
        });
      },
      items: _categories.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Select Category',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      hint: Text('Select Category'),
    );
  }
}
