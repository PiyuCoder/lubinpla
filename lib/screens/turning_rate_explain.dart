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

  bool _isNextDisabled = true;

  @override
  void initState() {
    explainController.addListener(_checkFields);
    super.initState();
  }

  @override
  void dispose() {
    explainController.dispose();
    super.dispose();
  }

  void gotoNext() {
    final explaination = explainController.text;
    Navigator.pop(context, explaination);
  }

  void _checkFields() {
    if (explainController.text.isNotEmpty) {
      setState(() {
        _isNextDisabled = false;
      });
    }
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
              text: '조건 설명 입력',
              style: TextStyle(
                fontSize: 18.0, // Main title size
                color: Colors.black, // AppBar text color
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: '(2/3)',
                  style: TextStyle(
                    fontSize: 14.0, // Smaller size for the fraction
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(overlayColor: Colors.transparent),
            onPressed: () {
              if (!_isNextDisabled) gotoNext();
            },
            child: Text(
              '다음',
              style: TextStyle(
                  color: !_isNextDisabled
                      ? Colors.black
                      : Colors.grey), // You can change color as needed
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: explainController,
              maxLines: 22, // Number of lines to simulate a textarea
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                hintText: "입력해주세요",
                alignLabelWithHint:
                    true, // Align label to the top-left for multi-line fields
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(8.0), // Optional rounded corners
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16.0, // Padding for a spacious feel
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
