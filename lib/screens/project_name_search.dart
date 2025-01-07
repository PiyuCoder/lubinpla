import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lubinpla/helpers/pref_data.dart';

// Function to fetch projects based on the search query
Future<List<String>> fetchProjects(String query) async {
  final token = await getSavedData("token");

  // If query is empty, return an empty list (no results)
  if (query.isEmpty) return [];

  // Fetching the projects based on the search query
  final response = await http.get(
    Uri.parse('http://15.165.115.39:8080/api/projects'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    final mergedData = [
      query,
      ...data.map((project) => project['name'].toString()).toList()
    ];
    return mergedData;
  } else {
    throw Exception('Failed to load projects');
  }
}

class ProjectNameSearchScreen extends StatefulWidget {
  final Function(String selectedProject) onProjectSelected;

  ProjectNameSearchScreen({required this.onProjectSelected});

  @override
  _ProjectNameSearchScreenState createState() =>
      _ProjectNameSearchScreenState();
}

class _ProjectNameSearchScreenState extends State<ProjectNameSearchScreen> {
  late Future<List<String>> projects;
  TextEditingController _searchController = TextEditingController();
  String currentSearchTerm = "";

  @override
  void initState() {
    super.initState();
    projects = Future.value([]); // Initialize with an empty list
  }

  // Function to handle search term changes
  void onSearchChanged(String query) {
    setState(() {
      currentSearchTerm = query; // Update the search term
      projects =
          fetchProjects(query); // Fetch projects based on the search term
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          style: IconButton.styleFrom(overlayColor: Colors.transparent),
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: RichText(
            text: const TextSpan(
              text: '프로젝트명 입력',
              style: TextStyle(
                fontSize: 18.0, // Main title size
                color: Colors.black, // AppBar text color
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search field at the top
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,

                    decoration: InputDecoration(
                      hintText: "입력해주세요",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.0),
                          borderSide: BorderSide.none),
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey.shade500,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                        },
                      ),
                    ),

                    onChanged: onSearchChanged, // Update search term on change
                    onSubmitted: (value) {
                      widget
                          .onProjectSelected(value); // Set the project on Enter
                      Navigator.pop(context); // Close the search screen
                    },
                  ),
                ),
              ],
            ),
          ),
          // Display the list of matching projects
          Expanded(
            child: FutureBuilder<List<String>>(
              future: projects,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No projects found.'));
                } else {
                  final projectList = snapshot.data!;

                  return ListView.builder(
                    itemCount: projectList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(projectList[index]),
                        onTap: () {
                          widget.onProjectSelected(currentSearchTerm);
                          Navigator.pop(context,
                              currentSearchTerm); // Close search screen after selection
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
