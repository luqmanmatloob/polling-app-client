import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class CreatePollScreen extends StatefulWidget {
  final Function? refreshPollList; // Callback to refresh the poll list
  const CreatePollScreen({super.key, this.refreshPollList});

  @override
  State<CreatePollScreen> createState() => _CreatePollScreenState();
}

class _CreatePollScreenState extends State<CreatePollScreen> {
  final _questionController = TextEditingController();
  final _optionController1 = TextEditingController();
  final _optionController2 = TextEditingController();
  final _optionController3 = TextEditingController();

  final Logger logger = Logger();

  Future<void> createPoll() async {
    // Retrieve the poll question and options
    String question = _questionController.text;
    List<String> options = [
      _optionController1.text,
      _optionController2.text,
      _optionController3.text,
    ];

    // Prepare poll data
    final pollData = {
      "title": question,
      "question": question,
      "options": options,
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token == null) {
      // Check if the widget is still mounted before showing the SnackBar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated')),
        );
      }
      return;
    }

    final url = Uri.parse('http://localhost:5000/api/polls/create');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response =
          await http.post(url, headers: headers, body: jsonEncode(pollData));
      logger.d('Backend Response: ${response.body}'); // Log the full response

      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);

        // Extract poll ID from the response
        final String? pollId = responseBody['poll']?['_id'];

        if (pollId != null) {
          // Log and pass the pollId to the refreshPollList callback
          logger.i("Poll created with ID: $pollId");
          if (widget.refreshPollList != null) {
            widget.refreshPollList!(pollId); // Pass pollId to the dashboard
          }

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Poll created successfully!')),
            );
          }

          // Use Navigator to pop the screen after creation
          if (mounted) {
            Navigator.pop(context); // Close the Create Poll screen
          }
        } else {
          logger.e("Poll ID not found in the response.");
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error: Poll ID not returned')),
            );
          }
        }
      } else {
        final responseBody = jsonDecode(response.body);
        final String errorMessage =
            responseBody['message'] ?? 'Unknown error occurred';
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $errorMessage')),
          );
        }
      }
    } catch (e) {
      logger.e("Error during poll creation: $e");
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
