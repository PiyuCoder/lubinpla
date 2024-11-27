import 'package:flutter/material.dart';
import 'package:lubinpla/models/project_create_data.dart';

class StartDateScreen extends StatefulWidget {
  final String productName;
  final String usageAmount;

  const StartDateScreen({
    super.key,
    required this.productName,
    required this.usageAmount,
  });

  @override
  _StartDateScreenState createState() => _StartDateScreenState();
}

class _StartDateScreenState extends State<StartDateScreen> {
  final TextEditingController startDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter Start Date")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: startDateController,
              decoration: const InputDecoration(labelText: 'Start Date'),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Save the product and navigate back to CreateProjectScreen
                final startDate = startDateController.text;
                final product = Product(
                  name: widget.productName,
                  usageAmount: widget.usageAmount,
                  date: startDate,
                );

                print(product);

                // Return the product to CreateProjectScreen
                Navigator.pop(context, product);
              },
              child: const Text('Save Product'),
            ),
          ],
        ),
      ),
    );
  }
}
