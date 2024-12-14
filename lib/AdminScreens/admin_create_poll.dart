import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class CreatePollScreen extends StatefulWidget {
  final Function?
      refreshPollList; // Optional parameter to refresh the poll list

  const CreatePollScreen(
      {super.key, this.refreshPollList}); // Optional parameter

  @override
  State<CreatePollScreen> createState() => _CreatePollScreenState();
}

class _CreatePollScreenState extends State<CreatePollScreen> {
  final _questionController = TextEditingController();
  final _optionController1 = TextEditingController();
  final _optionController2 = TextEditingController();
  final _optionController3 = TextEditingController();

  final logger = Logger(
    filter: DevelopmentFilter(),
    printer: PrettyPrinter(),
  );

  // JWT token
  String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3NWQ5YTJlMzg0MmI0ODQ5NmY5Mzk3OSIsInJvbGUiOiJhZG1pbiIsImlhdCI6MTczNDE5MzUxNSwiZXhwIjoxNzQxOTY5NTE1fQ.MbOieAu1GXnzBGz05wpynXzhsSfXFLzxzG43KdCK4iE"; // Replace this with your actual JWT token

  // Function to create a poll
  Future<void> createPoll() async {
    String question = _questionController.text;
    List<String> options = [
      _optionController1.text,
      _optionController2.text,
      _optionController3.text
    ];

    final url = Uri.parse(
        'http://localhost:5000/api/polls/create'); // Replace with your server URL
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token", // Pass the JWT token here
    };

    final body = jsonEncode({
      "title": "Poll Title", // You can modify this to dynamic if needed
      "question": question,
      "options": options,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      logger.d('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        String pollId = responseBody['id'] ?? 'Unknown ID';

        logger.i('Poll Created Successfully. Poll ID: $pollId');

        // Check if the widget is still mounted before showing the SnackBar
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Poll Created: $question\nPoll ID: $pollId')),
          );
        }

        // Call the refreshPollList function if it is not null
        widget.refreshPollList?.call();

        // Navigate back to the previous screen (check if mounted before navigating)
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        final responseBody = jsonDecode(response.body);

        // Check if the widget is still mounted before showing the SnackBar
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${responseBody['message']}')),
          );
        }
      }
    } catch (e) {
      logger.e('Error: $e');

      // Check if the widget is still mounted before showing the SnackBar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error connecting to server')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Poll")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text("Enter Poll Question",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(
                hintText: 'Enter your poll question',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Enter Poll Options",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: _optionController1,
              decoration: const InputDecoration(
                hintText: 'Option 1',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _optionController2,
              decoration: const InputDecoration(
                hintText: 'Option 2',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _optionController3,
              decoration: const InputDecoration(
                hintText: 'Option 3',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: createPoll,
                child: const Text("Create Poll"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
