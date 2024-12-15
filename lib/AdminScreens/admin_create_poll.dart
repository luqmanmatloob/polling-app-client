// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:logger/logger.dart'; // Import the logger package

// // Declare a GlobalKey for Navigator
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// // Initialize the logger
// final Logger logger = Logger();

// class CreatePollScreen extends StatefulWidget {
//   final Function?
//       refreshPollList; // Callback to refresh poll list in PublishPollScreen
//   const CreatePollScreen({super.key, this.refreshPollList});

//   @override
//   State<CreatePollScreen> createState() => _CreatePollScreenState();
// }

// class _CreatePollScreenState extends State<CreatePollScreen> {
//   final _questionController = TextEditingController();
//   final _optionController1 = TextEditingController();
//   final _optionController2 = TextEditingController();
//   final _optionController3 = TextEditingController();

//   Future<void> createPoll() async {
//     // Retrieve the poll question and options from the controllers
//     String question = _questionController.text;
//     List<String> options = [
//       _optionController1.text,
//       _optionController2.text,
//       _optionController3.text,
//     ];

//     // Prepare the data for the request
//     final pollData = {
//       "title": "Poll", // You can customize the title
//       "question": question,
//       "options": options,
//     };

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

//     final url = Uri.parse('http://localhost:5000/api/polls/create');
//     final headers = {
//       "Content-Type": "application/json",
//       "Authorization": "Bearer $token",
//     };
//     final body = jsonEncode(pollData);

//     try {
//       final response = await http.post(url, headers: headers, body: body);

//       // Log the response for debugging purposes
//       logger.d('Response Status: ${response.statusCode}');
//       logger.d('Response Body: ${response.body}');

//       if (response.statusCode == 201) {
//         // Successfully created the poll
//         final responseBody = jsonDecode(response.body);
//         final String pollId =
//             responseBody['id'] ?? ''; // Ensure 'id' is in response

//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Poll created successfully!')),
//           );
//         }

//         // Return the created poll ID to PublishPollScreen
//         if (widget.refreshPollList != null) {
//           widget.refreshPollList!(pollId);
//         }

//         // Use the navigatorKey to pop without context
//         if (mounted) {
//           Future.delayed(const Duration(milliseconds: 500), () {
//             // Pop using navigatorKey instead of context
//             navigatorKey.currentState?.pop();
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
//         title: const Text("Create Poll"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 20),
//             const Text(
//               "Enter Poll Question",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             TextField(
//               controller: _questionController,
//               decoration: const InputDecoration(
//                 hintText: 'Enter your poll question',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               "Enter Poll Options",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             TextField(
//               controller: _optionController1,
//               decoration: const InputDecoration(
//                 hintText: 'Option 1',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _optionController2,
//               decoration: const InputDecoration(
//                 hintText: 'Option 2',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _optionController3,
//               decoration: const InputDecoration(
//                 hintText: 'Option 3',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 30),
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: createPoll,
//                 child: const Text("Create Poll"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     navigatorKey: navigatorKey, // Set the navigator key
//     home: const CreatePollScreen(), // Start with the CreatePollScreen
//   ));
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:logger/logger.dart'; // Import the logger package

// // Declare a GlobalKey for Navigator
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// // Initialize the logger
// final Logger logger = Logger();

// class CreatePollScreen extends StatefulWidget {
//   final Function?
//       refreshPollList; // Callback to refresh poll list in PublishPollScreen
//   const CreatePollScreen({super.key, this.refreshPollList});

//   @override
//   State<CreatePollScreen> createState() => _CreatePollScreenState();
// }

// class _CreatePollScreenState extends State<CreatePollScreen> {
//   final _questionController = TextEditingController();
//   final _optionController1 = TextEditingController();
//   final _optionController2 = TextEditingController();
//   final _optionController3 = TextEditingController();

//   Future<void> createPoll() async {
//     // Retrieve the poll question and options
//     String question = _questionController.text;
//     List<String> options = [
//       _optionController1.text,
//       _optionController2.text,
//       _optionController3.text,
//     ];

//     // Prepare poll data
//     final pollData = {
//       "title": "Poll",
//       "question": question,
//       "options": options,
//     };

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

//     final url = Uri.parse('http://localhost:5000/api/polls/create');
//     final headers = {
//       "Content-Type": "application/json",
//       "Authorization": "Bearer $token",
//     };

