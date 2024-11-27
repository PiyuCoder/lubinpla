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
  final TextEditingController detailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter Detail")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: detailController,
              decoration: const InputDecoration(labelText: 'Detail'),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Save the condition and navigate back to CreateProjectScreen
                final detail = detailController.text;
                final newCondition = TurningRate(
                  condition: widget.condition,
                  explaination: widget.explaination,
                  detail: detail,
                );

                print(newCondition);

                // Return the newCondition to CreateProjectScreen
                Navigator.pop(context, newCondition);
              },
              child: const Text('Save Product'),
            ),
          ],
        ),
      ),
    );
  }
}
