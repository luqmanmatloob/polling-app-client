import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

class ResultHome extends StatefulWidget {
  const ResultHome({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ResultHomeState createState() => _ResultHomeState();
}

class _ResultHomeState extends State<ResultHome> {
  List<dynamic> polls = [];
  bool isLoading = true;
  final Logger logger = Logger(); // Initialize logger

  @override
  void initState() {
    super.initState();
    fetchPolls(); // Fetch all published polls on page load
  }

  // Function to fetch all published polls
  Future<void> fetchPolls() async {
    const url = 'http://localhost:5000/api/polls/getPublishedPolls';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          polls = data;
          isLoading = false;
        });
      } else {
        showSnackbar('Failed to fetch polls');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      showSnackbar('Error fetching polls: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to fetch poll results for a specific poll
  Future<void> fetchPollResult(String pollId) async {
    final url = 'http://localhost:5000/api/polls/result/$pollId';

    try {
      logger
          .i("Fetching result for poll ID: $pollId"); // Debug log using logger
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Show result in a dialog
        showResultDialog(data['message'], data['voteCounts']);
      } else {
        showSnackbar('Failed to fetch poll results');
      }
    } catch (e) {
      logger.e('Error fetching poll results: $e'); // Log error using logger
      showSnackbar('Error fetching poll results: $e');
    }
  }

  // Function to show the result in a dialog
  void showResultDialog(String message, List<dynamic> voteCounts) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Poll Result'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message),
              const SizedBox(height: 10),
              const Text('Votes per option:'),
              ...voteCounts.asMap().entries.map((entry) {
                int index = entry.key;
                int votes = entry.value;
                return Text('Option ${index + 1}: $votes votes');
              })
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Function to show a snackbar for errors or info
  void showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Poll Results'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: polls.length,
              itemBuilder: (context, index) {
                final poll = polls[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  child: ListTile(
                    title: Text(
                      poll['title'] ?? 'No Title',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle:
                        Text('Created At: ${poll['createdAt'] ?? 'Unknown'}'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        logger.i(
                            "Show Result button clicked for poll ID: ${poll['_id']}"); // Log button click using logger
                        fetchPollResult(poll['_id']);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text(
                        "Show Result",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
