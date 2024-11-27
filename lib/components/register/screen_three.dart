import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lubinpla/components/error_message.dart';
import 'package:lubinpla/components/register/screen_four.dart';
import 'package:lubinpla/components/success_message.dart';
import 'package:lubinpla/models/user_data.dart';

class StepThreeScreen extends StatefulWidget {
  final UserData userData;
  const StepThreeScreen({super.key, required this.userData});

  @override
  _StepThreeScreenState createState() => _StepThreeScreenState();
}

class _StepThreeScreenState extends State<StepThreeScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isNextDisabled = true; // To disable the Next button initially

  @override
  void initState() {
    super.initState();
    // Initial check if the Next button should be enabled
    _checkNextButtonEnabled();
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // Function to check if the Next button should be enabled
  void _checkNextButtonEnabled() {
    setState(() {
      // Enable Next button only if both passwords match, are not empty,
      // and meet the password requirements (alphanumeric + special characters)
      _isNextDisabled = (passwordController.text.isEmpty) ||
          confirmPasswordController.text.isEmpty ||
          passwordController.text != confirmPasswordController.text ||
          !isValidPassword(passwordController.text);
    });
  }

  // Function to validate the password (should contain special characters and be alphanumeric)
  bool isValidPassword(String password) {
    final RegExp passwordRegex = RegExp(r'^(?=.*[a-zA-Z])(?=.*[\W_]).{8,}$');
    return passwordRegex.hasMatch(password);
  }

  // Function to handle the "Next" button press (to proceed to the next screen)
  Future<void> _goToStepFour() async {
    // Proceed to the next screen after successful password confirmation
    print("Password confirmed successfully!");
    widget.userData.password = passwordController.text; // Set the password
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StepFourScreen(
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
              text: '비밀번호 설정',
              style: TextStyle(
                fontSize: 18.0, // Main title size
                color: Colors.black, // AppBar text color
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: '(3/6)',
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
                : _goToStepFour, // Disable button if passwords don't match
            child: Text(
              '다음',
              style: TextStyle(
                  color: !_isNextDisabled ? Colors.black : Colors.grey),
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
              child: Row(
                children: [
                  const Text(
                    '비밀번호',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '입력해주세요',
                        suffixIcon: IconButton(
                          style: IconButton.styleFrom(
                              overlayColor: Colors.transparent),
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            passwordController.clear();
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
            // Confirm password input field
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 1.0),
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    '비밀번호 확인',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: confirmPasswordController,

                      obscureText: true, // Hide the confirm password text
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '입력해주세요',
                        suffixIcon: IconButton(
                          style: IconButton.styleFrom(
                              overlayColor: Colors.transparent),
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            confirmPasswordController.clear();
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
            const Spacer(),
            // Optionally, you can display a message if the passwords don't match
            if (passwordController.text != confirmPasswordController.text &&
                isValidPassword(passwordController.text) &&
                passwordController.text.isNotEmpty)
              const ErrorDisplay(
                errorMessage: '비밀번호가 일치하지 않습니다.',
              ),
            // Display password validation message
            if (!isValidPassword(passwordController.text) &&
                passwordController.text.isNotEmpty)
              const ErrorDisplay(
                errorMessage: '비밀번호는 8자 이상이어야 하며, 알파벳과 특수문자를 포함해야 합니다.',
              ),
            if (passwordController.text == confirmPasswordController.text &&
                isValidPassword(passwordController.text) &&
                passwordController.text.isNotEmpty)
              const SuccessDisplay(
                successMessage: '비밀번호가 일치합니다',
              ),
          ],
        ),
      ),
    );
  }
}
