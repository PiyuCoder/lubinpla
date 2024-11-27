import 'package:flutter/material.dart';
import 'package:lubinpla/components/project/usage_amount.dart';

class TutningRateConditionScreen extends StatefulWidget {
  const TutningRateConditionScreen({super.key});

  @override
  _TutningRateConditionScreenState createState() =>
      _TutningRateConditionScreenState();
}

class _TutningRateConditionScreenState
    extends State<TutningRateConditionScreen> {
  final TextEditingController conditionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Conditions")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: conditionController,
              decoration: const InputDecoration(labelText: 'Condition'),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Navigate to next screen with product name
                final condition = conditionController.text;
                // Navigator.pop(context);
                Navigator.pop(context, condition);

                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => UsageAmountScreen(
                //       productName: productName, // Pass product name
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
