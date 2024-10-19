import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: UsersPage(),
  ));
}

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final List<Map<String, dynamic>> users = [
    {
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'phone': '123-456-7890',
    },
    {
      'name': 'Alex Smith',
      'email': 'alex.smith@example.com',
      'phone': '098-765-4321',
    },
    {
      'name': 'Michael Lee',
      'email': 'michael.lee@example.com',
      'phone': '321-654-9870',
    },
  ];

  void _editUser(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUserPage(
          user: users[index],
          onSave: (updatedUser) {
            setState(() {
              // Update the user details
              users[index] = updatedUser;
            });
          },
        ),
      ),
    );
  }

  void _confirmDeleteUser(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  users.removeAt(index); // Delete the user
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
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
        title: Row(
          children: [
            Expanded(child: Text('Users')),
            Text('Total: ${users.length}'),
          ],
        ),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return UserCard(
            user: users[index],
            onDelete: () => _confirmDeleteUser(context, index),
            onEdit: () => _editUser(context, index),
          );
        },
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final Map<String, dynamic> user;
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Card(
        elevation: 2,
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
          ),
          title: Text(user['name']),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Email: ${user['email']}'),
              Text('Phone: ${user['phone']}'),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
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
        ),
      ),
    );
  }
}

class EditUserPage extends StatelessWidget {
  final Map<String, dynamic> user;
  final Function(Map<String, dynamic>) onSave;

  const EditUserPage({Key? key, required this.user, required this.onSave})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _nameController =
        TextEditingController(text: user['name']);
    final TextEditingController _emailController =
        TextEditingController(text: user['email']);
    final TextEditingController _phoneController =
        TextEditingController(text: user['phone']);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(_nameController, 'Name'),
              SizedBox(height: 16),
              _buildTextField(_emailController, 'Email'),
              SizedBox(height: 16),
              _buildTextField(_phoneController, 'Phone'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final updatedUser = {
                    'name': _nameController.text,
                    'email': _emailController.text,
                    'phone': _phoneController.text,
                  };
                  onSave(updatedUser);
                  Navigator.pop(context);
                },
                child: Text('Save'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.green),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.green, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.green, width: 2),
        ),
      ),
    );
  }
}
