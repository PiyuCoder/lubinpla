import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lubinpla/components/register/screen_three.dart';
import 'package:lubinpla/components/error_message.dart';
import 'package:lubinpla/models/user_data.dart';

class StepTwoScreen extends StatefulWidget {
  final UserData userData;
  const StepTwoScreen({super.key, required this.userData});

  @override
  _StepTwoScreenState createState() => _StepTwoScreenState();
}

class _StepTwoScreenState extends State<StepTwoScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController authCodeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isResendDisabled = false; // To disable the resend button
  bool _isNextDisabled = true; // To disable the Next button initially
  bool _isAuthenticated = false; // To track authentication status
  bool _isAuthCodeRequested = false; // To track if the auth code is requested
  int _secondsRemaining = 60; // Countdown for 1 minute
  Timer? _timer;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    emailController.text = widget.userData.email;
    _checkNextButtonEnabled(); // Check if the Next button should be enabled
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when disposing the screen
    emailController.dispose();
    authCodeController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Function to check if the Next button should be enabled
  void _checkNextButtonEnabled() {
    setState(() {
      _isNextDisabled = emailController.text.isEmpty;
    });
  }

// Function to send the request for a new authentication code
  Future<void> _sendAuthCodeRequest() async {
    try {
      print("sending request for auth code");

      final Map<String, dynamic> requestBody = {
        'email': emailController.text, // Send the entered email
      };

      // If it's a resend request, add the 'resend' key to the body
      if (_isAuthCodeRequested) {
        requestBody['resend'] =
            true; // Add resend flag if it's a resend request
      }

      final response = await http.post(
        Uri.parse('http://15.165.115.39:8080/api/auths/send-auth-number/email'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isAuthCodeRequested = true; // Mark that auth code is requested
          _secondsRemaining = 60; // Reset the timer for 1 minute
          _isResendDisabled = true; // Disable the resend button while countdown
          errorMessage = null;
        });
        _startCountdown(); // Start the countdown again
      } else {
        throw Exception('Failed to send authentication code');
      }
    } catch (error) {
      print('Error sending authentication code: $error');
      setState(() {
        errorMessage = 'Failed to send authentication code. Please try again.';
      });
    }
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _isResendDisabled =
              false; // Enable resend when the countdown finishes
        });
        _timer?.cancel();
      }
    });
  }

  // Function to handle the "Next" button press (to validate the auth code and move to next screen)
  Future<void> _goToStepThree() async {
    if (authCodeController.text.isEmpty) {
      setState(() {
        errorMessage = 'Please enter the authentication code.';
      });
      return;
    }

    // Send code to this API POST /api/auths/verify-auth-number/email
    try {
      final response = await http.post(
        Uri.parse(
            'http://15.165.115.39:8080/api/auths/verify-auth-number/email'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': emailController.text, // Send the entered email
          'token': authCodeController.text, // Send the entered code
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isAuthenticated = true; // Mark as authenticated
        });

        widget.userData.email = emailController.text;
        // Proceed to the next screen after successful authentication
        print("Authenticated successfully!");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                StepThreeScreen(userData: widget.userData), // Next screen
          ),
        );
      } else {
        throw Exception('Authentication failed');
      }
    } catch (error) {
      print('Error verifying authentication code: $error');
      setState(() {
        errorMessage = 'Invalid authentication code.';
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
            Navigator.pop(context); // Go back to LoginScreen
          },
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: RichText(
            text: const TextSpan(
              text: '사용할 이메일 입력',
              style: TextStyle(
                fontSize: 18.0, // Main title size
                color: Colors.black, // AppBar text color
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: '(2/6)',
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
                : () {
                    if (!_isAuthCodeRequested) {
                      print("Auth code is not requested, sending request...");
                      _sendAuthCodeRequest();
                    } else {
                      print(
                          "Auth code already requested, going to next screen...");
                      _goToStepThree();
                    }
                  },
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
            // Email input field
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 1.0),
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    '이메일',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '입력해주세요',
                        suffixIcon: IconButton(
                          style: IconButton.styleFrom(
                              overlayColor: Colors.transparent),
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            emailController.clear();
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
            // Conditionally show the auth code field and password field after requesting the auth code
            Visibility(
              visible: _isAuthCodeRequested,
              child: Column(
                children: [
                  // Authentication code input field
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          '인증번호',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: authCodeController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '입력해주세요',
                              suffixIcon: IconButton(
                                style: IconButton.styleFrom(
                                    overlayColor: Colors.transparent),
                                icon:
                                    const Icon(Icons.clear, color: Colors.grey),
                                onPressed: () {
                                  authCodeController.clear();
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
                  const SizedBox(height: 16),

                  const SizedBox(height: 16),
                  // Resend button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '$_secondsRemaining',
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.red,
                        ),
                      ),
                      TextButton(
                        onPressed:
                            _isResendDisabled ? null : _sendAuthCodeRequest,
                        child: Text(
                          '재전송',
                          style: TextStyle(
                            color:
                                _isResendDisabled ? Colors.grey : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            ErrorDisplay(errorMessage: errorMessage),
          ],
        ),
      ),
    );
  }
}
