import 'package:flutter/material.dart';

class RegisterLogin extends StatefulWidget {
  const RegisterLogin({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Userloginstate();
  }
}

class _Userloginstate extends State<RegisterLogin> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double fieldWidth = screenWidth * 0.60;
    double fieldHeight = screenHeight * 0.08;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const Text(
              "Create new Account",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Container(
              width: fieldWidth,
              height: fieldHeight,
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  border: InputBorder.none,
                  labelText: 'Full Name',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: fieldWidth,
              height: fieldHeight,
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  border: InputBorder.none,
                  labelText: 'Confirm Password',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: fieldWidth,
              height: fieldHeight,
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  border: InputBorder.none,
                  labelText: 'Email',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: fieldWidth,
              height: fieldHeight,
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  border: InputBorder.none,
                  labelText: 'Password',
                ),
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
                onPressed: () {},
                child: const Text(
                  "Continue",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
