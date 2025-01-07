import 'package:flutter/material.dart';
import 'package:lubinpla/models/project_create_data.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:intl/intl.dart'; // Import intl package

class StartDateModal extends StatefulWidget {
  final String productName;
  final String usageAmount;

  const StartDateModal({
    super.key,
    required this.productName,
    required this.usageAmount,
  });

  @override
  _StartDateModalState createState() => _StartDateModalState();
}

class _StartDateModalState extends State<StartDateModal> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Ensures the dialog doesn't take full height
          children: [
            Text(
              "Select Start Date",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200, // Restrict the height of the date picker
              child: ScrollDatePicker(
                selectedDate: selectedDate,
                locale: const Locale('en'),
                onDateTimeChanged: (DateTime value) {
                  setState(() {
                    selectedDate = value;
                  });
                },
                maximumDate: DateTime(2030, 12, 31),
                options: DatePickerOptions(
                  isLoop: true,
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Format the selected date before passing it
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(selectedDate);

                // Save the product and return it to the previous screen
                final product = Product(
                  name: widget.productName,
                  usageAmount: widget.usageAmount,
                  date: formattedDate, // Use the formatted date
                );

                Navigator.pop(
                    context, product); // Close the modal with the result
              },
              child: const Text('Save Date'),
            ),
          ],
        ),
      ),
    );
  }
}
