import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PublishedPollsScreen extends StatefulWidget {
  const PublishedPollsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PublishedPollsScreenState createState() => _PublishedPollsScreenState();
}

class _PublishedPollsScreenState extends State<PublishedPollsScreen> {
  List<Map<String, dynamic>> publishedPolls = []; // List of published polls
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPublishedPolls(); // Fetch published polls when screen loads
  }

  // Fetch published polls from API
  Future<void> fetchPublishedPolls() async {
    const url = 'http://localhost:5000/api/polls/getPublishedPolls';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            publishedPolls = List<Map<String, dynamic>>.from(data);
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to fetch published polls.")),
          );
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching published polls: $e")),
        );
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Fetch poll result for a specific poll
  Future<void> fetchPollResult(String pollId) async {
    final url = 'http://localhost:5000/api/polls/result/$pollId';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String message = data['message'] ?? 'No message';
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to fetch poll result.")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching poll result: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Published Polls"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : publishedPolls.isEmpty
              ? const Center(
                  child: Text(
                    "No published polls available.",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                )
              : ListView.builder(
                  itemCount: publishedPolls.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final poll = publishedPolls[index];
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
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              "Created By: ${poll['createdBy'] ?? 'Unknown'}",
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Created At: ${poll['createdAt'] ?? 'Unknown'}",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () => fetchPollResult(poll['id'] ?? ''),
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
