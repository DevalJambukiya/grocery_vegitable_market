import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: DeliveryBoyDetailsPage(),
  ));
}

class DeliveryBoyDetailsPage extends StatefulWidget {
  @override
  _DeliveryBoyDetailsPageState createState() => _DeliveryBoyDetailsPageState();
}

class _DeliveryBoyDetailsPageState extends State<DeliveryBoyDetailsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> deliveryBoys = [];

  @override
  void initState() {
    super.initState();
    _loadDeliveryBoys();
  }

  Future<void> _loadDeliveryBoys() async {
    final snapshot = await _firestore.collection('delivery_boydetails').get();
    setState(() {
      deliveryBoys = snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    });
  }

  Future<void> _addDeliveryBoy(Map<String, dynamic> newDeliveryBoy) async {
    await _firestore.collection('delivery_boydetails').add(newDeliveryBoy);
    _showSnackBar('Delivery boy added successfully!');
    _loadDeliveryBoys(); // Refresh the list
  }

  Future<void> _updateDeliveryBoy(
      String id, Map<String, dynamic> updatedDeliveryBoy) async {
    await _firestore
        .collection('delivery_boydetails')
        .doc(id)
        .update(updatedDeliveryBoy);
    _showSnackBar('Delivery boy updated successfully!');
    _loadDeliveryBoys(); // Refresh the list
  }

  Future<void> _deleteDeliveryBoy(String id) async {
    await _firestore.collection('delivery_boydetails').doc(id).delete();
    _showSnackBar('Delivery boy deleted successfully!');
    _loadDeliveryBoys(); // Refresh the list
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

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
                        _addDeliveryBoy(newDeliveryBoy);
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
              onDelete: () {
                _showDeleteConfirmationDialog(deliveryBoys[index]['id']);
              },
              onEdit: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditDeliveryBoyPage(
                      deliveryBoy: deliveryBoys[index],
                      onUpdate: (updatedDeliveryBoy) {
                        _updateDeliveryBoy(
                            deliveryBoys[index]['id'], updatedDeliveryBoy);
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(String id) {
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
                _deleteDeliveryBoy(id); // Delete the delivery boy
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
  final Function() onDelete;
  final Function() onEdit;

  const DeliveryBoyCard({
    Key? key,
    required this.deliveryBoy,
    required this.onDelete,
    required this.onEdit,
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
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                deliveryBoy['image'] ?? 'https://via.placeholder.com/150',
              ),
              child: deliveryBoy['image'] == null
                  ? Icon(Icons.camera_alt, size: 30, color: Colors.grey)
                  : null,
            ),
          ),
          title: Text(
            deliveryBoy['name'] ?? 'Unknown',
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(deliveryBoy['phone'] ?? ''),
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email: ${deliveryBoy['email'] ?? 'N/A'}'),
                  SizedBox(height: 8),
                  Text('Address: ${deliveryBoy['address'] ?? 'N/A'}'),
                  SizedBox(height: 8),
                  Text('Phone: ${deliveryBoy['phone'] ?? 'N/A'}'),
                  SizedBox(height: 8),
                  Text(
                      'Vehicle Type: ${deliveryBoy['vehicle']['type'] ?? 'N/A'}'),
                  Text('Model: ${deliveryBoy['vehicle']['model'] ?? 'N/A'}'),
                  Text(
                      'Vehicle Number: ${deliveryBoy['vehicle']['number'] ?? 'N/A'}'),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddDeliveryBoyPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;

  AddDeliveryBoyPage({required this.onAdd});

  @override
  _AddDeliveryBoyPageState createState() => _AddDeliveryBoyPageState();
}

class _AddDeliveryBoyPageState extends State<AddDeliveryBoyPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _vehicleTypeController = TextEditingController();
  final TextEditingController _vehicleModelController = TextEditingController();
  final TextEditingController _vehicleNumberController =
      TextEditingController();
  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

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
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : NetworkImage('https://via.placeholder.com/150')
                          as ImageProvider,
                  child: _imageFile == null
                      ? Icon(Icons.camera_alt, size: 50, color: Colors.grey)
                      : null,
                ),
              ),
              SizedBox(height: 20),
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
                    'image': _imageFile != null
                        ? _imageFile!.path // Use the path for now
                        : 'https://via.placeholder.com/150',
                  };
                  widget.onAdd(newDeliveryBoy);
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

class EditDeliveryBoyPage extends StatefulWidget {
  final Map<String, dynamic> deliveryBoy;
  final Function(Map<String, dynamic>) onUpdate;

  EditDeliveryBoyPage({required this.deliveryBoy, required this.onUpdate});

  @override
  _EditDeliveryBoyPageState createState() => _EditDeliveryBoyPageState();
}

class _EditDeliveryBoyPageState extends State<EditDeliveryBoyPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _vehicleTypeController = TextEditingController();
  final TextEditingController _vehicleModelController = TextEditingController();
  final TextEditingController _vehicleNumberController =
      TextEditingController();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    // Pre-fill the text fields with existing data
    _nameController.text = widget.deliveryBoy['name'] ?? '';
    _phoneController.text = widget.deliveryBoy['phone'] ?? '';
    _emailController.text = widget.deliveryBoy['email'] ?? '';
    _addressController.text = widget.deliveryBoy['address'] ?? '';
    _vehicleTypeController.text = widget.deliveryBoy['vehicle']['type'] ?? '';
    _vehicleModelController.text = widget.deliveryBoy['vehicle']['model'] ?? '';
    _vehicleNumberController.text =
        widget.deliveryBoy['vehicle']['number'] ?? '';
    _imageFile = null; // Initialize as null for the editing context
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

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
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : NetworkImage(widget.deliveryBoy['image'] ??
                          'https://via.placeholder.com/150') as ImageProvider,
                  child: _imageFile == null
                      ? Icon(Icons.camera_alt, size: 50, color: Colors.grey)
                      : null,
                ),
              ),
              SizedBox(height: 20),
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
                    'image': _imageFile != null
                        ? _imageFile!.path // Use the path for now
                        : widget.deliveryBoy['image'] ??
                            'https://via.placeholder.com/150', // Keep original if no new image
                  };
                  widget.onUpdate(updatedDeliveryBoy);
                  Navigator.pop(context);
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
