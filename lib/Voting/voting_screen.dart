// import 'package:flutter/material.dart';

// class VotingScreen extends StatefulWidget {
//   final Map<String, dynamic> pollData;

//   const VotingScreen({super.key, required this.pollData});

//   @override
//   VotingScreenState createState() => VotingScreenState();
// }

// class VotingScreenState extends State<VotingScreen> {
//   bool hasVoted = false; // To track if the user has voted

//   void incrementVote(int optionIndex) {
//     if (!hasVoted) {
//       setState(() {
//         if (optionIndex >= 0 &&
//             optionIndex < widget.pollData['options'].length) {
//           widget.pollData['options'][optionIndex]['votes']++;
//           hasVoted = true; // Mark as voted
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Poll Results"),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             if (mounted) {
//               Navigator.pop(context);
//             }
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Results",
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             Card(
//               elevation: 4,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Question:",
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       widget.pollData['question'],
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     const SizedBox(height: 16),
//                     Column(
//                       children: widget.pollData['options']
//                           .asMap()
//                           .entries
//                           .map<Widget>((entry) {
//                         int optionIndex = entry.key;
//                         Map<String, dynamic> option = entry.value;
//                         return Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                               child: Text(option['text'],
//                                   style: const TextStyle(fontSize: 16)),
//                             ),
//                             Row(
//                               children: [
//                                 Text(option['votes'].toString(),
//                                     style: const TextStyle(fontSize: 16)),
//                                 IconButton(
//                                   icon: const Icon(Icons.add_circle_outline),
//                                   onPressed: () {
//                                     incrementVote(optionIndex);
//                                     if (mounted) {
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(
//                                         const SnackBar(
//                                           content: Text('You have voted!'),
//                                         ),
//                                       );
//                                     }
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ],
//                         );
//                       }).toList(),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const Spacer(),
//             ElevatedButton(
//               onPressed: () {
//                 if (mounted) {
//                   Navigator.pop(context);
//                 }
//               },
//               child: const Text("Home"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VotingScreen extends StatefulWidget {
  final Map<String, dynamic> pollData;

  const VotingScreen({super.key, required this.pollData});

  @override
  VotingScreenState createState() => VotingScreenState();
}

class VotingScreenState extends State<VotingScreen> {
  bool hasVoted = false; // To track if the user has voted

  @override
  void initState() {
    super.initState();
    _checkIfUserHasVoted();
  }

  // Check if the user has already voted
  Future<void> _checkIfUserHasVoted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      hasVoted =
          prefs.getBool('hasVoted') ?? false; // Default to false if not set
    });
  }

  // Save the vote status to SharedPreferences
  Future<void> _saveVoteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasVoted', true);
  }

  void incrementVote(int optionIndex) {
    if (!hasVoted) {
      setState(() {
        if (optionIndex >= 0 &&
            optionIndex < widget.pollData['options'].length) {
          widget.pollData['options'][optionIndex]['votes']++;
          hasVoted = true; // Mark as voted
        }
      });
      _saveVoteStatus(); // Save the vote status
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You have voted!'),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You have already voted!'),
          ),
        );
      }
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
