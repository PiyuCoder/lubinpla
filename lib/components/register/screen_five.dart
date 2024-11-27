import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lubinpla/components/error_message.dart';
import 'package:lubinpla/components/register/screen_six.dart';
import 'package:lubinpla/components/success_message.dart';
import 'package:lubinpla/models/user_data.dart';

class StepFiveScreen extends StatefulWidget {
  final UserData userData;
  const StepFiveScreen({super.key, required this.userData});

  @override
  _StepFiveScreenState createState() => _StepFiveScreenState();
}

class _StepFiveScreenState extends State<StepFiveScreen> {
  final TextEditingController invitationController = TextEditingController();
  String? errorMessage;
  String? successMessage;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    invitationController.dispose();
    super.dispose();
  }

  // Function to verify the invitation code and go to the next screen
  Future<void> _goToStepSix() async {
    setState(() {
      errorMessage = null;
      successMessage = null;
    });

    String invitationCode = invitationController.text;
    String email = widget.userData.email;

    if (invitationCode.isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StepSixScreen(userData: widget.userData),
        ),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://15.165.115.39:8080/api/auths/verify-invitation-code'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'invitationCode': invitationCode, "email": email}),
      );

      if (response.statusCode == 200) {
        // Show success message for 2 seconds
        setState(() {
          successMessage = '초대코드가 등록되었습니다';
        });

        await Future.delayed(const Duration(seconds: 2));

        widget.userData.invitationCode = invitationCode;

        // Proceed to next screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StepSixScreen(userData: widget.userData),
          ),
        );
      } else {
        // Handle error response
        setState(() {
          errorMessage = '유효한 초대코드가 아닙니다';
        });
      }
    } catch (error) {
      print('Error during invitation code verification: $error');
      setState(() {
        errorMessage = '초대코드 확인 중 오류가 발생했습니다. 다시 시도해주세요.';
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
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: RichText(
            text: const TextSpan(
              text: '초대코드 입력',
              style: TextStyle(
                fontSize: 18.0, // Main title size
                color: Colors.black, // AppBar text color
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: '(5/6)',
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
            onPressed: _goToStepSix, // Proceed to the next screen
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
            // Invitation code input
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 1.0),
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    '초대코드',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: invitationController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '입력해주세요',
                        suffixIcon: IconButton(
                          style: IconButton.styleFrom(
                              overlayColor: Colors.transparent),
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            invitationController.clear();
                          },
                        ),
                        hintStyle: const TextStyle(color: Colors.grey),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Display error or success message
            if (errorMessage != null) ErrorDisplay(errorMessage: errorMessage!),
            if (successMessage != null)
              SuccessDisplay(successMessage: successMessage!),
          ],
        ),
      ),
    );
  }
}
