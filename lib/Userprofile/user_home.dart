import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<StatefulWidget> createState() {
    return _UserProfilestate();
  }
}

class _UserProfilestate extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("hello"),
    );
  }
}
