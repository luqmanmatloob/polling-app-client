import 'package:flutter/material.dart';
import 'dart:developer'; // Import the dart:developer package for logging
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert'; // To handle JSON encoding/decoding
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

class VotingScreen extends StatefulWidget {
  final Map<String, dynamic> pollData;
  const VotingScreen({super.key, required this.pollData});

  @override
  // ignore: library_private_types_in_public_api
  _VotingScreenState createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  late Map<String, dynamic> poll;
  late String pollId;
  String? token; // Variable to store JWT token

  @override
  void initState() {
    super.initState();
    poll = widget.pollData;
    pollId = poll['id'] ?? ''; // Ensure this is being extracted correctly

    // Log the pollId to check if it's passed correctly
    log('Poll ID: $pollId');

    // Handle the case where Poll ID is missing or invalid
    if (pollId.isEmpty && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Poll ID is missing or invalid.')),
          );
        }
      });
    }

    // Get the token from SharedPreferences
    _getToken();
  }

  // Retrieve token from SharedPreferences
  Future<void> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('jwt_token'); // Retrieve JWT token
    });
    log('Token retrieved: $token');
  }

  // Function to cast the vote by making an API request
  Future<void> castVote(String option) async {
    if (pollId.isEmpty || token == null) {
      // Handle missing or invalid poll ID or token
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Poll ID or Token is missing or invalid.')),
        );
      }
      return;
    }

    final url = Uri.parse('http://localhost:5000/api/votes/cast');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer $token', // Use the token retrieved from SharedPreferences
    };

    final body = json.encode({
      'pollId': pollId,
      'option': option,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // Successfully casted vote
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vote casted successfully!')),
          );
        }

        // Optionally, update the UI (increment the vote count)
        setState(() {
          final optionIndex =
              poll['options'].indexWhere((opt) => opt['text'] == option);
          if (optionIndex != -1) {
            poll['options'][optionIndex]['votes'] += 1;
          }
        });
      } else {
        // Handle API failure
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to cast vote: ${response.body}')),
          );
        }
      }
    } catch (e) {
      // Handle any exceptions
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vote on Poll'),
      ),
      body: Column(
        children: [
          Text(poll['question']),
          ...poll['options'].map<Widget>((option) {
            return ListTile(
              title: Text(option['text']),
              trailing: Text('Votes: ${option['votes']}'),
              onTap: () {
                // Call the function to cast vote when the option is tapped
                castVote(option['text']);
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}
