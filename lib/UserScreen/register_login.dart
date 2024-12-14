import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:polling_app/UserScreen/log_in.dart';
import 'package:polling_app/Userprofile/user_home.dart';

class RegisterLogin extends StatefulWidget {
  const RegisterLogin({super.key});

  @override
  State<StatefulWidget> createState() {
    return _UserLoginState();
  }
}

class _UserLoginState extends State<RegisterLogin> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _fullNameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  Future<void> _registerUser() async {
    final url = Uri.parse(
        "http://192.168.1.7:5000/api/auth/register"); // Use your local IP address here

    final headers = {"Content-Type": "application/json"};

    final body = jsonEncode({
      "name": _fullNameController.text,
      "email": _emailController.text,
      "password": _passwordController.text,
      "role": "user",
    });

    // Save the current BuildContext
    final currentContext = context;

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        // Registration successful
        if (currentContext.mounted) {
          ScaffoldMessenger.of(currentContext).showSnackBar(
            const SnackBar(content: Text('Registration successful!')),
          );
          Navigator.push(
            currentContext,
            MaterialPageRoute(builder: (context) => const UserProfile()),
          );
        }
      } else {
        // Registration failed
        String errorMessage = 'Registration failed. Please try again.';
        try {
          final responseBody = jsonDecode(response.body);
          if (responseBody['message'] != null) {
            errorMessage = responseBody['message'];
          }
        } catch (e) {
          errorMessage = 'Error processing the response.';
        }

        if (currentContext.mounted) {
          ScaffoldMessenger.of(currentContext).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      }
    } catch (e) {
      if (currentContext.mounted) {
        ScaffoldMessenger.of(currentContext).showSnackBar(
          const SnackBar(content: Text('Error connecting to the server.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double fieldWidth = screenWidth * 0.60;
    double fieldHeight = screenHeight * 0.08;

    return Scaffold(
      backgroundColor: const Color(0xFFE6E6FA),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const Text(
                "Create new Account",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _fullNameController,
                label: 'Full Name',
                error: _fullNameError,
                fieldWidth: fieldWidth,
                fieldHeight: fieldHeight,
              ),
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                error: _emailError,
                fieldWidth: fieldWidth,
                fieldHeight: fieldHeight,
              ),
              _buildTextField(
                controller: _passwordController,
                label: 'Password',
                error: _passwordError,
                fieldWidth: fieldWidth,
                fieldHeight: fieldHeight,
                obscureText: true,
              ),
              _buildTextField(
                controller: _confirmPasswordController,
                label: 'Confirm Password',
                error: _confirmPasswordError,
                fieldWidth: fieldWidth,
                fieldHeight: fieldHeight,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: fieldWidth,
                height: fieldHeight,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _fullNameError = null;
                      _emailError = null;
                      _passwordError = null;
                      _confirmPasswordError = null;

                      if (_fullNameController.text.isEmpty) {
                        _fullNameError = 'Please enter your full name';
                      }
                      if (_emailController.text.isEmpty) {
                        _emailError = 'Please enter your email';
                      }
                      if (_passwordController.text.isEmpty) {
                        _passwordError = 'Please enter a password';
                      }
                      if (_confirmPasswordController.text.isEmpty) {
                        _confirmPasswordError = 'Please confirm your password';
                      } else if (_confirmPasswordController.text !=
                          _passwordController.text) {
                        _confirmPasswordError = 'Passwords do not match';
                      }

                      if (_fullNameError == null &&
                          _emailError == null &&
                          _passwordError == null &&
                          _confirmPasswordError == null) {
                        _registerUser();
                      }
                    });
                  },
                  child: const Text(
                    "Create Account",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserLoginWithFields(),
                        ),
                      );
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? error,
    required double fieldWidth,
    required double fieldHeight,
    bool obscureText = false,
  }) {
    return Column(
      children: [
        Container(
          width: fieldWidth,
          height: fieldHeight,
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          decoration: BoxDecoration(
            color: const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: label,
            ),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              error,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        const SizedBox(height: 10),
      ],
    );
  }
}
