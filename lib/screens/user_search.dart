// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// Future<List<Map<String, String>>> fetchUsers(String query) async {
//   const String token =
//       "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxMyIsImlhdCI6MTczMjQ1OTEwNywiZXhwIjoxNzMyNDk1MTA3fQ.c-kDV1rzUstoMjb5LCi7sHQA2hngDK80-5De2JIQqO3_hBgkZDMC6MZepoae4DKzv8VVMOmXUvWj-U_fac0gnA";

//   final response = await http.get(
//     Uri.parse('http://15.165.115.39:8080/api/users?search=$query'),
//     headers: {
//       'Authorization': 'Bearer $token', // Pass the token in the header
//     },
//   );

//   if (response.statusCode == 200) {
//     List<dynamic> data = json.decode(response.body);
//     return data.map((user) {
//       return {
//         'id': user['_id'].toString(),
//         'name': user['name'].toString(),
//       };
//     }).toList();
//   } else {
//     throw Exception('Failed to load users');
//   }
// }

// class UserSearchScreen extends StatefulWidget {
//   final String userType; // Added userType to differentiate the selection
//   final Function(Map<String, String> selectedUser) onUserSelected;

//   UserSearchScreen({required this.userType, required this.onUserSelected});

//   @override
//   _UserSearchScreenState createState() => _UserSearchScreenState();
// }

// class _UserSearchScreenState extends State<UserSearchScreen> {
//   List<Map<String, String>> users = [];
//   bool isLoading = false;
//   String query = '';

//   void searchUsers(String query) async {
//     if (query.isEmpty) {
//       setState(() {
//         users = [];
//       });
//       return;
//     }

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final fetchedUsers = await fetchUsers(query);
//       setState(() {
//         users = fetchedUsers;
//       });
//     } catch (e) {
//       setState(() {
//         users = [];
//       });
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Search ${widget.userType.capitalize()}")),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               onChanged: (value) {
//                 setState(() {
//                   query = value;
//                 });
//                 searchUsers(value);
//               },
//               decoration: InputDecoration(
//                 hintText: "Type to search...",
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//             ),
//           ),
//           if (isLoading)
//             Center(child: CircularProgressIndicator())
//           else if (users.isEmpty && query.isNotEmpty)
//             Expanded(
//               child: Center(
//                 child: Text('No users found.'),
//               ),
//             )
//           else
//             Expanded(
//               child: ListView.builder(
//                 itemCount: users.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(users[index]['name']!),
//                     onTap: () {
//                       widget.onUserSelected(users[index]);
//                       Navigator.pop(context); // Close the search screen
//                     },
//                   );
//                 },
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// // Extension to capitalize the first letter of strings
// extension StringCapitalizeExtension on String {
//   String capitalize() {
//     if (this.isEmpty) {
//       return this;
//     } else {
//       return '${this[0].toUpperCase()}${this.substring(1)}';
//     }
//   }
// }

import 'package:flutter/material.dart';

Future<List<Map<String, String>>> fetchUsers(String query) async {
  // Dummy data for demonstration
  List<Map<String, String>> users = [
    {
      'id': '1',
      'name': 'John Doe',
      'profilePic':
          'https://i.pinimg.com/736x/a1/68/7d/a1687d6a07d8b194e417c4edaf1f1dd0.jpg'
    },
    {
      'id': '2',
      'name': 'Jane Smith',
      'profilePic':
          'https://deadline.com/wp-content/uploads/2024/04/MCDTHTH_EC139.jpg'
    },
    {
      'id': '3',
      'name': 'Sam Wilson',
      'profilePic':
          'https://i.pinimg.com/736x/2a/cc/8a/2acc8a69869094939664891dcf00c2e2.jpg'
    },
    {
      'id': '4',
      'name': 'Alice Johnson',
      'profilePic':
          'https://imgcdn.stablediffusionweb.com/2024/9/6/dc7ff734-413c-4d0c-a6fd-07a9ffc43ba5.jpg'
    },
  ];

  return users
      .where(
          (user) => user['name']!.toLowerCase().contains(query.toLowerCase()))
      .toList();
}

class UserSearchScreen extends StatefulWidget {
  final String userType; // 'collaborator' or 'share'
  final Function(List<Map<String, String>> selectedUsers) onUserSelected;
  final List<Map<String, String>>
      initialSelectedUsers; // New field to pass initial users

  UserSearchScreen({
    required this.userType,
    required this.onUserSelected,
    required this.initialSelectedUsers, // Receive initial selected users
  });

  @override
  _UserSearchScreenState createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  List<Map<String, String>> users = [];
  bool isLoading = false;
  String query = '';
  Set<Map<String, String>> selectedUsers = {};

  @override
  void initState() {
    super.initState();
    // Initialize selectedUsers differently for collaborator and share
    if (widget.userType == 'collaborator') {
      // For collaborator, select only one user, so we expect a single user or an empty list
      // selectedUsers = Set.from(widget.initialSelectedUsers.isNotEmpty
      //     ? [widget.initialSelectedUsers[0]]
      //     : []);
    } else if (widget.userType == 'share') {
      // For share, allow multiple users to be selected
      selectedUsers = Set.from(widget.initialSelectedUsers);
    }
  }

  void searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() {
        users = [];
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final fetchedUsers = await fetchUsers(query);

      // Filter out users that are already in selectedUsers based on their ID
      final filteredUsers = fetchedUsers.where((user) {
        // Assuming each user has an 'id' field that is unique
        return !selectedUsers
            .any((selectedUser) => selectedUser['id'] == user['id']);
      }).toList();

      setState(() {
        users =
            filteredUsers; // Update the list to only include unselected users
      });
    } catch (e) {
      setState(() {
        users = [];
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search ${widget.userType}"),
        actions: [
          if (widget.userType == "share")
            TextButton(
              onPressed: selectedUsers.isNotEmpty
                  ? () {
                      // Add your go back functionality here, such as Navigator.pop(context)
                      Navigator.pop(
                          context); // This will navigate back to the previous screen
                    }
                  : null, // Disable the button when no users are selected
              child: Text(
                '완료',
                style: TextStyle(
                  color: selectedUsers.isNotEmpty ? Colors.black : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Tags Row (Show already selected users as tags)

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  query = value;
                });
                searchUsers(value);
              },
              decoration: InputDecoration(
                hintText: "Type to search...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: selectedUsers.map((user) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Text(
                          user['name']!,
                          style: const TextStyle(color: Colors.black),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle,
                              color: Colors.red),
                          onPressed: () {
                            setState(() {
                              selectedUsers.remove(user);
                            });
                            widget.onUserSelected(List.from(selectedUsers));
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Loading/Empty States
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (users.isEmpty && query.isNotEmpty)
            Expanded(
              child: const Center(child: Text('No users found.')),
            )
          else
            // List of Users
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  bool isSelected = selectedUsers.contains(user);

                  print(selectedUsers);

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user['profilePic']!),
                    ),
                    title: Text(user['name']!),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : const Icon(Icons.circle),
                    onTap: () {
                      if (widget.userType == 'share') {
                        // Multiple users can be selected for 'share'
                        setState(() {
                          if (isSelected) {
                            selectedUsers.remove(user);
                          } else {
                            selectedUsers.add(user);
                          }
                        });
                        widget.onUserSelected(List.from(selectedUsers));
                      } else {
                        // Only one user selected for 'collaborator'
                        selectedUsers
                            .clear(); // Clear previous selection for collaborator
                        // selectedUsers.add(user); // Add new selected user
                        widget.onUserSelected(
                            [user]); // Pass the selected user back
                        Navigator.pop(context);
                      }
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
