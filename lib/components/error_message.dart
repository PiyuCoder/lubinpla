import 'package:flutter/material.dart';

class ErrorDisplay extends StatelessWidget {
  final String? errorMessage;

  const ErrorDisplay({Key? key, this.errorMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (errorMessage == null || errorMessage!.isEmpty) {
      return const SizedBox.shrink(); // Return an empty widget if no error
    }

    return Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            const Icon(Icons.do_disturb_on, color: Colors.black),
            const SizedBox(
              width: 10,
            ),
            Text(
              errorMessage!,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ));
  }
}
