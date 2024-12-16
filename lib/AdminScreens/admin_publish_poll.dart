import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PublishPollScreen extends StatefulWidget {
  final String pollId;

  const PublishPollScreen({super.key, required this.pollId});

  @override
  State<PublishPollScreen> createState() => _PublishPollScreenState();
}

class _PublishPollScreenState extends State<PublishPollScreen> {
  Map<String, dynamic>? pollDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPollDetails();
  }

  Future<void> fetchPollDetails() async {
    const String token =
        "your_jwt_token"; // Replace with actual token fetching logic
    final Uri url =
        Uri.parse('http://localhost:5000/api/polls/${widget.pollId}');

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            pollDetails =
                data; // Assuming the response directly contains poll details
            isLoading = false;
          });
        }
      } else {
        handleError(
            'Failed to fetch poll details (Status: ${response.statusCode})');
      }
    } catch (e) {
      handleError('Error connecting to server: $e');
    }
  }

  Future<void> publishPoll() async {
    if (pollDetails == null) return;

    const String token =
        "your_jwt_token"; // Replace with actual token fetching logic
    final Uri url =
        Uri.parse('http://localhost:5000/api/polls/publish/${widget.pollId}');

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Poll published successfully!')),
          );
        }
      } else {
        handleError('Failed to publish poll (Status: ${response.statusCode})');
      }
    } catch (e) {
      handleError('Error connecting to server: $e');
    }
  }

  void handleError(String message) {
    debugPrint('[ERROR] $message');
    if (mounted) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Publish Poll')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (pollDetails == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Publish Poll')),
        body: const Center(child: Text('Poll not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Publish Poll')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Poll Title: ${pollDetails!['title']}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Question: ${pollDetails!['question']}'),
            const SizedBox(height: 10),
            const Text(
              'Options:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ...pollDetails!['options'].map<Widget>(
              (option) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(option, style: const TextStyle(fontSize: 14)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: publishPoll,
              child: const Text('Publish Poll'),
            ),
          ],
        ),
      ),
    );
  }
}
