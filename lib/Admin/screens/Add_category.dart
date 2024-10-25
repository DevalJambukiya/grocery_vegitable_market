import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_vegitable_market/Admin/screens/add%20category/edit_category_page.dart';

class AddCategoryPage extends StatefulWidget {
  @override
  _AddCategoryPageState createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  // List to hold the categories fetched from Firestore
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  // Fetch categories from Firestore
  void fetchCategories() async {
    CollectionReference categoryCollection =
        FirebaseFirestore.instance.collection('categories');

    final querySnapshot = await categoryCollection.get();

    setState(() {
      categories = querySnapshot.docs
          .map((doc) => {'id': doc.id, 'name': doc['name']})
          .toList();
    });
  }

  void _addCategory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCategoryPage(
          onSave: (newCategory) {
            setState(() {
              // Add new category to the local list
              categories.add({'name': newCategory});
            });
          },
        ),
      ),
    );
  }

  void _deleteCategory(String categoryId, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this category?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Delete the category from Firestore
                try {
                  await FirebaseFirestore.instance
                      .collection('categories')
                      .doc(categoryId)
                      .delete();

                  setState(() {
                    categories.removeAt(index); // Remove from local list
                  });

                  Navigator.of(context).pop(); // Close the dialog

                  // Show success dialog
                  _showSuccessDialog(context, 'Category deleted successfully!');
                } catch (e) {
                  // Handle errors here (e.g., show an error message)
                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete category: $e')),
                  );
                }
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Function to show a success dialog
  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the success dialog
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
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(child: Text('Categories')),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: _addCategory,
            ),
          ],
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.02,
        ),
        child: categories.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return CategoryCard(
                    category: categories[index],
                    onDelete: () =>
                        _deleteCategory(categories[index]['id'], index),
                  );
                },
              ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Map<String, dynamic> category;
  final VoidCallback onDelete;

  const CategoryCard({
    Key? key,
    required this.category,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Card(
        elevation: 2,
        child: ListTile(
          title: Text(
            category['name'],
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: onDelete,
            color: Colors.red, // Optional: Change color for visibility
          ),
        ),
      ),
    );
  }
}
