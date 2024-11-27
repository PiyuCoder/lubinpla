import 'package:flutter/material.dart';
import 'package:lubinpla/models/project_create_data.dart';
import 'package:lubinpla/screens/create_project_screen.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  TextEditingController searchController = TextEditingController();
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // No shadow
        title: const Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: const Text(
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
            padding: EdgeInsets.zero,
            onPressed: () {
              // Handle search action
            },
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            padding: EdgeInsets.zero,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateProjectScreen(
                    selectedIndex: 0,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            padding: EdgeInsets.zero,
            onPressed: () {
              // Handle notification action
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(61, 218, 218, 218),
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
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
                        hintText: '',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.keyboard_arrow_down,
                              color: Colors.grey),
                          style: IconButton.styleFrom(
                              overlayColor: Colors.transparent),
                          onPressed: () {
                            searchController.clear();
                          },
                        ),
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
