import 'package:flutter/material.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:intl/intl.dart';

class UsageAmountScreen extends StatefulWidget {
  final String productName;

  const UsageAmountScreen({super.key, required this.productName});

  @override
  _UsageAmountScreenState createState() => _UsageAmountScreenState();
}

class _UsageAmountScreenState extends State<UsageAmountScreen> {
  final TextEditingController usageAmountController = TextEditingController();
  bool _isNextDisabled = true;

  @override
  void initState() {
    usageAmountController.addListener(_checkField);
    super.initState();
  }

  @override
  void dispose() {
    usageAmountController.dispose();
    super.dispose();
  }

  void _checkField() {
    if (usageAmountController.text.trim().isNotEmpty) {
      setState(() {
        _isNextDisabled = false;
      });
    } else {
      setState(() {
        _isNextDisabled = true;
      });
    }
  }

  Future<void> _showDatePickerModal(BuildContext context) async {
    DateTime selectedDate = DateTime.now();

    final resultDate = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Custom AppBar for the bottom sheet
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black12,
                //     blurRadius: 4.0,
                //   ),
                // ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new),
                        onPressed: () {
                          Navigator.pop(context); // Close the bottom sheet
                        },
                      ),
                      RichText(
                        text: const TextSpan(
                          text: '사용날짜 입력',
                          style: TextStyle(
                            fontSize: 18.0, // Main title size
                            color: Colors.black, // AppBar text color
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: ' (3/3)',
                              style: TextStyle(
                                fontSize: 14.0, // Smaller size for the fraction
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // const SizedBox(width: 48),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, selectedDate);
                    },
                    child: Text(
                      '완료',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ), // For symmetry with the back button
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 200,
                    child: ScrollDatePicker(
                      selectedDate: selectedDate,
                      locale: const Locale('en'),
                      onDateTimeChanged: (DateTime value) {
                        selectedDate = value;
                      },
                      maximumDate: DateTime(2030, 12, 31),
                      options: DatePickerOptions(isLoop: true),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.pop(
                  //         context, selectedDate); // Pass the date back
                  //   },
                  //   child: const Text('Save Date'),
                  // ),
                ],
              ),
            ),
          ],
        );
      },
    );

    if (resultDate != null) {
      // If a date is selected, pass the data back to the parent screen
      String usageAmount = usageAmountController.text;
      Navigator.pop(context, {
        'usageAmount': usageAmount,
        'date': DateFormat('yyyy-MM-dd').format(resultDate),
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
              text: '사용량 입력',
              style: TextStyle(
                fontSize: 18.0, // Main title size
                color: Colors.black, // AppBar text color
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: ' (2/3)',
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
            onPressed: _isNextDisabled
                ? null
                : () async {
                    await _showDatePickerModal(context);
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
            Container(
              padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
              decoration: const BoxDecoration(
                color: Color(0xFFF0F0F0),
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
              ),
              child: Row(
                children: [
                  const Text(
                    "사용량",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(width: 35),
                  Expanded(
                    child: TextField(
                      controller: usageAmountController,
                      onChanged: (value) {
                        _checkField();
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          style: IconButton.styleFrom(
                              overlayColor: Colors.transparent),
                          onPressed: () {
                            usageAmountController.clear();
                          },
                        ),
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
