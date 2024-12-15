import 'dart:convert';
import 'dart:developer'; // Import the log package

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:polling_app/Userprofile/user_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLoginWithFields extends StatefulWidget {
  const UserLoginWithFields({super.key});

  @override
  State<StatefulWidget> createState() {
    return _UserLoginWithFieldsState();
  }
}

class _UserLoginWithFieldsState extends State<UserLoginWithFields> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  Future<void> _loginUser() async {
    // Load the API base URL from environment variables
    final baseUrl = dotenv.env['API_BASE_URL'] ?? '';
    final url = Uri.parse('$baseUrl/api/auth/login'); // Append endpoint

    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      "email": _emailController.text,
      "password": _passwordController.text,
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

        // Navigate to the user profile page after successful login
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserProfile()),
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
              "assets/hand.png",
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
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorText: _emailError,
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
                        labelText: "Password",
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
                    onPressed: () {
                      setState(() {
                        _emailError = null;
                        _passwordError = null;

                        if (_emailController.text.isEmpty) {
                          _emailError = 'Please enter your email';
                        }
                        if (_passwordController.text.isEmpty) {
                          _passwordError = 'Please enter your password';
                        }

                        if (_emailError == null && _passwordError == null) {
                          _loginUser(); // Call the login function
                        }
                      });
                    },
                    child: const Text("Login", style: TextStyle(fontSize: 16)),
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
