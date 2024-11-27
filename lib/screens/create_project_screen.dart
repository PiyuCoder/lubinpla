import 'package:flutter/material.dart';
import 'package:lubinpla/components/dashboard/project_screen.dart';
import 'package:lubinpla/components/project/date_selector.dart';
import 'package:lubinpla/components/project/division_section.dart';
import 'package:lubinpla/components/project/management_section.dart';
import 'package:lubinpla/components/project/condition_section.dart';
import 'package:lubinpla/components/project/product_name.dart';
import 'package:lubinpla/components/project/usage_amount.dart';
import 'package:lubinpla/models/project_create_data.dart';
import 'package:lubinpla/components/project/situation_section.dart';
import 'package:lubinpla/screens/dashboard.dart';
import 'package:lubinpla/screens/turning_rate_condition.dart';
import 'package:lubinpla/screens/turning_rate_detail.dart';
import 'package:lubinpla/screens/turning_rate_explain.dart';

class CreateProjectScreen extends StatefulWidget {
  final int selectedIndex;

  const CreateProjectScreen({super.key, required this.selectedIndex});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  late int _selectedIndex = 0;
  late List<Product> products = [];
  late List<TurningRate> turningrates = [];

  // Data for all sections
  final List<SectionData> _sectionData = List.generate(4, (_) => SectionData());

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  // Handle user selection for fields like 'owner', 'collaborator', etc.
  void _handleUserSelected(String field, List<Map<String, String>> users) {
    setState(() {
      if (field == 'owner' && users.isNotEmpty) {
        _sectionData[0].owner = users[0]['name']!;
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
        return section.projectName.isNotEmpty && section.owner.isNotEmpty;
      } else if (section == _sectionData[1]) {
        return section.industry.isNotEmpty &&
            section.category.isNotEmpty &&
            section.attribute.isNotEmpty;
      } else if (section == _sectionData[2]) {
        return section.turningrate.isNotEmpty;
      }
      return true; // Assuming Current Situation doesn't require validation
    });
  }

  // Build the content of the selected section
  Widget _buildSectionContent(int index) {
    switch (index) {
      case 0:
        return ManagementSection(
          data: _sectionData[index],
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
          onDataChanged: (updatedData) {
            setState(() {
              _sectionData[index] = updatedData;
            });
          },
        );
      case 2:
        return ConditionSection(
          data: _sectionData[index],
          onDataChanged: (updatedData) {
            setState(() {
              _sectionData[index] = updatedData;
            });
          },
          turningrates: turningrates,
        );
      case 3:
        return CurrentSituationScreen(
          sectionData: _sectionData[index],
          products: products,
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
                    builder: (context) => TutningRateConditionScreen(),
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
                        turningrates.add(detail);
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
                final product = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductNameScreen(),
                  ),
                );

                if (product != null) {
                  // Once the product name is selected, navigate to the next screen
                  final usageAmount = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UsageAmountScreen(productName: product),
                    ),
                  );

                  if (usageAmount != null) {
                    // After the usage amount is selected, navigate to StartDateScreen
                    final startDate = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StartDateScreen(
                          productName: product,
                          usageAmount: usageAmount,
                        ),
                      ),
                    );

                    // Once the StartDateScreen is completed, return the final product
                    if (startDate != null) {
                      setState(() {
                        // Add the product or any data you want here
                        products.add(startDate);
                      });
                    }
                  }
                }
              },
            ),
          // Existing "완료" button
          TextButton(
            onPressed: _isAllSectionsComplete ? () {} : null,
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
      body: Column(
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
          const SizedBox(height: 20),
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
