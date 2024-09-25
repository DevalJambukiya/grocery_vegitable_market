import 'package:flutter/material.dart';

class AllProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Product'),
        backgroundColor: Colors.green,
      ),
      body: Center(child: Text('This is the All Product page')),
    );
  }
}
