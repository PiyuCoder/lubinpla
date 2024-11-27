import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lubinpla/components/register/screen_five.dart';
import 'package:lubinpla/models/user_data.dart';

class StepFourScreen extends StatefulWidget {
  final UserData userData;
  const StepFourScreen({super.key, required this.userData});

  @override
  _StepFourScreenState createState() => _StepFourScreenState();
}

class _StepFourScreenState extends State<StepFourScreen> {
  final TextEditingController companyController = TextEditingController();
  final TextEditingController positionController = TextEditingController();

  bool _isNextDisabled = true; // To disable the Next button initially

  @override
  void initState() {
    super.initState();
    // Initial check if the Next button should be enabled
    _checkNextButtonEnabled();
  }

  @override
  void dispose() {
    companyController.dispose();
    positionController.dispose();
    super.dispose();
  }

  // Function to check if the Next button should be enabled
  void _checkNextButtonEnabled() {
    setState(() {
      // Enable Next button only if both passwords match, are not empty,
      // and meet the password requirements (alphanumeric + special characters)
      _isNextDisabled =
          (companyController.text.isEmpty) || positionController.text.isEmpty;
    });
  }

  // Function to handle the "Next" button press (to proceed to the next screen)
  Future<void> _goToStepFive() async {
    // Proceed to the next screen
    print("Saved company and position");
    widget.userData.company = companyController.text;
    widget.userData.position = companyController.text;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StepFiveScreen(
            userData: widget.userData), // Navigate to the next screen
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              text: '소속정보 입력',
              style: TextStyle(
                fontSize: 18.0, // Main title size
                color: Colors.black, // AppBar text color
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: '(4/6)',
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
            onPressed: _goToStepFive, // Disable button if passwords don't match
            child: const Text(
              '다음',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Password input field
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 1.0),
                ),
              ),
              //Company name
              child: Row(
                children: [
                  const Text(
                    '회사명',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: companyController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '입력해주세요',
                        suffixIcon: IconButton(
                          style: IconButton.styleFrom(
                              overlayColor: Colors.transparent),
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            companyController.clear();
                            _checkNextButtonEnabled(); // Recheck if Next button should be enabled
                          },
                        ),
                        hintStyle: const TextStyle(color: Colors.grey),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      onChanged: (_) => _checkNextButtonEnabled(),
                    ),
                  ),
                ],
              ),
            ),
            // Position
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 1.0),
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    '포지션',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: positionController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '입력해주세요',
                        suffixIcon: IconButton(
                          style: IconButton.styleFrom(
                              overlayColor: Colors.transparent),
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            positionController.clear();
                            _checkNextButtonEnabled(); // Recheck if Next button should be enabled
                          },
                        ),
                        hintStyle: const TextStyle(color: Colors.grey),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      onChanged: (_) => _checkNextButtonEnabled(),
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
