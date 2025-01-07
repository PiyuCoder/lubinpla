import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lubinpla/components/dashboard/project_screen.dart';
import 'package:lubinpla/components/project/date_selector.dart';
import 'package:lubinpla/components/project/division_section.dart';
import 'package:lubinpla/components/project/management_section.dart';
import 'package:lubinpla/components/project/condition_section.dart';
import 'package:lubinpla/components/project/product_name.dart';
import 'package:lubinpla/components/project/usage_amount.dart';
import 'package:lubinpla/helpers/pref_data.dart';
import 'package:lubinpla/models/project_create_data.dart';
import 'package:lubinpla/components/project/situation_section.dart';
import 'package:lubinpla/screens/dashboard.dart';
import 'package:lubinpla/screens/turning_rate_condition.dart';
import 'package:lubinpla/screens/turning_rate_detail.dart';
import 'package:lubinpla/screens/turning_rate_explain.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateProjectScreen extends StatefulWidget {
  final int selectedIndex;
  final String? projectId;

  const CreateProjectScreen(
      {super.key, required this.selectedIndex, this.projectId});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  late int _selectedIndex = 0;
  late List<Product> products = [];
  // late List<Condition> conditions = [];
  bool editingMode = false;
  bool _isLoading = true;

  // Data for all sections
  final List<SectionData> _sectionData = List.generate(4, (_) => SectionData());

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    print(_sectionData[1].owner);
    // Fetch project data if projectId is provided
    if (widget.projectId != null) {
      _initializeData();
      setState(() {
        editingMode = true;
        _selectedIndex = 0;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _initializeData() async {
    try {
      await fetchProjectData(widget.projectId!);
      setState(() {
        _isLoading = false; // Data fetching is complete
      });
    } catch (e) {
      print("Error initializing data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchProjectData(String projectId) async {
    const String apiBaseUrl = 'http://15.165.115.39:8080/api/projects';
    final String apiUrl = '$apiBaseUrl/$projectId';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print(jsonDecode(response.body)); // Debugging log
      if (response.statusCode == 200) {
        final Map<String, dynamic> projectData = jsonDecode(response.body);
        _parseProjectData(projectData);
      } else {
        throw Exception('Failed to fetch project data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching project data: $e');
    }
  }

  void _parseProjectData(Map<String, dynamic> projectData) {
    try {
      // Parse Members
      final ownerData =
          projectData["members"]["owner"] as Map<String, dynamic>?;

      final coworkerData =
          projectData["members"]["coworker"] as Map<String, dynamic>?;

      final referencePartnersData =
          projectData["members"]["referencePartners"] as List<dynamic>? ?? [];

      final owner = ownerData == null
          ? null
          : {
              "name": ownerData["name"].toString(),
              "profilePic": ownerData["profilePic"]?.toString() ?? "",
            };

      // Map coworker
      final coworker = coworkerData == null
          ? null
          : {
              "name": coworkerData["name"].toString(),
              "profilePic": coworkerData["profilePic"]?.toString() ?? "",
            };

      // Map reference partners
      final referencePartners = referencePartnersData.map((partner) {
        return {
          "id": partner["id"].toString(),
          "name": partner["name"].toString(),
          "company": partner["company"]?.toString() ?? "N/A",
          "role": partner["role"]?.toString() ?? "N/A",
        };
      }).toList();

      _sectionData[0] = SectionData(
        projectName: projectData["name"] as String,
        owner: owner,
        collaborator: coworker,
        share: referencePartners,
      );

      // Parse Category
      final categoryData = projectData["category"];
      final industryName = categoryData["industry"]["name"] as String;
      final categoryName = categoryData["category"]["name"] as String;
      final attr1Name = categoryData["attr1"]["name"] as String;
      final attr2Name = categoryData["attr2"]?["name"] ?? "N/A";

      _sectionData[1] = SectionData(
        industry: industryName,
        category: categoryName,
        attribute: attr1Name,
      );

      // Parse Conditions
      final conditionsData = projectData["conditions"] as List<dynamic>;
      final conditionsList = conditionsData.map((cond) {
        return Condition(
          condition: cond["name"] as String,
          explaination: cond["description"] as String,
          detail: cond["value"]?.toString() ?? "N/A",
          required: cond["required"] as bool,
        );
      }).toList();

      _sectionData[2] = SectionData(conditions: conditionsList);

      // Parse Products
      final productsData = projectData["products"] as List<dynamic>;
      final productsList = productsData.map((prod) {
        return Product(
          name: prod["name"] as String,
          usageAmount: prod["quantity"] as String,
          date: prod["providedDate"] as String,
        );
      }).toList();

      _sectionData[3] = SectionData(products: productsList);

      print("Project data parsed successfully!");
    } catch (e) {
      print('Error parsing project data: $e');
    }
  }

  // Handle user selection for fields like 'owner', 'collaborator', etc.
  void _handleUserSelected(String field, List<Map<String, String>> users) {
    setState(() {
      if (field == 'owner' && users.isNotEmpty) {
        _sectionData[0].owner = {
          'name': users[0]['name']!,
          'profilePic': users[0]['profilePic']!,
        };
      } else if (field == 'collaborator' && users.isNotEmpty) {
        _sectionData[0].collaborator = {
          'name': users[0]['name']!, // Assuming users[0] has a 'name' field
          'profilePic': users[0]
              ['profilePic']!, // If there's a profilePic field
        };
      } else if (field == 'share') {
        _sectionData[0].share = users.map((user) {
          return {
            'name': user['name']!,
            'profilePic':
                user['profilePic']!, // You can add any other fields you need
          };
        }).toList();
      }
    });
  }

  // Check if all sections are complete (i.e., all required fields are filled)
  bool get _isAllSectionsComplete {
    return _sectionData.every((section) {
      if (section == _sectionData[0]) {
        return section.projectName.isNotEmpty && section.owner != null;
      } else if (section == _sectionData[1]) {
        return section.industry.isNotEmpty && section.category.isNotEmpty;
        // && section.attribute.isNotEmpty;
      }
      // else if (section == _sectionData[2]) {
      //   return section.turningrate.isNotEmpty;
      // }
      return true; // Assuming Current Situation doesn't require validation
    });
  }

  // Build the content of the selected section
  Widget _buildSectionContent(int index) {
    switch (index) {
      case 0:
        return ManagementSection(
          data: _sectionData[0],
          editingMode: editingMode,
          onDataChanged: (updatedData) {
            setState(() {
              _sectionData[index] = updatedData;
            });
          },
          onUserSelected: (field, selectedUsers) {
            _handleUserSelected(field, selectedUsers);
          },
        );
      case 1:
        return DivisionSection(
          data: _sectionData[index],
          editingMode: editingMode,
          onDataChanged: (updatedData) {
            setState(() {
              _sectionData[index] = updatedData;
              _sectionData[2] = updatedData;
              // print('Industry: ${_sectionData[index].industry}');
              // print(updatedData.category);
              // print('Subattrbt: ${updatedData.subattributes}');
            });
          },
        );
      case 2:
        return ConditionSection(
          data: _sectionData[index],
          editingMode: editingMode,
          onDataChanged: (updatedData) {
            setState(() {
              _sectionData[index] = updatedData;
            });
          },
          // turningrates: conditions,
        );
      case 3:
        return CurrentSituationScreen(
          sectionData: _sectionData[index],
          editingMode: editingMode,
          products: _sectionData[index]?.products ?? [],
        );

      default:
        return const SizedBox.shrink();
    }
  }

  void addProduct(Product product) {
    setState(() {
      products.add(product); // Add the new product to the list
    });
  }

  Future<void> _saveProject() async {
    final projectData = _serializeProjectData();

    const String apiUrl = 'http://15.165.115.39:8080/api/projects';
    String? token = await getSavedData('token');

    print(projectData);
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(projectData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project saved successfully!')),
        );
      } else {
        throw Exception(
          'Failed to save project: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

// Serialize project data for saving
  Map<String, dynamic> _serializeProjectData() {
    return {
      "name": _sectionData[0].projectName,
      "imageThumbnail": "xyz", // Assuming empty for now
      "members": {
        "owner": _sectionData[0].owner?['email'] ?? "",
        "coworker": _sectionData[0].collaborator?['email'] ?? "",
        "referencePartners": _sectionData[0].share.map((partner) {
          return partner['email'] ?? "";
        }).toList(),
      },
      "category": {
        "industry": {
          "id": 2, // Use proper IDs as required
          "name": _sectionData[1].industry,
        },
        "category": {
          "id": 4, // Use proper IDs as required
          "name": _sectionData[1].category,
        },
        "attr1": {
          "id": 8, // Use proper IDs as required
          "name": _sectionData[1].attribute,
        },
        "attr2": {
          "id": 15, // Use proper IDs as required
          "name": "Beagle비글", // Add if attr2 is applicable
        },
      },
      "conditions": _sectionData[2].conditions.map((cond) {
        return {
          "id": cond.id,
          "name": cond.condition,
          "value": cond.detail,
          "description": cond.explaination,
          "new": cond.newCondition ?? false,
        };
      }).toList(),
      "product": _sectionData[3].products.isNotEmpty
          ? {
              "name": _sectionData[3].products[0].name,
              "quantity": _sectionData[3].products[0].usageAmount,
              "providedDate": _sectionData[3].products[0].date,
              "new": true, // Assuming new product is being added
            }
          : null,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '새로운 프로젝트 생성',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(
                    currentIndex: 1,
                  ),
                ),
              );
            }
          },
        ),
        actions: [
          // Display the menu icon if _selectedIndex is 2
          if (_selectedIndex == 2)
            IconButton(
              icon: Icon(Icons.menu_rounded),
              onPressed: () async {
                final condition = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TurningRateConditionScreen(),
                  ),
                );

                if (condition != null) {
                  // Once the condition is selected, navigate to the next screen
                  final explaination = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TurningRateExplainScreen(condition: condition),
                    ),
                  );

                  if (explaination != null) {
                    // After the explaination is written, navigate to DetailScreen
                    final detail = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TurningRateDetailScreen(
                          condition: condition,
                          explaination: explaination,
                        ),
                      ),
                    );

                    // Once the Detail is completed, return the final condition
                    if (detail != null) {
                      setState(() {
                        // Add the product or any data you want here
                        // conditions.add(detail);
                        print(detail);
                        _sectionData[_selectedIndex].conditions?.add(detail);
                      });
                    }
                  }
                }
              },
            ),
          // Display the calendar icon if _selectedIndex is 3
          if (_selectedIndex == 3)
            IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () async {
                final productName = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductNameScreen(),
                  ),
                );

                if (productName != null) {
                  // Navigate to the UsageAmountScreen
                  final usageData = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UsageAmountScreen(productName: productName),
                    ),
                  );

                  if (usageData != null && usageData is Map<String, String>) {
                    final usageAmount = usageData['usageAmount'];
                    final startDate = usageData['date'];

                    if (usageAmount != null && startDate != null) {
                      setState(() {
                        // Create a Product object and add it to the list
                        final newProduct = Product(
                          name: productName,
                          usageAmount: usageAmount,
                          date: startDate,
                        );
                        // _sectionData[_selectedIndex].products.add(newProduct);
                        final updatedProducts = List<Product>.from(
                            _sectionData[_selectedIndex].products)
                          ..add(newProduct);

                        // Update the section data with the new list
                        _sectionData[_selectedIndex] =
                            _sectionData[_selectedIndex]
                                .copyWith(products: updatedProducts);
                      });
                    }
                  }
                }
              },
            ),

          // Existing "완료" button
          TextButton(
            onPressed: _isAllSectionsComplete ? _saveProject : null,
            child: Text(
              '완료',
              style: TextStyle(
                color: _isAllSectionsComplete ? Colors.black : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loading spinner
          : Column(
              children: [
                // Top Buttons for section navigation
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      _TopButton(
                        label: '관리',
                        isSelected: _selectedIndex == 0,
                        onTap: () => setState(() => _selectedIndex = 0),
                      ),
                      _TopButton(
                        label: '구분',
                        isSelected: _selectedIndex == 1,
                        onTap: () => setState(() => _selectedIndex = 1),
                      ),
                      _TopButton(
                        label: '조건',
                        isSelected: _selectedIndex == 2,
                        onTap: () => setState(() => _selectedIndex = 2),
                      ),
                      _TopButton(
                        label: '현황',
                        isSelected: _selectedIndex == 3,
                        onTap: () => setState(() => _selectedIndex = 3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 00),
                // Display the current section content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildSectionContent(_selectedIndex),
                  ),
                ),
              ],
            ),
    );
  }
}

class _TopButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TopButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.grey[300],
              borderRadius: BorderRadius.circular(40),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onTap; // Callback for handling tap

  const _CustomTextField({
    required this.label,
    required this.controller,
    required this.onChanged,
    required this.onTap, // Pass the tap callback
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black38,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap, // Trigger the onTap callback when clicked
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey, width: 1.0),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 30),
                Expanded(
                  child: TextField(
                    controller: controller,
                    onChanged: onChanged,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        style: IconButton.styleFrom(
                            overlayColor: Colors.transparent),
                        onPressed: () {
                          controller.clear();
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
        ),
      ],
    );
  }
}

class _UserDisplayContainer extends StatelessWidget {
  final String label;
  final String userName;
  final VoidCallback onTap;

  const _UserDisplayContainer({
    required this.label,
    required this.userName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black38,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    userName.isEmpty ? '?' : userName[0],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    userName.isEmpty ? 'Select a user' : userName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomDisplayContainer extends StatelessWidget {
  final String label;
  final String content;

  const _CustomDisplayContainer({
    required this.label,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black38,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
