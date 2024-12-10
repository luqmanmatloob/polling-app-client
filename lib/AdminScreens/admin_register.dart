import 'package:flutter/material.dart';

import 'admin_home.dart';
import 'admin_login.dart';

class AdminRegisterLogin extends StatefulWidget {
  const AdminRegisterLogin({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AdminLoginState();
  }
}

class _AdminLoginState extends State<AdminRegisterLogin> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _adminUsernameController =
      TextEditingController();
  final TextEditingController _adminEmailController = TextEditingController();
  final TextEditingController _adminPasswordController =
      TextEditingController();
  final TextEditingController _adminConfirmPasswordController =
      TextEditingController();

  String? _adminUsernameError;
  String? _adminEmailError;
  String? _adminPasswordError;
  String? _adminConfirmPasswordError;

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
                "Create Admin Account",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                width: fieldWidth,
                height: fieldHeight,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: TextFormField(
                  controller: _adminUsernameController,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    border: InputBorder.none,
                    labelText: 'Admin Username',
                  ),
                ),
              ),
              if (_adminUsernameError != null)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    _adminUsernameError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 10),
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
                  controller: _adminEmailController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Admin Email',
                  ),
                ),
              ),
              if (_adminEmailError != null)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    _adminEmailError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 10),
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
                  controller: _adminPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Password',
                  ),
                ),
              ),
              if (_adminPasswordError != null)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    _adminPasswordError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 10),
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
                  controller: _adminConfirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Confirm Password',
                  ),
                ),
              ),
              if (_adminConfirmPasswordError != null)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    _adminConfirmPasswordError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
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
                      _adminUsernameError = null;
                      _adminEmailError = null;
                      _adminPasswordError = null;
                      _adminConfirmPasswordError = null;

                      if (_adminUsernameController.text.isEmpty) {
                        _adminUsernameError =
                            'Please enter your admin username';
                      }
                      if (_adminEmailController.text.isEmpty) {
                        _adminEmailError = 'Please enter your admin email';
                      }
                      if (_adminPasswordController.text.isEmpty) {
                        _adminPasswordError = 'Please enter a password';
                      }
                      if (_adminConfirmPasswordController.text.isEmpty) {
                        _adminConfirmPasswordError =
                            'Please confirm your password';
                      } else if (_adminConfirmPasswordController.text !=
                          _adminPasswordController.text) {
                        _adminConfirmPasswordError = 'Passwords do not match';
                      }

                      if (_adminUsernameError == null &&
                          _adminEmailError == null &&
                          _adminPasswordError == null &&
                          _adminConfirmPasswordError == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AdminDashboard()));
                      }
                    });
                  },
                  child: const Text(
                    "Create Admin Account",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an admin account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AdminLoginWithFields()));
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
