import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_vegitable_market/Admin/screens/add%20item/add_item_form_page.dart';
import 'package:grocery_vegitable_market/Admin/screens/add%20item/edit_item_page.dart';
import 'package:grocery_vegitable_market/Admin/screens/add%20item/item_card.dart';

class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final CollectionReference _itemsCollection =
      FirebaseFirestore.instance.collection('items');

  @override
  void initState() {
    super.initState();
  }

  Future<void> _deleteItem(String docId) async {
    final confirmation = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Item'),
        content: Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Cancel
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Confirm
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmation == true) {
      await _itemsCollection.doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item deleted successfully')),
      );
    }
  }

  Future<void> _addItem(Map<String, dynamic> newItem) async {
    await _itemsCollection.add(newItem);
  }

  Future<void> _editItem(String docId, Map<String, dynamic> updatedItem) async {
    await _itemsCollection.doc(docId).update(updatedItem);
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _itemsCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data!.docs;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final itemData = items[index];
                return ItemCard(
                  item: itemData.data() as Map<String, dynamic>,
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditItemPage(
                          item: itemData.data() as Map<String, dynamic>,
                          onEditItem: (updatedItem) {
                            _editItem(itemData.id, updatedItem);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  },
                  onDelete: () => _deleteItem(itemData.id),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
