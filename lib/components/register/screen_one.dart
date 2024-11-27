import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lubinpla/components/register/screen_two.dart';
import 'package:lubinpla/models/user_data.dart';
import 'package:lubinpla/screens/login_screen.dart';

class StepOneScreen extends StatefulWidget {
  final UserData userData;
  const StepOneScreen({super.key, required this.userData});
  @override
  _StepOneScreenState createState() => _StepOneScreenState();
}

class _StepOneScreenState extends State<StepOneScreen> {
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool _isNextDisabled = true;

  @override
  void initState() {
    super.initState();
    // Add listeners to all controllers
    surnameController.addListener(_checkFields);
    nameController.addListener(_checkFields);
    phoneController.addListener(_checkFields);
  }

  @override
  void dispose() {
    // Dispose of controllers to avoid memory leaks
    surnameController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _checkFields() {
    if (surnameController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        phoneController.text.length == 10) {
      setState(() {
        _isNextDisabled = false;
      });
      // Navigate to the next screen with updated user data
      widget.userData.surname = surnameController.text;
      widget.userData.name = nameController.text;
      widget.userData.phone = phoneController.text;
      Future.microtask(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StepTwoScreen(userData: widget.userData),
          ),
        );
      });
    }
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: RichText(
            text: const TextSpan(
              text: '내 정보 입력 ',
              style: TextStyle(
                fontSize: 18.0, // Main title size
                color: Colors.black, // AppBar text color
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: '(1/6)',
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
              // Add the logic to move to the next screen or action
              _checkFields();
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
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Surname Input Row
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 1.0),
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    '성',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: TextField(
                      controller: surnameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '입력해주세요',
                        suffixIcon: IconButton(
                          style: IconButton.styleFrom(
                              overlayColor: Colors.transparent),
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            surnameController.clear();
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
            const SizedBox(height: 16),

            // Name Input Row
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 1.0),
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    '이름',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '입력해주세요',
                        suffixIcon: IconButton(
                          style: IconButton.styleFrom(
                              overlayColor: Colors.transparent),
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            nameController.clear();
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
            const SizedBox(height: 16),

            // Phone Input Row
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 1.0),
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    '연락처',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '입력해주세요',
                        suffixIcon: IconButton(
                          style: IconButton.styleFrom(
                              overlayColor: Colors.transparent),
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            phoneController.clear();
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
