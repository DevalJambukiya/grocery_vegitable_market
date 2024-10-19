import 'package:flutter/material.dart';
import 'package:grocery_vegitable_market/Admin/screens/add%20item/add_item_form_page.dart';
import 'package:grocery_vegitable_market/Admin/screens/add%20item/edit_item_page.dart';
import 'package:grocery_vegitable_market/Admin/screens/add%20item/item_card.dart';

class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final List<Map<String, dynamic>> items = [
    {
      'image': 'assets/Vegitable/bell_pepper_red.jpeg',
      'name': 'Bell Pepper Red',
      'stock': 10,
      'price': 15.99,
      'details': 'Fresh red bell pepper',
      'category': 'Vegetables',
    },
    {
      'image': 'assets/Fruit/banana.jpeg',
      'name': 'Organic Bananas',
      'stock': 20,
      'price': 15.99,
      'details': 'High-quality organic bananas',
      'category': 'Fruits',
    },
    {
      'image': 'assets/Vegitable/ginger.jpeg',
      'name': 'Ginger',
      'stock': 15,
      'price': 15.99,
      'details': 'Fresh ginger root',
      'category': 'Vegetables',
    },
    {
      'image': 'assets/Beverages/pepsi.jpeg',
      'name': 'Pepsi Can',
      'stock': 30,
      'price': 15.99,
      'details': 'Refreshing Pepsi drink',
      'category': 'Beverages',
    },
    {
      'image': 'assets/Beverages/apple_juice.jpeg',
      'name': 'Apple Juice',
      'stock': 25,
      'price': 15.99,
      'details': 'Natural apple juice',
      'category': 'Beverages',
    },
  ];

  void _deleteItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  void _addItem(Map<String, dynamic> newItem) {
    setState(() {
      items.add(newItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(child: Text('Add Items')),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddItemFormPage(onAddItem: _addItem),
                  ),
                );
              },
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
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ItemCard(
              item: items[index],
              onEdit: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditItemPage(item: items[index]),
                  ),
                );
              },
              onDelete: () => _deleteItem(index),
            );
          },
        ),
      ),
    );
  }
}
