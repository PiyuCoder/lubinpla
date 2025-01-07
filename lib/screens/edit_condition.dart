import 'package:flutter/material.dart';

class EditConditionScreen extends StatefulWidget {
  final String condition;
  final String initialDetail;

  const EditConditionScreen({
    super.key,
    required this.condition,
    required this.initialDetail,
  });

  @override
  _EditConditionScreenState createState() => _EditConditionScreenState();
}

class _EditConditionScreenState extends State<EditConditionScreen> {
  late TextEditingController detailController;

  bool _isSaveDisabled = true;

  @override
  void initState() {
    super.initState();
    detailController = TextEditingController(text: widget.initialDetail);
    detailController.addListener(_checkFields);
  }

  @override
  void dispose() {
    detailController.dispose();
    super.dispose();
  }

  void _checkFields() {
    setState(() {
      _isSaveDisabled = detailController.text.trim().isEmpty;
    });
  }

  void _saveAndExit() {
    final updatedDetail = detailController.text.trim();
    Navigator.pop(context, updatedDetail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context); // Navigate back without saving
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
            onPressed: !_isSaveDisabled ? _saveAndExit : null,
            child: Text(
              "완료",
              style: TextStyle(
                color: !_isSaveDisabled ? Colors.black : Colors.grey,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: detailController,
              maxLines: 20,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                hintText: "Enter explanation here",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
