import 'package:flutter/material.dart';
import 'package:lubinpla/models/project_create_data.dart';

class DivisionSection extends StatefulWidget {
  final SectionData data;
  final ValueChanged<SectionData> onDataChanged;

  const DivisionSection({
    required this.data,
    required this.onDataChanged,
  });

  @override
  _DivisionSectionState createState() => _DivisionSectionState();
}

class _DivisionSectionState extends State<DivisionSection> {
  late TextEditingController _industryController;
  late TextEditingController _categoryController;
  late TextEditingController _attributeController;

  // Dummy data for industries, categories, and attributes
  final Map<String, List<String>> industries = {
    'Technology': ['Software', 'Hardware'],
    'Healthcare': ['Medicine', 'Biotech'],
    'Finance': ['Banking', 'Insurance'],
  };

  final Map<String, Map<String, List<String>>> categoryAttributes = {
    'Software': {
      'App Development': ['Frontend', 'Backend', 'Fullstack'],
      'Game Development': ['Unity', 'Unreal Engine', 'VR'],
    },
    'Medicine': {
      'Surgery': ['Cardiac', 'Orthopedic', 'Neuro'],
      'Pharmacy': ['Pharmacology', 'Toxicology', 'Clinical Trials'],
    },
    'Banking': {
      'Retail Banking': ['Savings Account', 'Loans', 'Credit Cards'],
      'Investment Banking': ['Mergers & Acquisitions', 'Private Equity'],
    },
  };

  final Map<String, int> attributeFieldCounts = {
    'Frontend': 2,
    'Backend': 3,
    'Fullstack': 4,
    'Unity': 2,
    'Pharmacology': 1,
    'Savings Account': 2,
    // Add more attributes as needed
  };

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing data
    _industryController = TextEditingController(text: widget.data.industry);
    _categoryController = TextEditingController(text: widget.data.category);
    _attributeController = TextEditingController(text: widget.data.attribute);
  }

  @override
  void didUpdateWidget(covariant DivisionSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update controllers if parent data changes
    if (oldWidget.data.industry != widget.data.industry) {
      _industryController.text = widget.data.industry;
    }
    if (oldWidget.data.category != widget.data.category) {
      _categoryController.text = widget.data.category;
    }
    if (oldWidget.data.attribute != widget.data.attribute) {
      _attributeController.text = widget.data.attribute;
    }
  }

  @override
  void dispose() {
    _industryController.dispose();
    _categoryController.dispose();
    _attributeController.dispose();
    super.dispose();
  }

  Future<List<String>> fetchOptions(String type) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay

    if (type == 'industry') {
      return industries.keys.toList();
    } else if (type == 'category') {
      var selectedIndustry = _industryController.text;
      return industries[selectedIndustry] ?? [];
    } else if (type == 'attribute') {
      var selectedIndustry = _industryController.text;
      var selectedCategory = _categoryController.text;
      var categoryMap = categoryAttributes[selectedCategory] ?? {};
      return categoryMap[selectedCategory] ?? [];
    }

    return [];
  }

  void showOptionsModal({
    required BuildContext context,
    required String title,
    required String fieldType,
    required TextEditingController controller,
    required ValueChanged<String> onOptionSelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return FutureBuilder<List<String>>(
          future: fetchOptions(fieldType),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error fetching options'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No options available'));
            }

            final options = snapshot.data!;
            return Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Select $title',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
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
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int extraFieldCount = attributeFieldCounts[_attributeController.text] ?? 0;
    return Column(
      children: [
        // Industry field
        GestureDetector(
          onTap: () {
            showOptionsModal(
              context: context,
              title: 'Industry',
              fieldType: 'industry',
              controller: _industryController,
              onOptionSelected: (value) {
                widget.onDataChanged(widget.data..industry = value);
                _categoryController.clear();
                _attributeController.clear();
              },
            );
          },
          child: TextFormField(
            controller: _industryController,
            enabled: false,
            decoration: InputDecoration(
              labelText: 'Industry',
              hintText: 'Select an Industry',
              suffixIcon: Icon(Icons.arrow_drop_down),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Category field
        GestureDetector(
          onTap: () {
            showOptionsModal(
              context: context,
              title: 'Category',
              fieldType: 'category',
              controller: _categoryController,
              onOptionSelected: (value) {
                widget.onDataChanged(widget.data..category = value);
                _attributeController
                    .clear(); // Clear attribute field when category changes
              },
            );
          },
          child: TextFormField(
            controller: _categoryController,
            enabled: false,
            decoration: InputDecoration(
              labelText: 'Category',
              hintText: 'Select a Category',
              suffixIcon: Icon(Icons.arrow_drop_down),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Attribute field
        GestureDetector(
          onTap: () {
            showOptionsModal(
              context: context,
              title: 'Attribute',
              fieldType: 'attribute',
              controller: _attributeController,
              onOptionSelected: (value) {
                widget.onDataChanged(widget.data..attribute = value);
              },
            );
          },
          child: TextFormField(
            controller: _attributeController,
            enabled: false,
            decoration: InputDecoration(
              labelText: 'Attribute',
              hintText: 'Select an Attribute',
              suffixIcon: Icon(Icons.arrow_drop_down),
            ),
          ),
        ),

        // Add extra fields based on selected attribute
        ...List.generate(extraFieldCount, (index) {
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Additional Field ${index + 1}',
                hintText: 'Enter value',
              ),
            ),
          );
        }),
      ],
    );
  }
}
