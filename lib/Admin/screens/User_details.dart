import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: UsersPage(),
  ));
}

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _editUser(BuildContext context, DocumentSnapshot user) async {
    final TextEditingController _nameController =
        TextEditingController(text: user['fullName']);
    final TextEditingController _emailController =
        TextEditingController(text: user['email']);
    final TextEditingController _phoneController =
        TextEditingController(text: user['mobileNumber']);
    final TextEditingController _addressController =
        TextEditingController(text: user['address']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit User'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(_nameController, 'Full Name'),
                const SizedBox(height: 16),
                _buildTextField(_emailController, 'Email'),
                const SizedBox(height: 16),
                _buildTextField(_phoneController, 'Mobile Number'),
                const SizedBox(height: 16),
                _buildTextField(_addressController, 'Address'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final updatedUser = {
                  'fullName': _nameController.text,
                  'email': _emailController.text,
                  'mobileNumber': _phoneController.text,
                  'address': _addressController.text,
                };
                await _firestore
                    .collection('users')
                    .doc(user.id)
                    .update(updatedUser);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDeleteUser(
      BuildContext context, DocumentSnapshot user) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _firestore
                    .collection('users')
                    .doc(user.id)
                    .delete(); // Delete the user
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Delete'),
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
        title: const Text('Users'),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return UserCard(
                user: users[index],
                onDelete: () => _confirmDeleteUser(context, users[index]),
                onEdit: () => _editUser(context, users[index]),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.green),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.green, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.green, width: 2),
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final DocumentSnapshot user;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const UserCard({
    Key? key,
    required this.user,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch the profile image URL from Firestore document
    String? profileImageUrl = user['profileImage'];
    print('Profile Image URL: $profileImageUrl'); // Debug print

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Card(
        elevation: 2,
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundImage:
                profileImageUrl != null && profileImageUrl.isNotEmpty
                    ? NetworkImage(profileImageUrl)
                    : null, // Load profile image if exists
            backgroundColor: Colors.grey[300], // Placeholder background color
            child: profileImageUrl == null || profileImageUrl.isEmpty
                ? const Icon(
                    Icons.person,
                    color: Colors.grey,
                  ) // Default icon if no image is available
                : null,
          ),
          title: Text(user['fullName']),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Email: ${user['email']}'),
              Text('Mobile: ${user['mobileNumber']}'),
              Text('Address: ${user['address']}'),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
