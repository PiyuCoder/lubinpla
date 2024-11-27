import 'package:flutter/material.dart';

class SuccessDisplay extends StatelessWidget {
  final String? successMessage;

  const SuccessDisplay({Key? key, this.successMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (successMessage == null || successMessage!.isEmpty) {
      return const SizedBox.shrink(); // No success message to display
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade300, // Grey background
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(children: [
        const Icon(Icons.check_circle, color: Colors.black),
        const SizedBox(
          width: 10,
        ),
        Text(
          successMessage!,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14.0,
          ),
          textAlign: TextAlign.center,
        ),
      ]),
    );
  }
}
