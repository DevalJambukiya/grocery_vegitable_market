import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddItemFormPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddItem;

  const AddItemFormPage({Key? key, required this.onAddItem}) : super(key: key);

  @override
  _AddItemFormPageState createState() => _AddItemFormPageState();
}

class _AddItemFormPageState extends State<AddItemFormPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  String? _selectedCategory;
  String? _imagePath; // Variable to hold the image path

  final ImagePicker _picker = ImagePicker();

  void _submitForm() {
    if (_nameController.text.isEmpty ||
        _stockController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _detailsController.text.isEmpty ||
        _selectedCategory == null ||
        _imagePath == null) {
      return; // Add validation if necessary
    }

    final newItem = {
      'image': _imagePath!,
      'name': _nameController.text,
      'stock': int.parse(_stockController.text),
      'price': double.parse(_priceController.text),
      'details': _detailsController.text,
      'category': _selectedCategory,
    };

    widget.onAddItem(newItem);
    Navigator.pop(context);
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery); // Updated method
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path; // Store the image path
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Item'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildImagePicker(), // Move the image picker to the top
              SizedBox(height: 16.0),
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
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text('Add Item'),
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.green),
        ),
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
      items: <String>['Vegetables', 'Fruits', 'Beverages']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Select Category',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.green),
        ),
      ),
      hint: Text('Select Category'),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.green),
            ),
            child: _imagePath == null
                ? Center(child: Text('Tap to select an image'))
                : Image.file(File(_imagePath!), fit: BoxFit.cover),
          ),
        ),
        SizedBox(height: 8.0),
      ],
    );
  }
}
