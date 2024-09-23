import 'package:flutter/material.dart';
import 'package:grocery_vegitable_market/screens/home/Home.dart';

class EmailVerificationPage extends StatefulWidget {
  final String email;

  EmailVerificationPage({required this.email});

  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final _verificationCodeController = TextEditingController();

  // Method to verify the code
  void _verifyCode() {
    // Print to console for debugging
    print("Button Pressed");

    // Check if the form is valid
    if (_formKey.currentState!.validate()) {
      print("Form is valid");

      // If the entered code matches the dummy code '123456'
      if (_verificationCodeController.text == '123456') {
        print("Verification successful!");

        // Navigate to the Home page if successful
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else {
        print("Invalid verification code");

        // Show error message if the verification code is incorrect
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Invalid verification code'),
        ));
      }
    } else {
      print("Form is invalid");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Email Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Assign form key to the Form widget
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'A verification code has been sent to ${widget.email}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _verificationCodeController,
                decoration: InputDecoration(
                  labelText: 'Enter Verification Code',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the verification code'; // Error if empty
                  }
                  if (value.length != 6) {
                    return 'Verification code must be 6 digits'; // Error if code length is not 6
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _verifyCode, // Calls the verification method
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.green,
                  ),
                  child: Text('Verify', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
