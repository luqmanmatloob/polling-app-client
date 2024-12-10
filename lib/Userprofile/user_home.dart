import 'package:flutter/material.dart';

import '../Voting/voting_screen.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<StatefulWidget> createState() {
    return _UserProfileState();
  }
}

class _UserProfileState extends State<UserProfile> {
  // Function to navigate to VotingScreen with poll data
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
                "Vote for your favorite options and make your voice heard!",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 30),
            // PTI vs PPP poll
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("PTI vs PPP"),
                    FilledButton(
                      onPressed: () {
                        // Navigating with unique poll data for PTI vs PPP
                        navigateToVotingScreen({
                          "question": "What is your favorite political party?",
                          "options": [
                            {"text": "PTI", "votes": 0},
                            {"text": "PPP", "votes": 0},
                          ],
                        });
                      },
                      child: const Text("Vote"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Cheezious vs Butt Karahi poll
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Cheezious vs Butt Karahi"),
                    FilledButton(
                      onPressed: () {
                        // Navigating with unique poll data for Cheezious vs Butt Karahi
                        navigateToVotingScreen({
                          "question": "What restaurant provides the best food?",
                          "options": [
                            {"text": "Cheezious", "votes": 0},
                            {"text": "Butt Karahi", "votes": 0},
                          ],
                        });
                      },
                      child: const Text("Vote"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Best City poll
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Best City: Islamabad or Lahore"),
                    FilledButton(
                      onPressed: () {
                        // Navigating with unique poll data for Islamabad vs Lahore
                        navigateToVotingScreen({
                          "question": "What is your favorite city?",
                          "options": [
                            {"text": "Islamabad", "votes": 0},
                            {"text": "Lahore", "votes": 0},
                          ],
                        });
                      },
                      child: const Text("Vote"),
                    ),
                  ],
                ),
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
