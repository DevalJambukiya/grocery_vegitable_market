import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:grocery_vegitable_market/Admin/screens/dashboard.dart';

class AdminLogin extends StatefulWidget {
  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  bool _obscureText = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Authenticate user with Firebase
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Fetch admin data from Firestore
        DocumentSnapshot adminData = await FirebaseFirestore.instance
            .collection(
                'admins') // Change 'admins' to your Firestore collection name
            .doc(userCredential.user!.uid) // Get the document by user ID
            .get();

        if (adminData.exists) {
          // Navigate to DashboardPage if the admin exists
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardPage(),
            ),
          );
        } else {
          // Handle case where admin does not exist
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Admin not found')),
          );
        }
      } on FirebaseAuthException catch (e) {
        // Handle authentication error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Login failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight,
            ),
            child: IntrinsicHeight(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Image.asset(
                        'assets/Logo/carrot.png',
                        height: screenHeight * 0.1,
                        width: screenWidth * 0.2,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Text(
                      'Admin Login',
                      style: TextStyle(
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Enter your admin email and password',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 32),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please fill in your email'; // Error if email is empty
                        }
                        String pattern =
                            r'\w+@\w+\.\w+'; // Regex for basic email validation
                        if (!RegExp(pattern).hasMatch(value)) {
                          return 'Please enter a valid email address'; // Error if invalid email
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please fill in your password'; // Error if password is empty
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long'; // Error for short password
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _login, // Call the login function
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Colors.green,
                        ),
                        child: Text('Log In', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                    SizedBox(height: 16),
                    // You can add a back button to return to the main login screen
                    TextButton(
                      onPressed: () {
                        Navigator.pop(
                            context); // Go back to the previous screen
                      },
                      child: Text("Back to User Login"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
