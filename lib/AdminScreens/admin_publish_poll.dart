// // ignore_for_file: library_private_types_in_public_api

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:logger/logger.dart'; // Import the logger package
// import 'admin_create_poll.dart'; // Import the CreatePollScreen file if it's in another file

// // Initialize the logger
// final Logger logger = Logger();

// class PublishPollScreen extends StatefulWidget {
//   const PublishPollScreen({super.key});

//   @override
//   _PublishPollScreenState createState() => _PublishPollScreenState();
// }

// class _PublishPollScreenState extends State<PublishPollScreen> {
//   List<String> polls = []; // List to store poll IDs

//   // Callback to refresh the poll list after creating a poll
//   void refreshPollList(String pollId) {
//     setState(() {
//       polls.add(pollId); // Add the new poll ID to the list
//     });
//   }

//   Future<void> publishPoll(String pollId) async {
//     // Retrieve the token from SharedPreferences
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('jwt_token');

//     if (token == null) {
//       // If the user is not authenticated, show a SnackBar with the error message
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('User not authenticated')),
//         );
//       }
//       return;
//     }

//     final url = Uri.parse('http://localhost:5000/api/polls/publish/$pollId');
//     final headers = {
//       "Content-Type": "application/json",
//       "Authorization": "Bearer $token",
//     };

//     try {
//       final response = await http.put(url, headers: headers);

//       // Log the response for debugging purposes
//       logger.d('Response Status: ${response.statusCode}');
//       logger.d('Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         // Successfully published the poll
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Poll published successfully!')),
//           );

//           // Use addPostFrameCallback to navigate after the current frame
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => PublishPollSuccessScreen(pollId: pollId),
//               ),
//             );
//           });
//         }
//       } else {
//         // Handle error response
//         final responseBody = jsonDecode(response.body);
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Error: ${responseBody['message']}')),
//           );
//         }
//       }
//     } catch (e) {
//       logger.e('Error: $e'); // Log the error with logger

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Error connecting to server')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Publish Polls"),
//       ),
//       body: Column(
//         children: [
//           // Display the list of polls (this could be a list of poll objects)
//           Expanded(
//             child: ListView.builder(
//               itemCount: polls.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text('Poll ID: ${polls[index]}'),
//                   subtitle: const Text("Poll details here..."),
//                   trailing: IconButton(
//                     icon: const Icon(Icons.publish),
//                     onPressed: () {
//                       // Publish the poll
//                       publishPoll(polls[index]);
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
//           // Button to navigate to CreatePollScreen
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ElevatedButton(
//               onPressed: () {
//                 // Navigate to CreatePollScreen and pass the callback function
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => CreatePollScreen(
//                       refreshPollList: refreshPollList, // Passing callback
//                     ),
//                   ),
//                 );
//               },
//               child: const Text("Create New Poll"),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Create a new screen to show after a poll is successfully published
// class PublishPollSuccessScreen extends StatelessWidget {
//   final String pollId;

//   const PublishPollSuccessScreen({super.key, required this.pollId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Poll Published"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const Icon(
//               Icons.check_circle_outline,
//               color: Colors.green,
//               size: 80,
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'Poll with ID: $pollId has been published successfully!',
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context); // Navigate back to the previous screen
//               },
//               child: const Text('Go Back'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(const MaterialApp(
//     home: PublishPollScreen(), // Start with the PublishPollScreen
//   ));
// }

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:logger/logger.dart'; // Import the logger package

// class PublishPollScreen extends StatefulWidget {
//   final String pollId; // Poll ID to be published

//   // Constructor with required pollId parameter
//   const PublishPollScreen({super.key, required this.pollId});

//   @override
//   // ignore: library_private_types_in_public_api
//   _PublishPollScreenState createState() => _PublishPollScreenState();
// }

// class _PublishPollScreenState extends State<PublishPollScreen> {
//   // Publish poll method
//   Future<void> publishPoll() async {
//     final logger = Logger(); // Instantiate the logger locally inside the method
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('jwt_token');

//     if (token == null) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('User not authenticated')),
//         );
//       }
//       return;
//     }

//     final url =
//         Uri.parse('http://localhost:5000/api/polls/publish/${widget.pollId}');
//     final headers = {
//       "Content-Type": "application/json",
//       "Authorization": "Bearer $token",
//     };

//     try {
//       final response = await http.put(url, headers: headers);

//       // Log the full response body and status code using the logger
//       logger.d('Response body: ${response.body}');
//       logger.d('Response status code: ${response.statusCode}');

//       // Handle the response based on the status code
//       if (response.statusCode == 200) {
//         // Successfully published the poll
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Poll published successfully!')),
//           );
//         }

//         // Optionally navigate away or refresh poll list
//         if (mounted) {
//           Navigator.pop(context); // Go back to the previous screen
//         }
//       } else {
//         // Log unexpected status codes for debugging
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Error: ${response.body}')),
//           );
//         }
//         logger.e('Error: ${response.statusCode} - ${response.body}');
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Error connecting to server')),
//         );
//       }
//       logger.e('Error connecting to server: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Publish Poll"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             ElevatedButton(
//               onPressed: publishPoll,
//               child: const Text('Publish Poll'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PublishPollScreen extends StatefulWidget {
  final String pollId; // Poll ID passed from AdminDashboard

  const PublishPollScreen({super.key, required this.pollId});

  @override
  // ignore: library_private_types_in_public_api
  _PublishPollScreenState createState() => _PublishPollScreenState();
}

class _PublishPollScreenState extends State<PublishPollScreen> {
  late Map<String, dynamic> pollDetails =
      {}; // Initialize pollDetails to prevent null issues
  final Logger logger = Logger();

  String? token;

  @override
  void initState() {
    super.initState();
    fetchPollDetails(); // Call the fetch method when the screen is initialized
  }

  Future<void> fetchPollDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('jwt_token'); // Retrieve the token

    if (token == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated')),
        );
      }
      return;
    }

    logger.d('Token retrieved: $token');
    logger.d(
        'Poll ID: ${widget.pollId}'); // Log the pollId to ensure it's correct

    // Fetch the poll details to show on the screen
    final url = Uri.parse('http://localhost:5000/api/polls/${widget.pollId}');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        logger.d('Poll Details: $responseBody');

        if (mounted) {
          setState(() {
            pollDetails = responseBody[
                'poll']; // Assuming 'poll' is the key containing the poll data
          });
        }
      } else {
        logger.e('Failed to load poll details: ${response.statusCode}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to load poll details')),
          );
        }
      }
    } catch (e) {
      logger.e('Error during poll fetch: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error connecting to server')),
        );
      }
    }
  }

  Future<void> publishPoll() async {
    if (token == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated')),
        );
      }
      return;
    }

    final url =
        Uri.parse('http://localhost:5000/api/polls/publish/${widget.pollId}');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.put(url, headers: headers);

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Poll published successfully!')),
          );
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
      logger.e('Error during poll publish: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error connecting to server')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Publish Poll"),
      ),
      body: pollDetails.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Poll: ${pollDetails['title']}',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Question: ${pollDetails['question']}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Options:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...List<Widget>.from(
                      pollDetails['options']?.map<Widget>((option) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Text(option,
                                  style: const TextStyle(fontSize: 16)),
                            );
                          }) ??
                          []),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: publishPoll,
                    child: const Text("Publish Poll"),
                  ),
                ],
              ),
            ),
    );
  }
}
