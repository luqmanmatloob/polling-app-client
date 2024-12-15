import 'dart:convert';
import 'dart:developer'; // Import the log package

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:polling_app/AdminScreens/admin_home.dart';
import 'package:polling_app/AdminScreens/admin_register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminLoginWithFields extends StatefulWidget {
  const AdminLoginWithFields({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AdminLoginWithFieldsState();
  }
}

class _AdminLoginWithFieldsState extends State<AdminLoginWithFields> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _usernameError;
  String? _passwordError;

  // Function to handle API login
  Future<void> _login() async {
    // Validate form inputs
    setState(() {
      _usernameError = null;
      _passwordError = null;

      if (_usernameController.text.isEmpty) {
        _usernameError = 'Please enter your email';
      }
      if (_passwordController.text.isEmpty) {
        _passwordError = 'Please enter your password';
      }
    });

    if (_usernameError == null && _passwordError == null) {
      final email = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      final url = Uri.parse('http://localhost:5000/api/auth/login');
      final headers = {"Content-Type": "application/json"};
      final body = jsonEncode({
        "email": email,
        "password": password,
      });

      try {
        final response = await http.post(url, headers: headers, body: body);

        if (response.statusCode == 200) {
          final responseBody = jsonDecode(response.body);
          String token = responseBody['token'];

          // Log the token using the log method
          log('JWT Token: $token'); // Structured logging for debugging

          // Save token securely using SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', token);

          // Navigate to AdminDashboard after successful login
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AdminDashboard()),
            );
          }
        } else {
          final responseBody = jsonDecode(response.body);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${responseBody['message']}')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error connecting to server')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double fieldWidth = screenWidth * 0.60;
    double fieldHeight = screenHeight * 0.1;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/hand.png", // Ensure you have an asset image here
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Container(
              width: fieldWidth,
              height: fieldHeight * 5,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: fieldWidth,
                    height: fieldHeight,
                    child: TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: "Admin Email",
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorText: _usernameError,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: fieldWidth,
                    height: fieldHeight,
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Admin Password",
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorText: _passwordError,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(fieldWidth, fieldHeight),
                    ),
                    onPressed: _login,
                    child: const Text("Login", style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminRegisterLogin(),
                            ),
                          );
                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
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
        ],
      ),
    );
  }
}
