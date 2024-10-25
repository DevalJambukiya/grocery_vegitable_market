import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditCategoryPage extends StatelessWidget {
  final String? category;
  final Function(String) onSave;

  const EditCategoryPage({Key? key, this.category, required this.onSave})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller =
        TextEditingController(text: category);

    // Function to show a popup dialog
    void showPopupDialog(BuildContext context, String title, String message,
        {bool navigateBack = false}) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  if (navigateBack) {
                    // Clear the text field and navigate back
                    _controller.clear(); // Clear the text field
                    Navigator.of(context).pushReplacementNamed(
                        'grocery_vegitable_market/Admin/Add_category'); // Ensure this route name matches your route
                  }
                },
              ),
            ],
          );
        },
      );
    }

    Future<bool> categoryExists(String categoryName) async {
      CollectionReference categories =
          FirebaseFirestore.instance.collection('categories');

      final querySnapshot =
          await categories.where('name', isEqualTo: categoryName).get();

      return querySnapshot.docs.isNotEmpty;
    }

    Future<void> saveCategoryToFirestore(String categoryName) async {
      CollectionReference categories =
          FirebaseFirestore.instance.collection('categories');

      try {
        // Check if the category already exists
        if (await categoryExists(categoryName)) {
          showPopupDialog(context, 'Error', 'This category is already added!');
          return;
        }

        await categories.add({
          'name': categoryName,
          'created_at': FieldValue.serverTimestamp(),
        });

        // Show success dialog and navigate back
        showPopupDialog(context, 'Success', 'Category saved successfully!',
            navigateBack: true);
        onSave(categoryName); // Call the onSave callback
      } catch (e) {
        // Show error dialog
        showPopupDialog(context, 'Error', 'Failed to save category: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(category == null ? 'Add Category' : 'Edit Category'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              category == null ? 'Create New Category' : 'Update Category',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Category Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.green),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.greenAccent),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ),
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_controller.text.isNotEmpty) {
                  await saveCategoryToFirestore(_controller.text);
                } else {
                  // Show dialog if the field is empty
                  showPopupDialog(
                      context, 'Error', 'Please enter a category name.');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
