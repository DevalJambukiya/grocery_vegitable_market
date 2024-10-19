import 'package:flutter/material.dart';
import 'package:grocery_vegitable_market/Admin/screens/add%20category/edit_category_page.dart';

class AddCategoryPage extends StatefulWidget {
  @override
  _AddCategoryPageState createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  List<Map<String, dynamic>> categories = [
    {'name': 'Vegetables'},
    {'name': 'Fruits'},
    {'name': 'Beverages'},
    {'name': 'Snacks'},
    {'name': 'Dairy'},
  ];

  void _addCategory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCategoryPage(
          onSave: (newCategory) {
            setState(() {
              categories.add({'name': newCategory});
            });
          },
        ),
      ),
    );
  }

  void _deleteCategory(int index) {
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
              onPressed: () {
                setState(() {
                  categories.removeAt(index); // Delete the category
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
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
            Expanded(child: Text('Add Category')),
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
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return CategoryCard(
              category: categories[index],
              onDelete: () => _deleteCategory(index),
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
          ),
        ),
      ),
    );
  }
}
