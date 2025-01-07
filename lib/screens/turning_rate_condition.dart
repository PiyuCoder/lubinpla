import 'package:flutter/material.dart';

class TurningRateConditionScreen extends StatefulWidget {
  const TurningRateConditionScreen({super.key});

  @override
  _TurningRateConditionScreenState createState() =>
      _TurningRateConditionScreenState();
}

class _TurningRateConditionScreenState
    extends State<TurningRateConditionScreen> {
  final TextEditingController conditionController = TextEditingController();
  final List<String> allConditions = [
    "Condition A",
    "Condition B",
    "Condition C",
    "Condition D",
    "Condition E"
  ]; // Dummy data
  List<String> filteredConditions = [];

  @override
  void initState() {
    super.initState();
    conditionController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      if (conditionController.text.isEmpty) {
        filteredConditions = [];
      } else {
        filteredConditions = allConditions
            .where((condition) => condition
                .toLowerCase()
                .contains(conditionController.text.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    conditionController.removeListener(_onSearchChanged);
    conditionController.dispose();
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
              text: '새로운 조건명 입력',
              style: TextStyle(
                fontSize: 18.0, // Main title size
                color: Colors.black, // AppBar text color
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: '(1/3)',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: conditionController,
              decoration: InputDecoration(
                hintText: '입력해주세요',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    conditionController.clear();
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
            if (filteredConditions.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: filteredConditions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(filteredConditions[index]),
                      onTap: () {
                        Navigator.pop(context, filteredConditions[index]);
                      },
                    );
                  },
                ),
              ),
            if (filteredConditions.isEmpty &&
                conditionController.text.isNotEmpty)
              const Center(
                child: Text("No matching conditions found"),
              ),
            const SizedBox(height: 16),
            // ElevatedButton(
            //   onPressed: () {
            //     final condition = conditionController.text;
            //     Navigator.pop(context, condition);
            //   },
            //   child: const Text('Next'),
            // ),
          ],
        ),
      ),
    );
  }
}
