import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lubinpla/screens/login_screen.dart';
import 'register_screen.dart';

class FindEmailPass extends StatelessWidget {
  const FindEmailPass({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: StepOneScreen(),
    );
  }
}

class StepOneScreen extends StatefulWidget {
  const StepOneScreen({super.key});

  @override
  _StepOneScreenState createState() => _StepOneScreenState();
}

class _StepOneScreenState extends State<StepOneScreen> {
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool _isNextDisabled = true;
  bool _isFindEmail = true;

  bool _showModal = false; // This flag controls the modal visibility
  String _modalTitle = '';
  String _modalMessage = '';
  String _modalButtonTextLeft = '';
  String _modalButtonTextRight = '';
  VoidCallback _onLeftPressed = () {};
  VoidCallback _onRightPressed = () {};

  @override
  void initState() {
    super.initState();
    surnameController.addListener(_checkFields);
    nameController.addListener(_checkFields);
    phoneController.addListener(_checkFields);
    emailController.addListener(_checkFields);
  }

  @override
  void dispose() {
    surnameController.dispose();
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _checkFields() {
    if (_isFindEmail) {
      // Check for Find Email state (all fields must be filled correctly)
      if (surnameController.text.isNotEmpty &&
          nameController.text.isNotEmpty &&
          phoneController.text.isNotEmpty &&
          phoneController.text.length == 10) {
        setState(() {
          _isNextDisabled =
              false; // Enable the "Next" button if all conditions are met
        });
      } else {
        setState(() {
          _isNextDisabled =
              true; // Disable the "Next" button if conditions are not met
        });
      }
    } else {
      // Check for Find Password state (only email needs to be entered)
      if (emailController.text.isNotEmpty) {
        setState(() {
          _isNextDisabled =
              false; // Enable the "Next" button if email is entered
        });
      } else {
        setState(() {
          _isNextDisabled =
              true; // Disable the "Next" button if email is not entered
        });
      }
    }
  }

  void _toggleFindEmailPassword() {
    setState(() {
      _isFindEmail =
          !_isFindEmail; // Toggle between "Find Email" and "Find Password"
    });

    // Clear fields when toggling
    surnameController.clear();
    nameController.clear();
    phoneController.clear();
    emailController.clear();
  }

  Future<void> _checkEmailRegistered() async {
    final String email = emailController.text;

    print("Finding email if registered");
    // Create the request payload
    final Map<String, dynamic> payload = {
      "email": email,
    };

    try {
      final response = await http.post(
        Uri.parse('http://15.165.115.39:8080/api/auths/check-email-registered'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({"email": email}),
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['exists'] == true) {
          // Email is registered
          final res = await http.post(
            Uri.parse('http://15.165.115.39:8080/api/auths/reset-password'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email}),
          );

          if (res.statusCode == 200) {
            setState(() {
              _modalTitle = 'Reset Password';
              _modalMessage = 'Reset link has been sent to your email.';
              _modalButtonTextLeft = '';
              _modalButtonTextRight = '확인';
              _onLeftPressed = () {};
              _onRightPressed = () {
                setState(() {
                  _showModal = false;
                });
              };
              _showModal = true;
            });
          }
        } else {
          // User not registered
          setState(() {
            _modalTitle = 'User Not Found';
            _modalMessage =
                'This user is not registered with the provided information. Please sign up.';
            _modalButtonTextLeft = 'Okay';
            _modalButtonTextRight = 'Register Now';
            _onLeftPressed = () {
              setState(() {
                _showModal = false;
              });
            };
            _onRightPressed = () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterScreen()),
              );
            };
            _showModal = true;
          });
        }
      } else {
        // Error in the response
        setState(() {
          _modalTitle = 'Error';
          _modalMessage =
              'Failed to check registration status. Please try again.';
          _modalButtonTextLeft = '';
          _modalButtonTextRight = 'Okay';
          _onLeftPressed = () {
            setState(() {
              _showModal = false;
            });
          };
          _onRightPressed = () {};
          _showModal = true;
        });
      }
    } catch (error) {
      // Error during the HTTP request
      setState(() {
        _modalTitle = 'Error';
        _modalMessage = 'An error occurred: $error';
        _modalButtonTextLeft = '';
        _modalButtonTextRight = 'Okay';
        _onLeftPressed = () {};
        _onRightPressed = () {
          setState(() {
            _showModal = false;
          });
        };
        _showModal = true;
      });
    }
  }

  Future<void> _findEmail() async {
    final String surname = surnameController.text;
    final String givenName = nameController.text;
    final String phoneNumber = phoneController.text;

    print("Finding user");

    final Map<String, dynamic> payload = {
      "name": {
        "surName": surname,
        "givenName": givenName,
      },
      "phoneNumber": phoneNumber,
    };

    try {
      final response = await http.post(
        Uri.parse('http://15.165.115.39:8080/api/auths/find-email'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData.containsKey('maskedEmail')) {
          // User found: show the email and navigate to login
          setState(() {
            _modalTitle = 'User Found';
            _modalMessage =
                'The email associated with this information is: ${responseData['maskedEmail']}';
            _modalButtonTextLeft = 'Cancel';
            _modalButtonTextRight = 'Login';
            _onLeftPressed = () {
              setState(() {
                _showModal = false;
              });
            };
            _onRightPressed = () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            };
            _showModal = true;
          });
        } else {
          // User not found: navigate to registration
          setState(() {
            _modalTitle = 'User Not Registered';
            _modalMessage = 'This user is not registered. Please sign up.';
            _modalButtonTextLeft = 'Okay';
            _modalButtonTextRight = 'Register Now';
            _onLeftPressed = () {
              setState(() {
                _showModal = false;
              });
            };
            _onRightPressed = () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterScreen()),
              );
            };
            _showModal = true;
          });
        }
      } else if (response.statusCode == 400) {
        setState(() {
          _modalTitle = 'User not found';
          _modalMessage = 'User not found, please check your information.';
          _modalButtonTextLeft = 'Okay';
          _modalButtonTextRight = 'Register Now';
          _onLeftPressed = () {
            setState(() {
              _showModal = false;
            });
          };
          _onRightPressed = () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterScreen()),
            );
          };
          _showModal = true;
        });
      }
    } catch (error) {
      setState(() {
        _modalTitle = 'Error';
        _modalMessage = 'An error occurred: $error';
        _modalButtonTextLeft = 'OK';
        _modalButtonTextRight = '';
        _onLeftPressed = () {
          setState(() {
            _showModal = false;
          });
        };
        _onRightPressed = () {};
        _showModal = true;
      });
    }
  }

  // Helper function to show the modal
  void _showModalDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_modalTitle),
          content: Text(_modalMessage),
          insetPadding: EdgeInsets.symmetric(horizontal: 20.0),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_modalButtonTextLeft.isNotEmpty)
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Dismiss the dialog
                        setState(() {
                          _showModal = false; // Reset modal visibility
                        });
                        _onLeftPressed(); // Trigger additional logic for the left button
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey.shade100,
                        padding: EdgeInsets.symmetric(horizontal: 7.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                      ),
                      child: Text(_modalButtonTextLeft,
                          style: const TextStyle(color: Colors.black)),
                    ),
                  ),
                if (_modalButtonTextLeft.isNotEmpty)
                  SizedBox(
                    width: 15.0,
                  ),
                if (_modalButtonTextRight.isNotEmpty)
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Dismiss the dialog
                        setState(() {
                          _showModal = false; // Reset modal visibility
                        });
                        _onRightPressed(); // Trigger additional logic for the right button
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 13.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                      ),
                      child: Text(
                        _modalButtonTextRight,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    ).then((_) {
      // Ensure modal is reset when dismissed
      setState(() {
        _showModal = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showModal) {
      Future.delayed(Duration.zero, () => _showModalDialog());
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
              text: '이메일 / 비밀번호 찾기 ',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(overlayColor: Colors.transparent),
            onPressed: () {
              _checkFields();
              if (!_isNextDisabled) {
                if (_isFindEmail) {
                  _findEmail(); // Use this method for finding the email
                } else {
                  _checkEmailRegistered(); // Use this method for checking if the email is registered
                } // Call the API when 'Next' is clicked
              }
            },
            child: Text(
              '다음',
              style: TextStyle(
                color: !_isNextDisabled ? Colors.black : Colors.grey,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Toggle buttons for Find Email and Find Password
            Row(
              children: [
                // Find Email Button
                Expanded(
                  child: TextButton(
                    onPressed: () => _toggleFindEmailPassword(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      backgroundColor:
                          _isFindEmail ? Colors.black : Colors.grey.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                    ),
                    child: Text(
                      "이메일 찾기",
                      style: TextStyle(
                        color: _isFindEmail ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Add spacing between the buttons
                // Find Password Button
                Expanded(
                  child: TextButton(
                    onPressed: () => _toggleFindEmailPassword(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      backgroundColor:
                          !_isFindEmail ? Colors.black : Colors.grey.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                    ),
                    child: Text(
                      "비밀번호 찾기",
                      style: TextStyle(
                        color: !_isFindEmail ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Conditional Input Fields
            if (_isFindEmail) ...[
              _buildInputRow('성       ', '입력해주세요', surnameController),
              const SizedBox(height: 16),
              _buildInputRow('이름    ', '입력해주세요', nameController),
              const SizedBox(height: 16),
              _buildInputRow('연락처', '입력해주세요', phoneController),
            ],

            // Email Input Row (only visible when Find Password is selected)
            if (!_isFindEmail) ...[
              const SizedBox(height: 16),
              _buildInputRow('이메일', '입력해주세요', emailController),
            ],
          ],
        ),
      ),
    );
  }

  // Function to build the input row for surname, name, phone, email
  Widget _buildInputRow(
      String label, String hint, TextEditingController controller) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 1.0),
        ),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16.0),
          ),
          const SizedBox(width: 30),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  style: IconButton.styleFrom(overlayColor: Colors.transparent),
                  onPressed: () {
                    controller.clear();
                  },
                ),
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
