import 'package:flutter/material.dart';

class AddItemPage extends StatelessWidget {
  final List<Map<String, dynamic>> items = [
    {
      'image': 'assets/Vegitable/bell_pepper_red.jpeg',
      'name': 'Bell Pepper Red',
      'price': 15.99,
    },
    {
      'image': 'assets/Fruit/banana.jpeg',
      'name': 'Organic Bananas',
      'price': 15.99,
    },
    {
      'image': 'assets/Vegitable/ginger.jpeg',
      'name': 'Ginger',
      'price': 15.99,
    },
    {
      'image': 'assets/Beverages/pepsi.jpeg',
      'name': 'Pepsi Can',
      'price': 15.99,
    },
    {
      'image': 'assets/Beverages/apple_juice.jpeg',
      'name': 'Apple Juice',
      'price': 15.99,
    },
  ];

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
                // Add action to add a new item
              },
            ),
          ],
        ),
        backgroundColor: Colors.green, // AppBar background color
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width *
                0.02), // Dynamic horizontal padding
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ItemCard(item: items[index]);
          },
        ),
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const ItemCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Card(
        elevation: 2,
        child: ListTile(
          leading: SizedBox(
            width: 50, // Fixed width for the image
            height: 50, // Fixed height for the image
            child: Image.asset(
              item['image'],
              fit: BoxFit.cover, // Ensure the image fits within the box
            ),
          ),
          title: Flexible(
            child: Text(
              item['name'],
              overflow: TextOverflow.ellipsis, // Prevent overflow with ellipsis
            ),
          ),
          subtitle: Text('WW-DR-GR-XS001'),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\$${item['price'].toStringAsFixed(2)}'),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Add edit functionality
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Add delete functionality
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
