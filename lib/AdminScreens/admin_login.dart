import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:polling_app/AdminScreens/admin_home.dart'; // Your admin home screen
import 'package:logger/logger.dart'; // Import the logger package

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
  final _formKey = GlobalKey<FormState>();
  String? _usernameError;
  String? _passwordError;

  // Initialize logger
  final Logger logger = Logger();

  // Login API call
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final enteredUsername = _usernameController.text.trim();
      final enteredPassword = _passwordController.text.trim();

      final url = Uri.parse('http://localhost:5000/api/auth/login'); // API URL
      final headers = {"Content-Type": "application/json"};
      final body = jsonEncode({
        "email":
            enteredUsername, // Send entered username (can be email or username)
        "password": enteredPassword,
      });

      try {
        final response = await http.post(url, headers: headers, body: body);

        if (response.statusCode == 200) {
          // Extract the token from the response
          final responseBody = jsonDecode(response.body);
          String token = responseBody['token'];

          // Save token in SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', token);

          // Use logger for logging
          logger.i('JWT Token: $token');

          // Navigate to the admin dashboard after successful login
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const AdminDashboard()), // Admin Dashboard
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
        // Log error using logger
        logger.e('Error connecting to server: $e');
      }
    }
  }

  // Updated getToken method using POST request for token fetching
  Future<String?> getToken() async {
    final url = Uri.parse(
        'http://localhost:5000/api/auth/token'); // API endpoint to fetch token
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      "username": "your_username_here", // Replace with your login credentials
      "password": "your_password_here",
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        String token = responseBody['token'];

        // Save token in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);

        // Log token using logger
        logger.i('Fetched Token: $token');
        return token;
      } else {
        // Log failure using logger
        logger.e("Failed to fetch token. Status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      // Log error using logger
      logger.e("Error occurred: $e");
      return null;
    }
  }

  // Example of using token for authenticated API call
  Future<void> someAuthenticatedApiCall() async {
    String? token = await getToken(); // Retrieve the token

    if (token == null) {
      logger.e("No token found. Please log in first.");
      return;
    }

    final url = Uri.parse('http://localhost:5000/api/protected-resource');
    final headers = {
      "Content-Type": "application/json",
      "Authorization":
          "Bearer $token", // Include the token in the Authorization header
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        logger.i("Request successful");
      } else {
        logger.e("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      logger.e("Error occurred: $e");
    }
  }

  // Logout function to remove token from SharedPreferences
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token'); // Remove token on logout
    logger.i("Logged out successfully");
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
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Username Field with Custom Error Message
                    SizedBox(
                      width: fieldWidth,
                      height: fieldHeight,
                      child: TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: "Email or Admin Username",
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorText:
                              _usernameError, // Display custom error message
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            setState(() {
                              _usernameError =
                                  "Please enter your email or username";
                            });
                            return ''; // Prevent default error
                          }
                          setState(() {
                            _usernameError = null; // Clear the error when valid
                          });
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Password Field with Custom Error Message
                    SizedBox(
                      width: fieldWidth,
                      height: fieldHeight,
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Admin Password",
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorText:
                              _passwordError, // Display custom error message
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            setState(() {
                              _passwordError = "Please enter your password";
                            });
                            return ''; // Prevent default error
                          }
                          setState(() {
                            _passwordError = null; // Clear the error when valid
                          });
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Login Button
                    FilledButton(
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: Size(fieldWidth, fieldHeight),
                      ),
                      onPressed: _login,
                      child:
                          const Text("Login", style: TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 20),

                    // Register Link
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
                                builder: (context) => const AdminDashboard(),
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
          ),
        ],
      ),
    );
  }
}
