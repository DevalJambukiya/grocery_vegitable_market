import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // For handling file uploads
import 'package:firebase_storage/firebase_storage.dart'; // For Firebase Storage

class MyDetailsPage extends StatefulWidget {
  @override
  _MyDetailsPageState createState() => _MyDetailsPageState();
}

class _MyDetailsPageState extends State<MyDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _mobileNumber = '';
  String _email = '';
  String _address = '';
  String _profilePhoto = ''; // Profile photo URL

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage =
      FirebaseStorage.instance; // Add Firebase Storage instance

  @override
  void initState() {
    super.initState();
    _fetchUsersData(); // Fetch user data when the widget is initialized
  }

  Future<void> _fetchUsersData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Fetching user document from Firestore
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          setState(() {
            _name = userDoc['fullName'] ?? ''; // Fetch name from Firestore
            _mobileNumber = userDoc['mobileNumber'] ?? '';
            _email = userDoc['email'] ?? '';
            _address = userDoc['address'] ?? '';
            _profilePhoto =
                userDoc['profilePhoto'] ?? ''; // Fetch profile photo if exists
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user data: ${e.toString()}')),
      );
    }
  }

  void _pickProfilePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Upload the image to Firebase Storage
      String imagePath = 'profilePhotos/${_auth.currentUser!.uid}.jpg';
      TaskSnapshot uploadTask =
          await _storage.ref(imagePath).putFile(File(image.path));

      // Get the download URL after upload
      String downloadUrl = await uploadTask.ref.getDownloadURL();

      // Save the download URL to Firestore
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'profilePhoto': downloadUrl,
      });

      // Update the state to show the new profile photo
      setState(() {
        _profilePhoto = downloadUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile photo updated successfully!")),
      );
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final user = _auth.currentUser;
      if (user != null) {
        try {
          await _firestore.collection('users').doc(user.uid).update({
            'fullName': _name,
            'mobileNumber': _mobileNumber,
            'email': _email,
            'address': _address,
            // Profile photo is already updated in _pickProfilePhoto
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Profile updated successfully!")),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating profile: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _profilePhoto.isEmpty
                          ? AssetImage(
                              'assets/Logo/welcome.jpg') // Placeholder if no profile photo
                          : NetworkImage(_profilePhoto)
                              as ImageProvider, // Load profile photo URL
                    ),
                    TextButton(
                      onPressed: _pickProfilePhoto,
                      child: Text("Change Profile Photo"),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: "Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your name";
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: _mobileNumber,
                decoration: InputDecoration(labelText: "Mobile Number"),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your mobile number";
                  }
                  if (value.length != 10) {
                    return "Enter a valid 10-digit mobile number";
                  }
                  return null;
                },
                onSaved: (value) {
                  _mobileNumber = value!;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: _email,
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your email";
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return "Enter a valid email";
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: "New Password"),
                obscureText: true,
                onSaved: (value) async {
                  if (value != null && value.isNotEmpty) {
                    await _auth.currentUser!.updatePassword(value);
                  }
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: _address,
                decoration: InputDecoration(labelText: "Address"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your address";
                  }
                  return null;
                },
                onSaved: (value) {
                  _address = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text("Update Profile"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MyDetailsPage(),
  ));
}
