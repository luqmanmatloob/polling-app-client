import 'package:flutter/material.dart';
import 'package:polling_app/AdminScreens/admin_home.dart';
import 'package:polling_app/AdminScreens/admin_register.dart';

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
// Example admin credentials
  final String _adminUsername = "admin";
  final String _adminPassword = "admin123";
  void _login() {
    if (_formKey.currentState!.validate()) {
      final enteredUsername = _usernameController.text.trim();
      final enteredPassword = _passwordController.text.trim();
      if (enteredUsername == _adminUsername &&
          enteredPassword == _adminPassword) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboard()),
        );
      } else {
// Show invalid credentials error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid username or password!")),
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
                    SizedBox(
                      width: fieldWidth,
                      height: fieldHeight,
                      child: TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: "Admin Username",
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your username";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
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
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your password";
                          }
                          return null;
                        },
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
                      child:
                          const Text("Login", style: TextStyle(fontSize: 16)),
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
                                builder: (context) =>
                                    const AdminRegisterLogin(),
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
