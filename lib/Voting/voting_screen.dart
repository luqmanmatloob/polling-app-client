import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class VotingScreen extends StatefulWidget {
  final Map<String, dynamic> pollData;

  const VotingScreen({super.key, required this.pollData});

  @override
  VotingScreenState createState() => VotingScreenState();
}

class VotingScreenState extends State<VotingScreen> {
  bool hasVoted = false; // To track if the user has voted
  var logger = Logger(); // Initialize Logger instance

  @override
  void initState() {
    super.initState();
    _checkIfUserHasVoted(); // Check if the user has voted when the widget loads
  }

  // Check if the user has already voted
  Future<void> _checkIfUserHasVoted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool voted =
        prefs.getBool('hasVoted') ?? false; // Default to false if not set
    setState(() {
      hasVoted = voted;
    });
    logger.i("User has voted: $hasVoted"); // Log the vote status
  }

  // Save the vote status to SharedPreferences
  Future<void> _saveVoteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasVoted', true); // Save that the user has voted
    logger.i("Vote status saved: hasVoted = true"); // Log the saved status
  }

  // Function to call API and cast the vote
  Future<void> _castVote(String pollId, String option) async {
    final url = Uri.parse('http://localhost:5000/api/votes/cast');
    const token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3NWVlYTRmOGRkNzhhNjMyMzNhNzIwMSIsInJvbGUiOiJ1c2VyIiwiaWF0IjoxNzM0Mjc3MTczLCJleHAiOjE3NDIwNTMxNzN9.YSuzRRPXhQag269Gb8OmT9X10OWZjVbsOvtm3uPNxfg';

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'pollId': pollId,
          'option': option,
        }),
      );

      if (response.statusCode == 200) {
        // If the response is successful, save the vote status
        _saveVoteStatus();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Your vote has been cast successfully!')),
          );
          setState(() {
            hasVoted = true; // Now user has voted, so update the state
          });
        }
      } else if (response.statusCode == 400) {
        // Handle if user has already voted
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You have already voted!')),
          );
        }
        logger.i("User has already voted on this poll.");
      } else {
        // Handle other errors from the API
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.body}')),
          );
        }
        logger.e("Error while casting vote: ${response.body}"); // Log error
      }
    } catch (e) {
      // Handle errors such as no internet connection
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('An error occurred. Please try again later.')),
        );
      }
      logger.e("Error occurred: $e"); // Log error
    }
  }

  // Function to increment the vote
  void incrementVote(int optionIndex) async {
    if (!hasVoted) {
      // Validate that pollData contains a valid 'id' and options
      if (widget.pollData['_id'] == null || widget.pollData['_id'].isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Poll ID is missing or invalid.')),
          );
        }
        logger.e("Poll ID is missing or invalid.");
        return;
      }

      if (widget.pollData['options'] == null ||
          widget.pollData['options'].isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No options available to vote on.')),
          );
        }
        logger.e("Poll options are missing or invalid.");
        return;
      }

      // Proceed with casting the vote
      if (optionIndex >= 0 &&
          optionIndex < widget.pollData['options'].length &&
          widget.pollData['options'][optionIndex]['text'] != null &&
          widget.pollData['options'][optionIndex]['text'].isNotEmpty) {
        setState(() {
          widget.pollData['options'][optionIndex]['votes']++;
        });

        await _castVote(
          widget.pollData['_id'], // Correctly reference _id for the poll ID
          widget.pollData['options'][optionIndex]['text'],
        );
      } else {
        // Handle invalid option index or missing text
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Invalid vote option or missing text.')),
          );
        }
        logger.e("Invalid option index or option text is null or empty.");
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You have already voted!')),
        );
      }
      logger.i("User attempted to vote again, but has already voted.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Poll Results"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (mounted) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Results",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Question:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.pollData['question'],
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: widget.pollData['options']
                          .asMap()
                          .entries
                          .map<Widget>((entry) {
                        int optionIndex = entry.key;
                        Map<String, dynamic> option = entry.value;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(option['text'],
                                  style: const TextStyle(fontSize: 16)),
                            ),
                            Row(
                              children: [
                                Text(option['votes'].toString(),
                                    style: const TextStyle(fontSize: 16)),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () {
                                    incrementVote(optionIndex);
                                  },
                                ),
                              ],
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                if (mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text("Home"),
            ),
          ],
        ),
      ),
    );
  }
}
