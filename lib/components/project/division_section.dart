import 'package:flutter/material.dart';
import 'package:lubinpla/helpers/pref_data.dart';
import 'package:lubinpla/models/project_create_data.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://15.165.115.39:8080";

  Future<Map<String, dynamic>> fetchIndustryCategory(String token) async {
    final url = Uri.parse('$baseUrl/api/industry/category');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load data: ${response.reasonPhrase}');
    }
  }
}

List<Condition> collectConditions(
    Map<String, dynamic> hierarchy, List<String> selectedIds) {
  List<Condition> allConditions = [];

  // Traverse the hierarchy for each selected ID
  for (String id in selectedIds) {
    if (hierarchy.containsKey(id)) {
      for (var field in hierarchy[id]) {
        // Add conditions from the field if they exist
        if (field['conditions'] != null) {
          allConditions
              .addAll(field['conditions'].map<Condition>((c) => Condition(
                    condition: c['name'] ?? '',
                    explaination: c['description'] ?? '',
                    detail: c['description'] ?? '',
                    required: c['required'] ?? false,
                    id: c['id']?.toString(),
                  )));
        }
      }
    }
  }

  return allConditions;
}

class DivisionSection extends StatefulWidget {
  final SectionData data;
  final ValueChanged<SectionData> onDataChanged;
  final bool editingMode;

  const DivisionSection({
    required this.data,
    required this.onDataChanged,
    required this.editingMode,
  });

  @override
  _DivisionSectionState createState() => _DivisionSectionState();
}

class _DivisionSectionState extends State<DivisionSection> {
  late TextEditingController _industryController;
  late TextEditingController _categoryController;
  late TextEditingController _attributeController;
  Map<String, TextEditingController> _dynamicAttributeControllers = {};
  late List<Condition> conditions = [];

  Map<String, dynamic> dynamicData = {};
  bool isLoading = true;

  String? selectedIndustryId;
  String? selectedCategoryId;
  String? selectedAttributeId;

