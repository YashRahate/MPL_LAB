import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sca/reuseable_widgets/reuseable_widgets.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _emailTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Reset Password",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
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
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20),
                  reuseableTextField(
                    "Enter Email Id",
                    Icons.person_outline,
                    false,
                    _emailTextController,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      }
                      if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : signInSignUpButton(context, false, () {
                          if (_formKey.currentState?.validate() == true) {
                            _resetPassword();
                          }
                        }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _resetPassword() {
    final email = _emailTextController.text.trim();

    setState(() {
      _isLoading = true;
    });

    FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .then((value) {
      setState(() {
        _isLoading = false;
      });
      _showSnackbar("Password reset email sent successfully!");
      Navigator.of(context).pop();
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      _showSnackbar("Error: ${error.message}");
    });
  }

  void _showSnackbar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
