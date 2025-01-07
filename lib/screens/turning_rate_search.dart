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
    '1 drum',
    '2 drum',
    '3 drum',
    '4 drum',
    '5 drum',
    '6 drum',
    '7 drum',
    '8 drum',
    '9 drum',
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
        leading: IconButton(
          style: IconButton.styleFrom(overlayColor: Colors.transparent),
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          '조건 입력',
          style: TextStyle(
              fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "입력해주세요",
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade500,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    searchController.clear();
                    setState(() {
                      filteredOptions = [];
                    });
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
