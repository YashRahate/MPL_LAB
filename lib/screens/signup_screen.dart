import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sca/reuseable_widgets/reuseable_widgets.dart';
import 'package:sca/screens/home_screen.dart';
import 'package:sca/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4E342E), // Deep brown
              Color(0xFF6A1B9A), // Rich purple
              Color(0xFF283593), // Deep indigo
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  logoWidget("assets/images/senior_logo.png"),
                  SizedBox(height: 30),
                  reuseableTextField(
                    "Enter Username",
                    Icons.person_outline,
                    false,
                    _userNameTextController,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  reuseableTextField(
                    "Enter Email Id",
                    Icons.mail_outline,
                    false,
                    _emailTextController,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  reuseableTextField(
                    "Enter Password",
                    Icons.lock_outline,
                    true,
                    _passwordTextController,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  _isLoading
                      ? CircularProgressIndicator()
                      : signInSignUpButton(context, false, _signupUser),
                  LoginOption()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _signupUser() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailTextController.text,
        password: _passwordTextController.text,
      )
          .then((value) {
        // Save additional user info (e.g., username) in Firebase Firestore
        FirebaseFirestore.instance
            .collection('users')
            .doc(value.user?.uid)
            .set({
          'username': _userNameTextController.text,
          'email': _emailTextController.text,
        });

        setState(() {
          _isLoading = false;
        });

        print("Created new account");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }).catchError((error) {
        setState(() {
          _isLoading = false;
        });
        print("Error: ${error.toString()}");
        _showErrorDialog("Failed to create an account. Please try again.");
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Row LoginOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          },
          child: const Text(
            " Log In",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
