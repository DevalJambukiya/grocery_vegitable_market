import 'package:flutter/material.dart';

class BannerDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Banner Details'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Text(
          'Details about the selected banner',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
