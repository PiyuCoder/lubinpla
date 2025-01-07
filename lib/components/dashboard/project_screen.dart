import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lubinpla/helpers/pref_data.dart';
import 'package:lubinpla/screens/create_project_screen.dart';
import 'package:http/http.dart' as http;

final List<Map<String, dynamic>> dummy = [
  {
    "name": "project1",
    "members": {
      "owner": "john.doe@example.com",
      "coworker": "jane.smith@example.com",
      "referencePartners": ["bob.wilson@example.com", "alice.jones@example.com"]
    },
    "category": {
      "industry": {"id": 2, "name": "Animal동물"},
      "category": {"id": 4, "name": "Mammals포유류"},
      "attr1": {"id": 8, "name": "Dog개"},
      "attr2": {"id": 15, "name": "Beagle비글"}
    },
    "conditions": [
      {"id": 1, "value": "30cm"},
      {"id": 2, "value": "6kg"},
      {"id": 3, "value": "3"},
      {
        "name": "Color",
        "value": "black and white",
        "description": "Fur color",
        "custom": true
      }
    ],
    "usage": {
      "solution": "Cloud Storage",
      "quantity": "500GB",
      "providedDate": "2024-03-20"
    }
  },
  {
    "name": "project2",
    "members": {
      "owner": "john.doe@example.com",
      "coworker": "jane.smith@example.com",
      "referencePartners": ["bob.wilson@example.com", "alice.jones@example.com"]
    },
    "category": {
      "industry": {"id": 2, "name": "Animal동물"},
      "category": {"id": 4, "name": "Mammals포유류"},
      "attr1": {"id": 8, "name": "Dog개"},
      "attr2": {"id": 15, "name": "Beagle비글"}
    },
    "conditions": [
      {"id": 1, "value": "30cm"},
      {"id": 2, "value": "6kg"},
      {"id": 3, "value": "3"},
      {
        "name": "Color",
        "value": "black and white",
        "description": "Fur color",
        "custom": true
      }
    ],
    "usage": {
      "solution": "Cloud Storage",
      "quantity": "500GB",
      "providedDate": "2024-03-20"
    }
  }
];

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  TextEditingController searchController = TextEditingController();
  List<dynamic> projects = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchProjects();
  }

  Future<void> fetchProjects() async {
    const String apiUrl =
        'http://15.165.115.39:8080/api/projects'; // Replace with your API URL
    String? token =
        await getSavedData('token'); // Replace with the actual token
    String? email =
        await getSavedData('email'); // Replace with the actual token

    print(token);
    print(email);

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          projects = data ?? [];
          isLoading = false;
          hasError = false;
        });
      } else {
        setState(() {
          isLoading = false;
          hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
      print('Error fetching projects: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // No shadow
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            '프로젝트',
            style: TextStyle(
              color: Colors.black, // Title color
              fontSize: 20, // Title font size
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        titleSpacing: 0, // Align the title to the left
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Handle search action
            },
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateProjectScreen(
                    selectedIndex: 0,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              // Handle notification action
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? const Center(child: Text('Failed to load projects.'))
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSearchBar(),
                      const SizedBox(height: 20),
                      const Text(
                        "Projects",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: projects.length,
                          itemBuilder: (context, index) {
                            final project = projects[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage:
                                          const AssetImage('assets/logo.png'),
                                      backgroundColor: Colors.grey.shade300,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(
                                          project['name'] ?? 'Unnamed Project',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        trailing:
                                            const Icon(Icons.arrow_forward_ios),
                                        onTap: () {
                                          // Handle project selection
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CreateProjectScreen(
                                                selectedIndex: 0,
                                                projectId: project[
                                                    'id'], // Pass project ID
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
      decoration: const BoxDecoration(
        color: Color.fromARGB(61, 218, 218, 218),
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      child: Row(
        children: [
          const Text(
            "업데이트",
            style: TextStyle(fontSize: 16.0, color: Colors.black38),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search projects',
                suffixIcon: IconButton(
                  icon:
                      const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  onPressed: () {
                    searchController.clear();
                  },
                ),
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
