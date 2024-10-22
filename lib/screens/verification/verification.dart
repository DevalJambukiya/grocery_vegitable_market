import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_vegitable_market/screens/Home/home.dart';

class EmailVerificationPage extends StatefulWidget {
  final String email;

  EmailVerificationPage({required this.email});

  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isEmailVerified = false;
  bool isVerificationEmailSent = false;
  late User user;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser!;

    // Send verification email upon entering the page
    _sendVerificationEmail();

    // Start checking for email verification status periodically
    timer = Timer.periodic(Duration(seconds: 3), (_) => _checkEmailVerified());
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<void> _sendVerificationEmail() async {
    try {
      await user.sendEmailVerification();
      setState(() {
        isVerificationEmailSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification email sent to ${widget.email}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending email: ${e.toString()}')),
      );
    }
  }

  Future<void> _checkEmailVerified() async {
    // Refresh user to check if email has been verified
    await user.reload();
    user = _auth.currentUser!;

    if (user.emailVerified) {
      setState(() {
        isEmailVerified = true;
      });
      timer.cancel();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email verified!')),
      );
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => Home(), // Redirect to home page or dashboard
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Email Verification'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Verify your email',
                    style: TextStyle(
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'A verification email has been sent to ${widget.email}. Please check your inbox and click on the verification link to verify your email address.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: screenWidth * 0.04),
                  ),
                  SizedBox(height: 20),
                  if (isVerificationEmailSent)
                    TextButton(
                      onPressed: _sendVerificationEmail,
                      child: Text('Resend Verification Email'),
                    ),
                  if (!isEmailVerified)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  if (isEmailVerified)
                    Text(
                      'Email verified successfully!',
                      style: TextStyle(
                        fontSize: screenWidth * 0.06,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
