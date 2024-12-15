import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:polling_app/UserScreen/log_in.dart'; // Replace with the correct import for login page
import 'package:polling_app/Userprofile/user_home.dart'; // Replace with the correct import for user profile page

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

  bool isLoading = false;

  // Method to handle registration process
  Future<void> _registerUser() async {
    final baseUrl = dotenv.env['API_BASE_URL'] ?? '';
    if (baseUrl.isEmpty) {
      debugPrint("API base URL is missing in .env file");
      return;
    }

    final url = Uri.parse('$baseUrl/api/auth/register');
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      "name": _fullNameController.text, // Full Name
      "email": _emailController.text, // Email
      "password": _passwordController.text, // Password
      "role": "user", // User role
    });

    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      final response = await http
          .post(url, headers: headers, body: body)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful!')),
          );
          // Navigate to the user profile screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserProfile()),
          );
        }
      } else {
        String errorMessage = 'Registration failed. Please try again.';
        try {
          final responseBody = jsonDecode(response.body);
          if (responseBody['message'] != null) {
            errorMessage = responseBody['message'];
          }
        } catch (e) {
          errorMessage = 'Error processing the response.';
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      }
    } catch (e) {
      debugPrint("Error: $e");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error connecting to the server.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
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
              // Full Name TextField
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
                  controller: _fullNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Full Name',
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Email TextField
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
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Email',
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Password TextField
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
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Password',
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Confirm Password TextField
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
                  controller: _confirmPasswordController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    } else if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Confirm Password',
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Submit Button
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
                  onPressed: isLoading
                      ? null
                      : () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _registerUser(); // Call the registration method
                          }
                        },
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          "Create Account",
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
              const SizedBox(height: 20),

              // Sign In navigation
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
}
