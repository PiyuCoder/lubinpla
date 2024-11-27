import 'package:flutter/material.dart';

class TurnoverSearchScreen extends StatefulWidget {
  final ValueChanged<String> onSelectTurnover;

  TurnoverSearchScreen({required this.onSelectTurnover});

  @override
  _TurnoverSearchScreenState createState() => _TurnoverSearchScreenState();
}

class _TurnoverSearchScreenState extends State<TurnoverSearchScreen> {
  // List of turnover options
  final List<String> turnoverOptions = [
    'Less than \$1M',
    '\$1M - \$10M',
    'More than \$10M',
  ];

  // List of filtered turnover options based on search
  List<String> filteredOptions = [];

  // Controller for the search bar
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize filteredOptions with all turnover options
    // filteredOptions = List.from(turnoverOptions);

    // Listen to the search bar input and filter options
    searchController.addListener(_filterOptions);
  }

  // Filter turnover options based on the search input
  void _filterOptions() {
    if (searchController.text.isEmpty) {
      return;
    }
    setState(() {
      filteredOptions = turnoverOptions
          .where((option) => option
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    // Dispose of the controller when done
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Turnover'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Turnover',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredOptions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredOptions[index]),
                  onTap: () {
                    widget.onSelectTurnover(filteredOptions[index]);
                    Navigator.pop(context); // Go back to the previous screen
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
