import 'package:flutter/material.dart';

class ManageOrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Order'),
        backgroundColor: Colors.green,
      ),
      body: Center(child: Text('This is the Manage Order page')),
    );
  }
}
