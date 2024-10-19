import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: DeliveryBoyDetailsPage(),
  ));
}

class DeliveryBoyDetailsPage extends StatefulWidget {
  @override
  _DeliveryBoyDetailsPageState createState() => _DeliveryBoyDetailsPageState();
}

class _DeliveryBoyDetailsPageState extends State<DeliveryBoyDetailsPage> {
  List<Map<String, dynamic>> deliveryBoys = [
    {
      'image': 'assets/Logo/carrot.png',
      'name': 'ABC',
      'phone': '1234567890',
      'email': 'abc@gmail.com',
      'address': '123 Main Street, City',
      'vehicle': {
        'type': 'Bike',
        'model': 'Yamaha FZ',
        'number': 'ABC-1234',
      },
    },
    {
      'image': 'assets/Logo/carrot.png',
      'name': 'XYZ',
      'phone': '1234567890',
      'email': 'xyz@gmail.com',
      'address': '456 Elm Street, Town',
      'vehicle': {
        'type': 'Scooter',
        'model': 'Honda Activa',
        'number': 'XYZ-5678',
      },
    },
    {
      'image': 'assets/Logo/carrot.png',
      'name': 'LMN',
      'phone': '1234567890',
      'email': 'lmn@gmail.com',
      'address': '789 Oak Avenue, Village',
      'vehicle': {
        'type': 'Car',
        'model': 'Toyota Prius',
        'number': 'LMN-3456',
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(child: Text('Delivery Boy Details')),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddDeliveryBoyPage(
                      onAdd: (newDeliveryBoy) {
                        setState(() {
                          deliveryBoys.add(newDeliveryBoy);
                        });
                      },
                    ),
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
            horizontal: MediaQuery.of(context).size.width * 0.02),
        child: ListView.builder(
          itemCount: deliveryBoys.length,
          itemBuilder: (context, index) {
            return DeliveryBoyCard(
              deliveryBoy: deliveryBoys[index],
              onEdit: (updatedDeliveryBoy) {
                setState(() {
                  deliveryBoys[index] = updatedDeliveryBoy;
                });
              },
              onDelete: () {
                _showDeleteConfirmationDialog(index);
              },
            );
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this delivery boy?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                setState(() {
                  deliveryBoys.removeAt(index); // Delete the delivery boy
                });
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }
}

class DeliveryBoyCard extends StatelessWidget {
  final Map<String, dynamic> deliveryBoy;
  final Function(Map<String, dynamic>) onEdit;
  final Function() onDelete;

  const DeliveryBoyCard({
    Key? key,
    required this.deliveryBoy,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Card(
        elevation: 2,
        child: ExpansionTile(
          leading: SizedBox(
            width: 50,
            height: 50,
            // Uncomment to show the delivery boy's image
            // child: Image.asset(
            //   deliveryBoy['image'],
            //   fit: BoxFit.cover,
            // ),
          ),
          title: Text(
            deliveryBoy['name'],
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(deliveryBoy['phone']),
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email: ${deliveryBoy['email']}'),
                  SizedBox(height: 8),
                  Text('Address: ${deliveryBoy['address']}'),
                  SizedBox(height: 8),
                  Text('Phone: ${deliveryBoy['phone']}'),
                  SizedBox(height: 8),
                  Text('Vehicle Type: ${deliveryBoy['vehicle']['type']}'),
                  Text('Model: ${deliveryBoy['vehicle']['model']}'),
                  Text('Vehicle Number: ${deliveryBoy['vehicle']['number']}'),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditDeliveryBoyPage(
                          deliveryBoy: deliveryBoy,
                        ),
                      ),
                    ).then((updatedDeliveryBoy) {
                      if (updatedDeliveryBoy != null) {
                        onEdit(updatedDeliveryBoy);
                      }
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    onDelete();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddDeliveryBoyPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _vehicleTypeController = TextEditingController();
  final TextEditingController _vehicleModelController = TextEditingController();
  final TextEditingController _vehicleNumberController =
      TextEditingController();
  final Function(Map<String, dynamic>) onAdd;

  AddDeliveryBoyPage({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Delivery Boy'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(_nameController, 'Name'),
              _buildTextField(_phoneController, 'Phone'),
              _buildTextField(_emailController, 'Email'),
              _buildTextField(_addressController, 'Address'),
              _buildTextField(_vehicleTypeController, 'Vehicle Type'),
              _buildTextField(_vehicleModelController, 'Vehicle Model'),
              _buildTextField(_vehicleNumberController, 'Vehicle Number'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final newDeliveryBoy = {
                    'name': _nameController.text,
                    'phone': _phoneController.text,
                    'email': _emailController.text,
                    'address': _addressController.text,
                    'vehicle': {
                      'type': _vehicleTypeController.text,
                      'model': _vehicleModelController.text,
                      'number': _vehicleNumberController.text,
                    },
                  };
                  onAdd(newDeliveryBoy); // Pass new delivery boy back
                  Navigator.pop(context);
                },
                child: Text('Add Delivery Boy'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

class EditDeliveryBoyPage extends StatelessWidget {
  final Map<String, dynamic> deliveryBoy;
  final TextEditingController _nameController;
  final TextEditingController _phoneController;
  final TextEditingController _emailController;
  final TextEditingController _addressController;
  final TextEditingController _vehicleTypeController;
  final TextEditingController _vehicleModelController;
  final TextEditingController _vehicleNumberController;

  EditDeliveryBoyPage({required this.deliveryBoy})
      : _nameController = TextEditingController(text: deliveryBoy['name']),
        _phoneController = TextEditingController(text: deliveryBoy['phone']),
        _emailController = TextEditingController(text: deliveryBoy['email']),
        _addressController =
            TextEditingController(text: deliveryBoy['address']),
        _vehicleTypeController =
            TextEditingController(text: deliveryBoy['vehicle']['type']),
        _vehicleModelController =
            TextEditingController(text: deliveryBoy['vehicle']['model']),
        _vehicleNumberController =
            TextEditingController(text: deliveryBoy['vehicle']['number']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Delivery Boy'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(_nameController, 'Name'),
              _buildTextField(_phoneController, 'Phone'),
              _buildTextField(_emailController, 'Email'),
              _buildTextField(_addressController, 'Address'),
              _buildTextField(_vehicleTypeController, 'Vehicle Type'),
              _buildTextField(_vehicleModelController, 'Vehicle Model'),
              _buildTextField(_vehicleNumberController, 'Vehicle Number'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final updatedDeliveryBoy = {
                    'name': _nameController.text,
                    'phone': _phoneController.text,
                    'email': _emailController.text,
                    'address': _addressController.text,
                    'vehicle': {
                      'type': _vehicleTypeController.text,
                      'model': _vehicleModelController.text,
                      'number': _vehicleNumberController.text,
                    },
                  };
                  Navigator.pop(context, updatedDeliveryBoy);
                },
                child: Text('Update Delivery Boy'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
