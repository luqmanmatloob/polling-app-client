import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class CreatePollScreen extends StatefulWidget {
  const CreatePollScreen({super.key});

  @override
  State<CreatePollScreen> createState() => _CreatePollScreenState();
}

class _CreatePollScreenState extends State<CreatePollScreen> {
  final _questionController = TextEditingController();
  final _optionController1 = TextEditingController();
  final _optionController2 = TextEditingController();
  final _optionController3 = TextEditingController();

  // Initialize the logger instance
  final logger = Logger(
    filter: DevelopmentFilter(),
    printer: PrettyPrinter(),
  );

  // JWT Token
  String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3NWQ5YTJlMzg0MmI0ODQ5NmY5Mzk3OSIsInJvbGUiOiJhZG1pbiIsImlhdCI6MTczNDE4OTkzMywiZXhwIjoxNzQxOTY1OTMzfQ.gP3sLfS3Q3fgPFvXts50hnfYV5ooVgxGrA1lChvGMxM";

  // Create Poll method to make API call
  Future<void> createPoll() async {
    String question = _questionController.text;
    List<String> options = [
      _optionController1.text,
      _optionController2.text,
      _optionController3.text
    ];

    // API URL for creating a poll
    final url = Uri.parse('http://localhost:5000/api/polls/create');

    // Headers including the Authorization token
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token", // Token used here
    };

    // Poll data in the correct format
    final body = jsonEncode({
      "title":
          "Poll Title", // You can replace this with a dynamic title if needed
      "question": question,
      "options": options,
    });

    // Making the POST request to create the poll
    try {
      final response = await http.post(url, headers: headers, body: body);

      // Log the entire response
      logger.d('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Poll created successfully
        final responseBody = jsonDecode(response.body);
        String pollId = responseBody['id'] ?? 'Unknown ID';

        // Log message
        logger.i('Poll Created Successfully. Poll ID: $pollId');

        // Show SnackBar with Poll ID
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Poll Created: $question\nPoll ID: $pollId')),
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
      // Handle errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error connecting to server')),
        );
      }
      // Logging the error using logger
      logger.e('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Poll"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Enter Poll Question",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(
                hintText: 'Enter your poll question',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Enter Poll Options",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(0.3),
                ),
                onPressed: createPoll,
                child: const Text(
                  "Create Poll",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
