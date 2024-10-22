import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_vegitable_market/screens/Home/home.dart';

class CodeVerificationPage extends StatefulWidget {
  final String email;

  CodeVerificationPage({required this.email});

  @override
  _CodeVerificationPageState createState() => _CodeVerificationPageState();
}

class _CodeVerificationPageState extends State<CodeVerificationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _codeController = TextEditingController();
  bool isCodeCorrect = false;
  late User user;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser!;
  }

  Future<void> _verifyCode() async {
    String enteredCode = _codeController.text;

    // Retrieve the stored code from Firestore
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('verificationCodes')
        .doc(user.uid)
        .get();

    if (doc.exists && doc['code'] == enteredCode) {
      setState(() {
        isCodeCorrect = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Code verified successfully!')),
      );

      // Redirect to home page after successful verification
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => Home(),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid code. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Enter the 4-digit code sent to ${widget.email}:',
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: InputDecoration(hintText: 'Enter verification code'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyCode,
              child: Text('Verify Code'),
            ),
            if (isCodeCorrect)
              Text(
                'Code verified successfully!',
                style: TextStyle(color: Colors.green, fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}
