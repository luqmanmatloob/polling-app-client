// import 'package:flutter/material.dart';
// import 'package:polling_app/AdminScreens/admin_create_poll.dart';
// import 'package:polling_app/AdminScreens/admin_publish_poll.dart';
// import 'package:logger/logger.dart'; // Import the logger package

// class AdminDashboard extends StatelessWidget {
//   AdminDashboard({super.key});

//   // Create a logger instance
//   final Logger logger = Logger();

//   // This method can be used to refresh the poll list after a poll is created
//   void refreshPollList(String newPollId) {
//     // Use the logger instead of print
//     logger.i("Poll created with ID: $newPollId"); // Log the message
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     double fieldWidth = screenWidth * 0.45;
//     double fieldHeight = screenHeight * 0.12;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Admin Dashboard"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               "Welcome to the Admin Dashboard!",
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 30),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   width: fieldWidth,
//                   height: fieldHeight,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       elevation: 5,
//                       shadowColor: Colors.black.withOpacity(0.3),
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const PublishPollScreen(
//                             pollId:
//                                 "yourPollId", // Replace this with actual pollId
//                           ),
//                         ),
//                       );
//                     },
//                     child: const Text(
//                       "Publish Poll",
//                       style: TextStyle(fontSize: 18, color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 20),
//                 SizedBox(
//                   width: fieldWidth,
//                   height: fieldHeight,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       elevation: 5,
//                       shadowColor: Colors.black.withOpacity(0.3),
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => CreatePollScreen(
//                             refreshPollList:
//                                 refreshPollList, // Pass the callback here
//                           ),
//                         ),
//                       );
//                     },
//                     child: const Text(
//                       "Create Poll",
//                       style: TextStyle(fontSize: 18, color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the HTTP package
import 'dart:convert'; // For JSON encoding/decoding
import 'package:polling_app/AdminScreens/admin_create_poll.dart';
import 'package:logger/logger.dart'; // Logger package
import 'package:shared_preferences/shared_preferences.dart'; // For SharedPreferences

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final Logger logger = Logger(); // Create a logger instance
  List<Map<String, dynamic>> polls = []; // To hold the list of polls
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPolls(); // Fetch polls on initialization
  }

  // Fetch polls from the API
  Future<void> fetchPolls() async {
    const url = 'http://localhost:5000/api/polls';

    // Get JWT token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token == null) {
      // Handle the case where token is not found
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in again')),
        );
      }
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            polls = List<Map<String, dynamic>>.from(data);
            isLoading = false;
          });
        }
      } else {
        logger.e('Failed to fetch polls: ${response.statusCode}');
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      logger.e('Error fetching polls: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Publish a poll
  Future<void> publishPoll(String pollId) async {
    final url = 'http://localhost:5000/api/polls/publish/$pollId';

    // Get JWT token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token == null) {
      // Handle the case where token is not found
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in again')),
        );
      }
      return;
    }

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final message = json.decode(response.body)['message'];
        logger.i(message);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
          fetchPolls(); // Refresh the poll list
        }
      } else {
        logger.e('Failed to publish poll: ${response.statusCode}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to publish poll')),
          );
        }
      }
    } catch (e) {
      logger.e('Error publishing poll: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error publishing poll')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: polls.length,
              itemBuilder: (context, index) {
                final poll = polls[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  child: ListTile(
                    title: Text(
                      poll['title'] ?? 'No Title', // Ensures title is not null
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle:
                        Text('Created At: ${poll['createdAt'] ?? 'Unknown'}'),
                    trailing: ElevatedButton(
                      onPressed: () => publishPoll(poll['_id'] ?? ''),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text(
                        "Publish",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreatePollScreen(),
              ),
            );
          }
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
