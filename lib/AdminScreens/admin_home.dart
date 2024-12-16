// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:polling_app/AdminScreens/admin_create_poll.dart';
// import 'package:logger/logger.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AdminDashboard extends StatefulWidget {
//   const AdminDashboard({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _AdminDashboardState createState() => _AdminDashboardState();
// }

// class _AdminDashboardState extends State<AdminDashboard> {
//   final Logger logger = Logger(); // Logger instance
//   List<Map<String, dynamic>> polls = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchPolls(); // Fetch polls on initialization
//   }

//   // Fetch polls from the API
//   Future<void> fetchPolls() async {
//     const url = 'http://localhost:5000/api/polls';

//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('jwt_token');

//     if (token == null) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please log in again')),
//         );
//       }
//       return;
//     }

//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {'Authorization': 'Bearer $token'},
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (mounted) {
//           setState(() {
//             polls = List<Map<String, dynamic>>.from(data);
//             isLoading = false;
//           });
//         }
//       } else {
//         logger.e('Failed to fetch polls: ${response.statusCode}');
//         if (mounted) {
//           setState(() {
//             isLoading = false;
//           });
//         }
//       }
//     } catch (e) {
//       logger.e('Error fetching polls: $e');
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     }
//   }

//   // Publish a poll
//   Future<void> publishPoll(String pollId) async {
//     final url = 'http://localhost:5000/api/polls/publish/$pollId';

//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('jwt_token');

//     if (token == null) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please log in again')),
//         );
//       }
//       return;
//     }

//     try {
//       final response = await http.put(
//         Uri.parse(url),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         final message = json.decode(response.body)['message'];
//         logger.i(message);
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(message)),
//           );
//           fetchPolls(); // Refresh the poll list
//         }
//       } else {
//         logger.e('Failed to publish poll: ${response.statusCode}');
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Failed to publish poll')),
//           );
//         }
//       }
//     } catch (e) {
//       logger.e('Error publishing poll: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Error publishing poll')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Admin Dashboard"),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : RefreshIndicator(
//               onRefresh: fetchPolls,
//               child: ListView.builder(
//                 padding: const EdgeInsets.all(16),
//                 itemCount: polls.length,
//                 itemBuilder: (context, index) {
//                   final poll = polls[index];
//                   return Card(
//                     margin: const EdgeInsets.only(bottom: 16),
//                     elevation: 4,
//                     child: ListTile(
//                       title: Text(
//                         poll['title'] ?? 'No Title',
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       subtitle:
//                           Text('Created At: ${poll['createdAt'] ?? 'Unknown'}'),
//                       trailing: ElevatedButton(
//                         onPressed: () => publishPoll(poll['_id'] ?? ''),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue,
//                         ),
//                         child: const Text(
//                           "Publish",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Navigate to CreatePollScreen and refresh when returning
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const CreatePollScreen(),
//             ),
//           ).then((pollCreated) {
//             if (pollCreated == true) {
//               fetchPolls(); // Refresh polls on return
//             }
//           });
//         },
//         backgroundColor: Colors.green,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// // import 'package:polling_app/AdminScreens/admin_create_poll.dart';
// // import 'package:logger/logger.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// // class AdminDashboard extends StatefulWidget {
// //   const AdminDashboard({super.key});

// //   @override
// //   // ignore: library_private_types_in_public_api
// //   _AdminDashboardState createState() => _AdminDashboardState();
// // }

// // class _AdminDashboardState extends State<AdminDashboard> {
// //   final Logger logger = Logger(); // Logger instance
// //   List<Map<String, dynamic>> polls = [];
// //   bool isLoading = true;

// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchPolls(); // Fetch polls on initialization
// //   }

// //   // Fetch polls from the API
// //   Future<void> fetchPolls() async {
// //     const url = 'http://localhost:5000/api/polls';

// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String? token = prefs.getString('jwt_token');

// //     if (token == null) {
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text('Please log in again')),
// //         );
// //       }
// //       return;
// //     }

// //     try {
// //       final response = await http.get(
// //         Uri.parse(url),
// //         headers: {'Authorization': 'Bearer $token'},
// //       );

// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         if (mounted) {
// //           setState(() {
// //             polls = List<Map<String, dynamic>>.from(data);
// //             isLoading = false;
// //           });
// //         }
// //       } else {
// //         logger.e('Failed to fetch polls: ${response.statusCode}');
// //         if (mounted) {
// //           setState(() {
// //             isLoading = false;
// //           });
// //         }
// //       }
// //     } catch (e) {
// //       logger.e('Error fetching polls: $e');
// //       if (mounted) {
// //         setState(() {
// //           isLoading = false;
// //         });
// //       }
// //     }
// //   }

// //   // Publish a poll
// //   Future<void> publishPoll(String pollId) async {
// //     final url = 'http://localhost:5000/api/polls/publish/$pollId';

// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String? token = prefs.getString('jwt_token');

// //     if (token == null) {
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text('Please log in again')),
// //         );
// //       }
// //       return;
// //     }

// //     try {
// //       final response = await http.put(
// //         Uri.parse(url),
// //         headers: {
// //           'Authorization': 'Bearer $token',
// //           'Content-Type': 'application/json',
// //         },
// //       );

// //       if (response.statusCode == 200) {
// //         final message = json.decode(response.body)['message'];
// //         logger.i(message);
// //         if (mounted) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(content: Text(message)),
// //           );
// //           fetchPolls(); // Refresh the poll list
// //         }
// //       } else {
// //         logger.e('Failed to publish poll: ${response.statusCode}');
// //         if (mounted) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             const SnackBar(content: Text('Failed to publish poll')),
// //           );
// //         }
// //       }
// //     } catch (e) {
// //       logger.e('Error publishing poll: $e');
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text('Error publishing poll')),
// //         );
// //       }
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Admin Dashboard"),
// //       ),
// //       body: isLoading
// //           ? const Center(child: CircularProgressIndicator())
// //           : RefreshIndicator(
// //               onRefresh: fetchPolls,
// //               child: ListView.builder(
// //                 padding: const EdgeInsets.all(16),
// //                 itemCount: polls.length,
// //                 itemBuilder: (context, index) {
// //                   final poll = polls[index];
// //                   return Card(
// //                     margin: const EdgeInsets.only(bottom: 16),
// //                     elevation: 4,
// //                     child: ListTile(
// //                       title: Text(
// //                         poll['title'] ?? 'No Title',
// //                         style: const TextStyle(
// //                           fontSize: 18,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                       subtitle:
// //                           Text('Created At: ${poll['createdAt'] ?? 'Unknown'}'),
// //                       trailing: ElevatedButton(
// //                         onPressed: () => publishPoll(poll['_id'] ?? ''),
// //                         style: ElevatedButton.styleFrom(
// //                           backgroundColor: Colors.blue,
// //                         ),
// //                         child: const Text(
// //                           "Publish",
// //                           style: TextStyle(color: Colors.white),
// //                         ),
// //                       ),
// //                     ),
// //                   );
// //                 },
// //               ),
// //             ),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () async {
// //           // Navigate to CreatePollScreen and pass a callback to refresh the poll list
// //           final result = await Navigator.push(
// //             context,
// //             MaterialPageRoute(
// //               builder: (context) => const CreatePollScreen(),
// //             ),
// //           );
// //           if (result == true) {
// //             // If a new poll is created, refresh the poll list
// //             fetchPolls();
// //           }
// //         },
// //         backgroundColor: Colors.green,
// //         child: const Icon(Icons.add),
// //       ),
// //     );
// //   }
// // }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:polling_app/AdminScreens/admin_create_poll.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin_publish_poll_results.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final Logger logger = Logger(); // Logger instance
  List<Map<String, dynamic>> polls = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPolls(); // Fetch polls on initialization
  }

  // Fetch polls from the API
  Future<void> fetchPolls() async {
    const url = 'http://localhost:5000/api/polls';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token == null) {
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

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token == null) {
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
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PublishedPollsScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text(
                      "View Published Poll Results",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: fetchPolls,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: polls.length,
                      itemBuilder: (context, index) {
                        final poll = polls[index];
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
                            subtitle: Text(
                                'Created At: ${poll['createdAt'] ?? 'Unknown'}'),
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
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreatePollScreen(),
            ),
          ).then((pollCreated) {
            if (pollCreated == true) {
              fetchPolls(); // Refresh polls on return
            }
          });
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
