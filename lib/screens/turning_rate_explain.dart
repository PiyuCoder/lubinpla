import 'package:flutter/material.dart';
import 'package:lubinpla/components/project/date_selector.dart';

class TurningRateExplainScreen extends StatefulWidget {
  final String condition;

  const TurningRateExplainScreen({super.key, required this.condition});

  @override
  _TurningRateExplainScreenState createState() =>
      _TurningRateExplainScreenState();
}

class _TurningRateExplainScreenState extends State<TurningRateExplainScreen> {
  final TextEditingController explainController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Explain Further")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: explainController,
              decoration: const InputDecoration(labelText: 'Explaination'),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Navigate to next screen with product name and usage amount
                final explaination = explainController.text;
                // Navigator.pop(context);
                Navigator.pop(context, explaination);

                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => StartDateScreen(
                //       condition: widget.productName,
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