  @override
  void initState() {
    super.initState();
    _industryController = TextEditingController(text: widget.data.industry);
    _categoryController = TextEditingController(text: widget.data.category);
    _attributeController = TextEditingController(text: widget.data.attribute);
    fetchIndustryCategory().then((data) {
      setState(() {
        dynamicData = data;
        isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Error fetching data: $error");
    });
    loadDynamicFields();
  }

  void updateConditionsInSectionData() {
    // List to hold all conditions
    List<Condition> allConditions = [];

    // Function to add conditions from a selected item
    void addConditionsFromSelected(Map<String, dynamic> selectedItem) {
      if (selectedItem.containsKey('conditions') &&
          selectedItem['conditions'] is List) {
        List<dynamic> conditionsList = selectedItem['conditions'];

        print('SelectedItem: $selectedItem');
        print('SelectedItems conditions: $conditionsList');

        for (var conditionItem in conditionsList) {
          if (conditionItem is Map<String, dynamic>) {
            // Add condition to allConditions
            allConditions.add(Condition(
              id: conditionItem['id'] ?? '',
              condition: conditionItem['name'] ?? '',
              explaination: conditionItem['description'] ?? '',
              detail: conditionItem['value'] ?? '',
              required: conditionItem['required'] ?? false,
            ));
          }
        }
      }
    }

    // Add conditions based on selected options
    if (selectedIndustryId != null) {
      // Find the selected industry in the dynamic data and check if it has conditions
      final selectedIndustry = getIndustries().firstWhere(
        (e) => e['id'] == selectedIndustryId,
        orElse: () => {},
      );
      addConditionsFromSelected(selectedIndustry);
    }

    if (selectedCategoryId != null) {
      // Find the selected category in dynamic data and check if it has conditions
      final selectedCategory = getNextLevel(selectedIndustryId, 'category')
          .firstWhere((e) => e['id'] == selectedCategoryId, orElse: () => {});
      addConditionsFromSelected(selectedCategory);
    }

    if (selectedAttributeId != null) {
      // Find the selected attribute in dynamic data and check if it has conditions
      final selectedAttribute = getNextLevel(selectedCategoryId, 'attr1')
          .firstWhere((e) => e['id'] == selectedAttributeId, orElse: () => {});
      addConditionsFromSelected(selectedAttribute);
    }

    // Add conditions for dynamic attributes (if any)
    _dynamicAttributeControllers.forEach((key, controller) {
      final dynamicFieldConditions = getNextLevel(selectedCategoryId, key)
          .firstWhere((e) => e['id'] == controller.text, orElse: () => {});
      addConditionsFromSelected(dynamicFieldConditions);
    });

    print('All conditions: $allConditions');
    // Now update the conditions in SectionData
    setState(() {
      conditions = allConditions; // Update conditions in the state

      // Directly update the conditions in widget.data
      widget.data.conditions = conditions;

      // Log the updated conditions
      print("Updated conditions in SectionData: ${widget.data.conditions}");

      // Notify the parent widget to trigger any necessary updates
      widget.onDataChanged(
          widget.data); // Pass the updated widget.data to the parent
    });
  }

  Future<Map<String, dynamic>> fetchIndustryCategory() async {
    String? token = await getSavedData("token");
    final url = Uri.parse('http://15.165.115.39:8080/api/industry/category');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      // print(data);

      // No parsing to integers, IDs remain as strings
      data["industry"] = (data["industry"] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();

      data["category"] = (data["category"] as Map<String, dynamic>).map(
        (key, value) {
          return MapEntry(
            key.toString(), // Keep key as string
            (value as List)
                .map((item) => item as Map<String, dynamic>)
                .toList(),
          );
        },
      );

      return data;
    } else {
      throw Exception('Failed to load data: ${response.reasonPhrase}');
    }
  }

  List<Map<String, dynamic>> getIndustries() {
    return (dynamicData["industry"] as List<dynamic>? ?? [])
        .map((e) => e as Map<String, dynamic>)
        .toList();
  }

  void loadDynamicFields() {
    for (var field in widget.data.extraFields) {
      String attrKey = field['id'].toString();
      _dynamicAttributeControllers[attrKey] =
          TextEditingController(text: field['name']);
    }
  }

  List<Map<String, dynamic>> getNextLevel(String? parentId, String key) {
    if (parentId == null || parentId.isEmpty) return [];

    // Safely access dynamicData and check its type
    final keyData = dynamicData[key];
    if (keyData is Map<String, dynamic>) {
      // Convert the values of the map to a list if necessary
      final subcategories = keyData[parentId];
      if (subcategories is List) {
        return subcategories
            .map((item) => item as Map<String, dynamic>)
            .toList();
      }
    }

    debugPrint("Key data for $key is not in expected format.");
    return [];
  }

  void updateConditions(String? selectedAttrId, String key) {
    final conditions = getNextLevel(selectedAttrId, key);
    if (conditions.isNotEmpty) {
      final newController = TextEditingController();
      _dynamicAttributeControllers[key] = newController;

      setState(() {
        widget.onDataChanged(widget.data.copyWith(extraFields: [
          ...widget.data.extraFields,
          {
            "name": conditions.first['name'],
            "id": conditions.first['id'].toString()
          }
        ]));
      });

      String nextAttrKey = 'attr${int.parse(key.substring(4)) + 1}';
      if (dynamicData.containsKey(nextAttrKey)) {
        updateConditions(selectedAttrId, nextAttrKey);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final industries = getIndustries().map((e) => e['name'] as String).toList();
    final categories = getNextLevel(selectedIndustryId, "category")
        .map((e) => e['name'] as String)
        .toList();
    final attributes = getNextLevel(selectedCategoryId, "attr1")
        .map((e) => e['name'] as String)
        .toList();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Add padding around the content
        child: Column(
          children: [
            buildSelectionField(
              title: "Industry",
              controller: _industryController,
              options: industries,
              onOptionSelected: (value) {
                final industry = getIndustries().firstWhere(
                    (e) => e['name'] == value,
                    orElse: () => <String, Object>{});
                selectedIndustryId = industry['id']?.toString();

                // Update conditions in SectionData
                updateConditionsInSectionData();

                _categoryController.clear();
                _attributeController.clear();
                _dynamicAttributeControllers.clear();
                widget.onDataChanged(widget.data.copyWith(industry: value));
              },
            ),
            buildSelectionField(
              title: "Category",
              controller: _categoryController,
              options: categories,
              onOptionSelected: (value) {
                final category = getNextLevel(selectedIndustryId, "category")
                    .firstWhere((e) => e['name'] == value,
                        orElse: () => <String, Object>{});
                selectedCategoryId = category['id']?.toString();
// Update conditions in SectionData
                updateConditionsInSectionData();
                _attributeController.clear();
                _dynamicAttributeControllers.clear();
                widget.onDataChanged(widget.data.copyWith(category: value));
              },
            ),
            buildSelectionField(
              title: "Attribute",
              controller: _attributeController,
              options: attributes,
              onOptionSelected: (value) {
                final attribute = getNextLevel(selectedCategoryId, "attr1")
                    .firstWhere((e) => e['name'] == value,
                        orElse: () => <String, Object>{});
                selectedAttributeId = attribute['id']?.toString();

                if (attribute['hasBranch'] == true) {
                  updateConditions(selectedAttributeId,
                      "attr2"); // Create a new field dynamically
                }
// Update conditions in SectionData
                updateConditionsInSectionData();
                widget.onDataChanged(widget.data.copyWith(attribute: value));
              },
            ),
            ..._dynamicAttributeControllers.entries.map((entry) {
              final attrKey = entry.key;
              final controller = entry.value;
              final options = getNextLevel(selectedAttributeId, attrKey)
                  .map((e) => e['name'] as String)
                  .toList();

              print("Options for $attrKey: $options");

              // Update the condition to ensure it dynamically creates the fields for attr3, attr4, etc.
              return buildSelectionField(
                title: "Attribute $attrKey",
                controller: controller,
                options:
                    options, // Make sure options for attr3 are being correctly populated
                onOptionSelected: (value) {
                  // Handle option selection for attr3
                  final selectedOption =
                      getNextLevel(selectedAttributeId, attrKey).firstWhere(
                          (e) => e['name'] == value,
                          orElse: () => <String, Object>{});

                  // If the selected option has a branch, recursively create the next field
                  if (selectedOption.isNotEmpty &&
                      selectedOption['hasBranch'] == true) {
                    final nextAttrKey =
                        "attr${int.parse(attrKey.substring(4)) + 1}";
                    updateConditions(
                        selectedOption['id']?.toString(), nextAttrKey);
                    selectedAttributeId = selectedOption['id']?.toString();
                  }
// Update conditions in SectionData
                  updateConditionsInSectionData();
                  widget.onDataChanged(
                    widget.data
                      ..extraFields = [
                        ...widget.data.extraFields,
                        {
                          "name": value,
                          "id": value
                        } // Add selected value to extraFields
                      ],
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget buildSelectionField({
    required String title,
    required TextEditingController controller,
    required List<String> options,
    required Function(String) onOptionSelected,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(controller.text),
      onTap: () async {
        final selectedValue = await showModalBottomSheet<String>(
          context: context,
          builder: (context) => ListView.builder(
            itemCount: options.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(options[index]),
                onTap: () => Navigator.pop(context, options[index]),
              );
            },
          ),
        );

        if (selectedValue != null) {
          controller.text = selectedValue;
          onOptionSelected(selectedValue);
        }
      },
    );
  }

  void showOptionsModal({
    required BuildContext context,
    required String title,
    required List<String> options,
    required TextEditingController controller,
    required ValueChanged<String> onOptionSelected,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ListView.builder(
          itemCount: options.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(options[index]),
              onTap: () {
                onOptionSelected(options[index]);
                controller.text = options[index];
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }
}
