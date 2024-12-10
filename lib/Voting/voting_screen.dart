import 'package:flutter/material.dart';

class VotingScreen extends StatefulWidget {
  final Map<String, dynamic> pollData;

  const VotingScreen({super.key, required this.pollData});

  @override
  VotingScreenState createState() => VotingScreenState();
}

class VotingScreenState extends State<VotingScreen> {
  void incrementVote(int optionIndex) {
    setState(() {
      if (optionIndex >= 0 && optionIndex < widget.pollData['options'].length) {
        widget.pollData['options'][optionIndex]['votes']++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Poll Results"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
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
                                  onPressed: () => incrementVote(optionIndex),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate to home (implement navigation)
                  },
                  child: const Text("Home"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to vote (implement navigation)
                  },
                  child: const Text("Vote"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
