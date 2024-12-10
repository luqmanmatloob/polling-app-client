import 'package:flutter/material.dart';

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

  void createPoll() {
    // Retrieve the poll question and options from the controllers
    String question = _questionController.text;
    List<String> options = [
      _optionController1.text,
      _optionController2.text,
      _optionController3.text
    ];

    // Logic to create the poll goes here.
    // Example: Saving or sending the poll data.

    // For now, showing the success message with the question and options.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Poll Created: $question\nOptions: $options'),
      ),
    );
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
