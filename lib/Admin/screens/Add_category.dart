import 'package:flutter/material.dart';

class AddCategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Category'),
        backgroundColor: Colors.green,
      ),
      body: Center(child: Text('This is the Add Category page')),
    );
  }
}
