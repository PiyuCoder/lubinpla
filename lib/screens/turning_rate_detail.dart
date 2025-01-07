import 'package:flutter/material.dart';
import 'package:lubinpla/models/project_create_data.dart';

class TurningRateDetailScreen extends StatefulWidget {
  final String condition;
  final String explaination;

  const TurningRateDetailScreen({
    super.key,
    required this.condition,
    required this.explaination,
  });

  @override
  _TurningRateDetailScreenState createState() =>
      _TurningRateDetailScreenState();
}

class _TurningRateDetailScreenState extends State<TurningRateDetailScreen> {
  final TextEditingController searchController = TextEditingController();
  final List<String> allDetails = [
    "Detail A",
    "Detail B",
    "Detail C",
    "Detail D",
    "Detail E"
  ]; // Dummy data for details
  List<String> filteredDetails = [];

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      if (searchController.text.isEmpty) {
        filteredDetails = [];
      } else {
        filteredDetails = allDetails
            .where((detail) => detail
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
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
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: RichText(
            text: const TextSpan(
              text: '내용 입력',
              style: TextStyle(
                fontSize: 18.0, // Main title size
                color: Colors.black, // AppBar text color
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: '(3/3)',
                  style: TextStyle(
                    fontSize: 14.0, // Smaller size for the fraction
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: '입력해주세요',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    searchController.clear();
                  },
                ),
                fillColor: Colors.grey.shade100,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0), // Rounded corners
                  borderSide: BorderSide.none, // Borderless
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (filteredDetails.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: filteredDetails.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(filteredDetails[index]),
                      onTap: () {
                        final detail = filteredDetails[index];
                        final newCondition = Condition(
                          condition: widget.condition,
                          explaination: widget.explaination,
                          detail: detail,
                          required: false,
                        );

                        Navigator.pop(context, newCondition);
                      },
                    );
                  },
                ),
              ),
            if (filteredDetails.isEmpty && searchController.text.isNotEmpty)
              const Center(
                child: Text("No matching details found"),
              ),
            const SizedBox(height: 16),
            // ElevatedButton(
            //   onPressed: () {
            //     final detail = searchController.text;
            //     final newCondition = TurningRate(
            //       condition: widget.condition,
            //       explaination: widget.explanation,
            //       detail: detail,
            //     );

            //     Navigator.pop(context, newCondition);
            //   },
            //   child: const Text('Save Detail'),
            // ),
          ],
        ),
      ),
    );
  }
}
