import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_vegitable_market/screens/verification/verification.dart';
import 'package:grocery_vegitable_market/Admin/login.dart';
import 'package:grocery_vegitable_market/screens/register.dart';
import 'package:grocery_vegitable_market/screens/forgot/ForgotPassword.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _loginUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Sign in the user using Firebase Authentication
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Fetch user data from Firestore 'users' collection
        DocumentSnapshot userData = await _firestore
            .collection(
                'users') // Ensure this matches your Firestore collection name
            .doc(userCredential.user!.uid) // Use UID to get user data
            .get();

        // Print the fetched user data for debugging
        print("Fetched user data: ${userData.data()}");

        if (userData.exists) {
          // Retrieve the fullName and email from Firestore
          String userName =
              userData['fullName'] ?? "User"; // Changed to fullName
          String userEmail = userData['email'] ??
              _emailController.text; // Fallback in case email is null

          // Show a welcome message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Welcome, $userName!")),
          );

          // Navigate to the EmailVerificationPage (or another page)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmailVerificationPage(
                email: userEmail, // Pass the email fetched from Firestore
              ),
            ),
          );
        } else {
          // If user data is not found, sign the user out and show an error message
          _auth.signOut();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("User data not found in the database")),
          );
        }
      } catch (e) {
        // Log the error for debugging
        print("Error during login: ${e.toString()}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed: ${e.toString()}")),
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
                      'Login',
                      style: TextStyle(
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Enter your email and password',
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
                          return 'Please fill in your email';
                        }
                        String pattern = r'\w+@\w+\.\w+';
                        if (!RegExp(pattern).hasMatch(value)) {
                          return 'Please enter a valid email address';
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
                          return 'Please fill in your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPassword(),
                            ),
                          );
                        },
                        child: Text('Forgot Password?'),
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loginUser, // Call the login function
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
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminLogin(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Colors.blue,
                        ),
                        child: Text('Admin Log In',
                            style: TextStyle(fontSize: 18)),
                      ),
                    ),
                    SizedBox(height: 16),
                    screenWidth > 260
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account?"),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Register(),
                                    ),
                                  );
                                },
                                child: Text('Sign Up'),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account?"),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Register(),
                                    ),
                                  );
                                },
                                child: Text('Sign Up'),
                              ),
                            ],
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
