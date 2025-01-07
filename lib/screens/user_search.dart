import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lubinpla/helpers/pref_data.dart';

Future<List<Map<String, String>>> fetchUsers(String query) async {
  String? token = await getSavedData("token");

  final response = await http.get(
    Uri.parse('http://15.165.115.39:8080/api/users/all'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((user) {
      return {
        'id': user['id'].toString(),
        'name': user['name'].toString(),
        'email': user['email']?.toString() ?? '',
        'image': user['image']?.toString() ?? 'default_img_url',
        'companyName': user['companyName']?.toString() ?? 'N/A',
        'companyResponsibility':
            user['companyResponsibility']?.toString() ?? 'N/A',
      };
    }).toList();
  } else {
    throw Exception('Failed to fetch users: ${response.reasonPhrase}');
  }
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
  bool showTags = true; // Toggle for showing/hiding tags

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.userType == 'share') {
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

      final filteredUsers = fetchedUsers.where((user) {
        return !selectedUsers
            .any((selectedUser) => selectedUser['id'] == user['id']);
      }).toList();

      setState(() {
        users = filteredUsers;
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

  void resetSearch() {
    setState(() {
      query = '';
      users = [];
    });
    searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          style: IconButton.styleFrom(overlayColor: Colors.transparent),
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          '공동 작업자 선택',
          style: TextStyle(
              fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (widget.userType == "share")
            TextButton(
              onPressed: selectedUsers.isNotEmpty
                  ? () {
                      Navigator.pop(context);
                    }
                  : null,
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
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  query = value;
                });
                searchUsers(value);
              },
              decoration: InputDecoration(
                hintText: "입력해주세요",
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade500,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      query = '';
                      users = [];
                    });
                    searchController.clear();
                  },
                ),
                fillColor: Colors.grey.shade100,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Tags Section
          if (selectedUsers.isNotEmpty)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        showTags
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up,
                      ),
                      onPressed: () {
                        setState(() {
                          showTags = !showTags;
                        });
                      },
                    ),
                  ],
                ),
                if (showTags)
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: selectedUsers.map((user) {
                        return Container(
                          padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                user['name']!,
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedUsers.remove(user);
                                  });
                                  widget
                                      .onUserSelected(List.from(selectedUsers));
                                },
                                child: const Icon(Icons.cancel,
                                    color: Colors.white, size: 16),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),

          if (widget.userType == 'share' && selectedUsers.isNotEmpty)
            const Padding(
              padding: const EdgeInsets.fromLTRB(10, 12, 10, 20),
              child: const Divider(
                color: Colors.black12,
                thickness: 1.0,
                height: 1.0,
              ),
            ),

          // Loading/Empty States
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (users.isEmpty && query.isNotEmpty)
            const Expanded(child: Center(child: Text('No users found.')))
          else
            // List of Users
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  bool isSelected = selectedUsers.contains(user);

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: user['image']!.isNotEmpty
                          ? NetworkImage(user['image']!)
                          : null,
                      child: user['image']!.isEmpty
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    title: Text(user['name']!),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${user['email']!}'),
                        if (user['companyName'] != 'N/A')
                          Text('Company: ${user['companyName']}'),
                        if (user['companyResponsibility'] != 'N/A')
                          Text(
                              'Responsibility: ${user['companyResponsibility']}'),
                      ],
                    ),
                    onTap: () {
                      if (widget.userType == 'share') {
                        setState(() {
                          selectedUsers.add(user);
                          resetSearch();
                        });
                        widget.onUserSelected(List.from(selectedUsers));
                      } else {
                        widget.onUserSelected([user]);
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