//     try {
//       final response =
//           await http.post(url, headers: headers, body: jsonEncode(pollData));

//       logger.d('Backend Response: ${response.body}'); // Log the full response

//       if (response.statusCode == 201) {
//         final responseBody = jsonDecode(response.body);

//         // Extract poll ID from the nested `poll` key
//         final String? pollId = responseBody['poll']?['_id'];

//         if (pollId != null) {
//           logger.i("Poll created with ID: $pollId");
//           if (widget.refreshPollList != null) {
//             widget.refreshPollList!(pollId); // Pass pollId to the dashboard
//           }
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Poll created successfully!')),
//             );
//             Navigator.pop(context); // Close the Create Poll screen
//           }
//         } else {
//           logger.e("Poll ID not found in the response.");
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Error: Poll ID not returned')),
//             );
//           }
//         }
//       } else {
//         final responseBody = jsonDecode(response.body);
//         final String errorMessage =
//             responseBody['message'] ?? 'Unknown error occurred';
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Error: $errorMessage')),
//           );
//         }
//       }
//     } catch (e) {
//       logger.e("Error during poll creation: $e");
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
//         title: const Text("Create Poll"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 20),
//             const Text(
//               "Enter Poll Question",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             TextField(
//               controller: _questionController,
//               decoration: const InputDecoration(
//                 hintText: 'Enter your poll question',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               "Enter Poll Options",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             TextField(
//               controller: _optionController1,
//               decoration: const InputDecoration(
//                 hintText: 'Option 1',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _optionController2,
//               decoration: const InputDecoration(
//                 hintText: 'Option 2',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _optionController3,
//               decoration: const InputDecoration(
//                 hintText: 'Option 3',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 30),
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: createPoll,
//                 child: const Text("Create Poll"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     navigatorKey: navigatorKey, // Set the navigator key
//     home: const CreatePollScreen(), // Start with the CreatePollScreen
//   ));
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class CreatePollScreen extends StatefulWidget {
  final Function? refreshPollList; // Callback to refresh the poll list
  const CreatePollScreen({super.key, this.refreshPollList});

  @override
  State<CreatePollScreen> createState() => _CreatePollScreenState();
}

class _CreatePollScreenState extends State<CreatePollScreen> {
  final _questionController = TextEditingController();
  final _optionController1 = TextEditingController();
  final _optionController2 = TextEditingController();
  final _optionController3 = TextEditingController();

  final Logger logger = Logger();

  Future<void> createPoll() async {
    // Retrieve the poll question and options
    String question = _questionController.text;
    List<String> options = [
      _optionController1.text,
      _optionController2.text,
      _optionController3.text,
    ];

    // Prepare poll data
    final pollData = {
      "title": "Poll",
      "question": question,
      "options": options,
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token == null) {
      // Check if the widget is still mounted before showing the SnackBar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated')),
        );
      }
      return;
    }

    final url = Uri.parse('http://localhost:5000/api/polls/create');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response =
          await http.post(url, headers: headers, body: jsonEncode(pollData));
      logger.d('Backend Response: ${response.body}'); // Log the full response

      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);

        // Extract poll ID from the response
        final String? pollId = responseBody['poll']?['_id'];

        if (pollId != null) {
          // Log and pass the pollId to the refreshPollList callback
          logger.i("Poll created with ID: $pollId");
          if (widget.refreshPollList != null) {
            widget.refreshPollList!(pollId); // Pass pollId to the dashboard
          }

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Poll created successfully!')),
            );
          }

          // Use Navigator to pop the screen after creation
          if (mounted) {
            Navigator.pop(context); // Close the Create Poll screen
          }
        } else {
          logger.e("Poll ID not found in the response.");
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error: Poll ID not returned')),
            );
          }
        }
      } else {
        final responseBody = jsonDecode(response.body);
        final String errorMessage =
            responseBody['message'] ?? 'Unknown error occurred';
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $errorMessage')),
          );
        }
      }
    } catch (e) {
      logger.e("Error during poll creation: $e");
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
        title: const Text("Create Poll"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Enter Poll Question",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(
                hintText: 'Enter your poll question',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Enter Poll Options",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _optionController1,
              decoration: const InputDecoration(
                hintText: 'Option 1',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _optionController2,
              decoration: const InputDecoration(
                hintText: 'Option 2',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _optionController3,
              decoration: const InputDecoration(
                hintText: 'Option 3',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: createPoll,
                child: const Text("Create Poll"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
