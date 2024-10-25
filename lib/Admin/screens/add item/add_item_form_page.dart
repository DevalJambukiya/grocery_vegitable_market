import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart'; // Required for kIsWeb

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
  Uint8List? _imageData; // Use Uint8List for image data
  final ImagePicker _picker = ImagePicker();
  List<String> _categories = []; // List to hold categories

  @override
  void initState() {
    super.initState();
    _fetchCategories(); // Fetch categories on init
  }

  Future<void> _fetchCategories() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    setState(() {
      _categories = snapshot.docs.map((doc) => doc['name'] as String).toList();
    });
  }

  Future<String?> _uploadImage() async {
    if (_imageData == null) return null; // Return null if no image is selected

    // Create a unique file name
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref =
        FirebaseStorage.instance.ref().child('item_images/$fileName');

    try {
      // Upload image as bytes (works for Web and Mobile)
      UploadTask uploadTask = ref.putData(_imageData!);
      await uploadTask;

      // Get the download URL
      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl; // Return the download URL
    } catch (e) {
      print('Error uploading image: $e');
      return null; // Return null on error
    }
  }

  Future<void> _submitForm() async {
    if (_nameController.text.isEmpty ||
        _stockController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _detailsController.text.isEmpty ||
        _selectedCategory == null ||
        _imageData == null) {
      return; // Add validation if necessary
    }

    // Upload the image and get the URL
    String? imageUrl = await _uploadImage();

    if (imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image upload failed. Please try again.')),
      );
      return;
    }

    final newItem = {
      'image': imageUrl,
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
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        // For Web, load the image as bytes
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageData = bytes;
        });
      } else {
        // For mobile, use the local file path
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageData = bytes;
        });
      }
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
              _buildImagePicker(),
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
      items: _categories.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Select Category',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      hint: Text('Select Category'),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0), // Rectangular shape
          border: Border.all(color: Colors.green),
        ),
        child: _imageData == null
            ? Center(child: Text('Tap to select an image'))
            : kIsWeb
                ? Image.memory(
                    _imageData!,
                    fit: BoxFit.cover,
                    width: 200,
                    height: 200,
                  )
                : Image.memory(
                    _imageData!,
                    fit: BoxFit.cover,
                    width: 200,
                    height: 200,
                  ),
      ),
    );
  }
}
