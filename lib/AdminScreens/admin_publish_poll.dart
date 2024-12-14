import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Voting/voting_screen.dart';

class PublishPollScreen extends StatefulWidget {
  final Function?
      refreshPollList; // Callback to refresh poll list after creation

  const PublishPollScreen({super.key, this.refreshPollList});

  @override
  State<PublishPollScreen> createState() => _PublishPollScreenState();
}

class _PublishPollScreenState extends State<PublishPollScreen> {
  List<Map<String, dynamic>> activePolls = [];
  String errorMessage = '';
  String token = "YOUR_JWT_TOKEN"; // Use the correct JWT token

  @override
  void initState() {
    super.initState();
    fetchActivePolls(); // Fetch polls on initial load
  }

  // Fetch Active Polls from server
  Future<void> fetchActivePolls() async {
    final url = Uri.parse(
        'http://localhost:5000/api/polls/active'); // Update API endpoint

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token", // Authorization token
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> responseBody = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            activePolls = List<Map<String, dynamic>>.from(responseBody);
          });
        }
      } else {
        throw Exception('Failed to load polls');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage =
              'Error fetching polls: $e'; // Display the error message
        });
      }
    }
  }

  // Publish Poll Method to make API call
  Future<void> publishPoll(String pollId) async {
    final url = Uri.parse(
        'http://localhost:5000/api/polls/publish/$pollId'); // API endpoint

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token", // Authorization token
    };

    try {
      final response = await http.put(url, headers: headers);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        String pollId = responseBody['id'] ?? 'Unknown ID';

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Poll Published Successfully. Poll ID: $pollId')),
          );
        }

        // Fetch updated list of polls after publishing
        fetchActivePolls();
      } else {
        final responseBody = jsonDecode(response.body);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${responseBody['message']}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error connecting to server')),
        );
      }
    }
  }

  // Navigate to VotingScreen
  void navigateToVotingScreen(Map<String, dynamic> poll) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VotingScreen(pollData: poll),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const Center(
              child: Text(
                "Active Polls",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                "Publish your polls and share them with others!",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 30),

            // Display active polls dynamically
            if (activePolls.isNotEmpty)
              ...activePolls.map((poll) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(poll['name']), // Display the poll name
                        FilledButton(
                          onPressed: () {
                            publishPoll(poll['id']); // Use the actual poll ID
                          },
                          child: const Text("Publish"),
                        ),
                      ],
                    ),
                  ),
                );
              })
            else
              const Center(
                child: Text("No active polls available"),
              ),

            const SizedBox(height: 30),

            // "Publish Result" button after the cards
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(0.3),
                ),
                onPressed: () {
                  // Action for publishing results
                },
                child: const Text(
                  "Publish Result",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Center(
              child: Text(
                "More polls coming soon!",
                style: TextStyle(fontSize: 16, color: Colors.blueGrey),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
