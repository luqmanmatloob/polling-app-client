import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON encoding/decoding
import '../Voting/voting_screen.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<StatefulWidget> createState() {
    return _UserProfileState();
  }
}

class _UserProfileState extends State<UserProfile> {
  List<Map<String, dynamic>> polls = []; // List to hold the poll data
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPolls(); // Fetch the polls when the widget is initialized
  }

  // Fetch polls from the API
  Future<void> fetchPolls() async {
    const url = 'http://localhost:5000/api/polls/getPublishedPolls';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Update the state with the fetched polls
        if (mounted) {
          setState(() {
            polls = List<Map<String, dynamic>>.from(data);
            isLoading = false;
          });
        }
      } else {
        // Handle failure response from the server
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        // Show SnackBar only if the widget is mounted
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to fetch polls')),
          );
        }
      }
    } catch (e) {
      // Handle error during the API request
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      // Show SnackBar only if the widget is mounted
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error fetching polls')),
        );
      }
    }
  }

  // Navigate to the Voting Screen
  void navigateToVotingScreen(Map<String, dynamic> poll) {
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              VotingScreen(pollData: poll), // Pass the full poll data
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
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
                "Vote for your favorite options and make your voice heard!",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 30),

            // If loading, show a progress indicator
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: polls.length,
                      itemBuilder: (context, index) {
                        final poll = polls[index];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(poll['title'] ?? 'No Title'),
                                FilledButton(
                                  onPressed: () {
                                    navigateToVotingScreen({
                                      "id": poll['_id'], // Pass the poll ID
                                      "question": poll['title'] ?? 'No Title',
                                      "options": List.generate(
                                        poll['options'].length,
                                        (index) => {
                                          "text": poll['options'][index],
                                          "votes": poll['votes'][index] ?? 0,
                                        },
                                      ),
                                    });
                                  },
                                  child: const Text("Vote"),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 30),
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
