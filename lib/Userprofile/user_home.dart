import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<StatefulWidget> createState() {
    return _UserProfileState();
  }
}

class _UserProfileState extends State<UserProfile> {
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
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("PTI vs PPP"),
                    FilledButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VotingScreen(),
                          ),
                        );
                      },
                      child: const Text("Vote"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Cheezious vs Butt Karahi"),
                    FilledButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VotingScreen(),
                          ),
                        );
                      },
                      child: const Text("Vote"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20), // Space between cards
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Best City: Islamabad or Lahore"),
                    FilledButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VotingScreen(),
                          ),
                        );
                      },
                      child: const Text("Vote"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30), // Space below the last card
            const Center(
              child: Text(
                "More polls coming soon!",
                style: TextStyle(fontSize: 16, color: Colors.blueGrey),
              ),
            ),
            const SizedBox(height: 20), // Space before footer or FAB
          ],
        ),
      ),
    );
  }
}

class VotingScreen extends StatelessWidget {
  const VotingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vote Now"),
      ),
      body: const Center(
        child: Text("Welcome to the voting screen!"),
      ),
    );
  }
}
