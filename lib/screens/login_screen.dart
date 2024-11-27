import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lubinpla/screens/dashboard.dart';
import 'package:lubinpla/screens/find_email_pass.dart';
import 'package:lubinpla/screens/register_screen.dart';
import 'package:lubinpla/components/error_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isButtonEnabled = false;
  bool isPasswordVisible = false;
  bool isAutoLoginChecked = false;

  String? errorMessage; // Variable to store the error message

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      isButtonEnabled = _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('http://15.165.115.39:8080/api/auths/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Extract the token
        final token = responseData['token'];

        // Extract the name object
        final name = responseData['name'];
        final surname = name['surName']; // Extract surName
        final givenName = name['givenName']; // Extract givenName
        // final fullName = name['name']; // Extract full name (optional)

        // Save the token and name details using SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('surname', surname);
        await prefs.setString('givenName', givenName);
        // await prefs.setString('fullName', fullName); // Optional

        // Navigate to the dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
      } else {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        setState(() {
          errorMessage = responseBody['error'] ?? '로그인에 실패했습니다';
        });
      }
    } catch (error) {
      print('Error during login: $error');
      setState(() {
        errorMessage = 'An error occurred. Please try again later.';
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Row(
                children: [
                  const Text(
                    '로그인',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 80),
                  Image.asset(
                    'assets/logo.png',
                    width: 60,
                    height: 60,
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Text(
                '안녕하세요, 루빈플라입니다\n서비스 이용을 위해 로그인 해주세요',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                textAlign: TextAlign.start,
                maxLines: null,
                softWrap: true,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                      decoration: const BoxDecoration(
                          color: Color(0xFFF0F0F0),
                          borderRadius:
                              BorderRadius.all(Radius.circular(40.0))),
                      child: Row(
                        children: [
                          const Text(
                            "이메일",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(width: 35),
                          Expanded(
                            child: TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '',
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: Colors.grey),
                                  style: IconButton.styleFrom(
                                      overlayColor: Colors.transparent),
                                  onPressed: () {
                                    _emailController.clear();
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

                    const SizedBox(height: 20),
                    //Password input
                    Container(
                      padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                      decoration: const BoxDecoration(
                          color: Color(0xFFF0F0F0),
                          borderRadius:
                              BorderRadius.all(Radius.circular(40.0))),
                      child: Row(
                        children: [
                          const Text(
                            "비밀번호",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: TextField(
                              controller: _passwordController,
                              obscureText: !isPasswordVisible,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      style: IconButton.styleFrom(
                                          overlayColor: Colors.transparent),
                                      icon: Icon(
                                        isPasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          isPasswordVisible =
                                              !isPasswordVisible;
                                        });
                                      },
                                    ),
                                    IconButton(
                                      style: IconButton.styleFrom(
                                          overlayColor: Colors.transparent),
                                      icon: const Icon(Icons.clear,
                                          color: Colors.grey),
                                      onPressed: _passwordController.clear,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "영문, 숫자, 특수문자를 포함하여 최소 8자리 이상",
                          style: TextStyle(color: Colors.grey, fontSize: 10.0),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Transform.scale(
                              scale: 0.7,
                              child: Checkbox(
                                value: isAutoLoginChecked,
                                activeColor: Colors.black,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isAutoLoginChecked = value ?? false;
                                  });
                                },
                              ),
                            ),
                            const Text("자동로그인",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12.0)),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const FindEmailPass()),
                            );
                          },
                          child: const Text(
                            "이메일 / 비밀번호 찾기",
                            style:
                                TextStyle(color: Colors.black, fontSize: 12.0),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterScreen()),
                            );
                          },
                          child: const Text(
                            "회원가입",
                            style:
                                TextStyle(color: Colors.black, fontSize: 12.0),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ErrorDisplay(errorMessage: errorMessage),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: isButtonEnabled ? _handleLogin : null,
                        child:
                            Text('로그인', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          backgroundColor:
                              isButtonEnabled ? Colors.black : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
