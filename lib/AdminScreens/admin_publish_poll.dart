import 'package:flutter/material.dart';

import '../Voting/voting_screen.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AdminProfileState();
  }
}

class _AdminProfileState extends State<AdminProfile> {
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
                        // Action for publishing PTI vs PPP poll
                      },
                      child: const Text("Publish"),
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
                        // Action for publishing Cheezious vs Butt Karahi poll
                      },
                      child: const Text("Publish"),
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
                        // Action for publishing Best City poll
                      },
                      child: const Text("Publish"),
                    ),
                  ],
                ),
              ),
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
