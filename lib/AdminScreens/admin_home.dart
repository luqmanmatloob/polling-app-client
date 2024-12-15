// // import 'package:flutter/material.dart';
// // import 'package:polling_app/AdminScreens/admin_create_poll.dart';
// // import 'package:polling_app/AdminScreens/admin_publish_poll.dart';
// // import 'package:logger/logger.dart'; // Import the logger package

// // class AdminDashboard extends StatelessWidget {
// //   AdminDashboard({super.key});

// //   // Create a logger instance
// //   final Logger logger = Logger();

// //   // This method can be used to refresh the poll list after a poll is created
// //   void refreshPollList(String newPollId) {
// //     // Use the logger instead of print
// //     logger.i("Poll created with ID: $newPollId"); // Log the message
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     double screenWidth = MediaQuery.of(context).size.width;
// //     double screenHeight = MediaQuery.of(context).size.height;
// //     double fieldWidth = screenWidth * 0.45;
// //     double fieldHeight = screenHeight * 0.12;

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Admin Dashboard"),
// //       ),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             const Text(
// //               "Welcome to the Admin Dashboard!",
// //               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: 30),
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 SizedBox(
// //                   width: fieldWidth,
// //                   height: fieldHeight,
// //                   child: ElevatedButton(
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: Colors.blue,
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                       elevation: 5,
// //                       shadowColor: Colors.black.withOpacity(0.3),
// //                     ),
// //                     onPressed: () {
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(
// //                           builder: (context) => const PublishPollScreen(),
// //                         ),
// //                       );
// //                     },
// //                     child: const Text(
// //                       "Publish Poll",
// //                       style: TextStyle(fontSize: 18, color: Colors.white),
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(width: 20),
// //                 SizedBox(
// //                   width: fieldWidth,
// //                   height: fieldHeight,
// //                   child: ElevatedButton(
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: Colors.green,
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                       elevation: 5,
// //                       shadowColor: Colors.black.withOpacity(0.3),
// //                     ),
// //                     onPressed: () {
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(
// //                           builder: (context) => CreatePollScreen(
// //                             refreshPollList:
// //                                 refreshPollList, // Pass the callback here
// //                           ),
// //                         ),
// //                       );
// //                     },
// //                     child: const Text(
// //                       "Create Poll",
// //                       style: TextStyle(fontSize: 18, color: Colors.white),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

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

//     // Assume you get the pollId from the creation process or an API response
//     String pollId =
//         "yourPollId"; // Replace with the actual pollId after creation

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
//                           builder: (context) => PublishPollScreen(
//                             pollId: pollId, // Pass the pollId here
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
import 'package:polling_app/AdminScreens/admin_create_poll.dart';
import 'package:polling_app/AdminScreens/admin_publish_poll.dart';
import 'package:logger/logger.dart'; // Import the logger package

class AdminDashboard extends StatelessWidget {
  AdminDashboard({super.key});

  // Create a logger instance
  final Logger logger = Logger();

  // This method can be used to refresh the poll list after a poll is created
  void refreshPollList(String newPollId) {
    // Use the logger instead of print
    logger.i("Poll created with ID: $newPollId"); // Log the message
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double fieldWidth = screenWidth * 0.45;
    double fieldHeight = screenHeight * 0.12;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to the Admin Dashboard!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: fieldWidth,
                  height: fieldHeight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                      shadowColor: Colors.black.withOpacity(0.3),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PublishPollScreen(
                            pollId:
                                "yourPollId", // Replace this with actual pollId
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "Publish Poll",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: fieldWidth,
                  height: fieldHeight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                      shadowColor: Colors.black.withOpacity(0.3),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreatePollScreen(
                            refreshPollList:
                                refreshPollList, // Pass the callback here
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "Create Poll",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
