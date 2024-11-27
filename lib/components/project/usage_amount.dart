import 'package:flutter/material.dart';
import 'package:lubinpla/components/project/date_selector.dart';

class UsageAmountScreen extends StatefulWidget {
  final String productName;

  const UsageAmountScreen({super.key, required this.productName});

  @override
  _UsageAmountScreenState createState() => _UsageAmountScreenState();
}

class _UsageAmountScreenState extends State<UsageAmountScreen> {
  final TextEditingController usageAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter Usage Amount")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usageAmountController,
              decoration: const InputDecoration(labelText: 'Usage Amount'),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Navigate to next screen with product name and usage amount
                final usageAmount = usageAmountController.text;
                // Navigator.pop(context);
                Navigator.pop(context, usageAmount);

                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => StartDateScreen(
                //       productName: widget.productName,
                //       usageAmount: usageAmount, // Pass usage amount
                //     ),
                //   ),
                // );
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
