import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lubinpla/components/register/screen_final.dart';
import 'package:lubinpla/models/user_data.dart';

class StepSixScreen extends StatefulWidget {
  final UserData userData;

  const StepSixScreen({Key? key, required this.userData}) : super(key: key);

  @override
  _StepSixScreenState createState() => _StepSixScreenState();
}

final List<Map<String, String>> consentData = [
  {
    'id': 'terms_of_service',
    'title': '모두 동의',
    'description':
        '루빈플라 서비스 이용에 대한 약관입니다. 이 약관은 서비스 제공 및 사용에 필요한 내용을 포함합니다.루빈플라 서비스 이용에 대한 약관입니다. 이 약관은 서비스 제공 및 사용에 필요한 내용을 포함합니다.루빈플라 서비스 이용에 대한 약관입니다. 이 약관은 서비스 제공 및 사용에 필요한 내용을 포함합니다.루빈플라 서비스 이용에 대한 약관입니다. 이 약관은 서비스 제공 및 사용에 필요한 내용을 포함합니다.루빈플라 서비스 이용에 대한 약관입니다. 이 약관은 서비스 제공 및 사용에 필요한 내용을 포함합니다.루빈플라 서비스 이용에 대한 약관입니다. 이 약관은 서비스 제공 및 사용에 필요한 내용을 포함합니다.루빈플라 서비스 이용에 대한 약관입니다. 이 약관은 서비스 제공 및 사용에 필요한 내용을 포함합니다.루빈플라 서비스 이용에 대한 약관입니다. 이 약관은 서비스 제공 및 사용에 필요한 내용을 포함합니다.루빈플라 서비스 이용에 대한 약관입니다. 이 약관은 서비스 제공 및 사용에 필요한 내용을 포함합니다.루빈플라 서비스 이용에 대한 약관입니다. 이 약관은 서비스 제공 및 사용에 필요한 내용을 포함합니다.루빈플라 서비스 이용에 대한 약관입니다. 이 약관은 서비스 제공 및 사용에 필요한 내용을 포함합니다.루빈플라 서비스 이용에 대한 약관입니다. 이 약관은 서비스 제공 및 사용에 필요한 내용을 포함합니다.루빈플라 서비스 이용에 대한 약관입니다. 이 약관은 서비스 제공 및 사용에 필요한 내용을 포함합니다.루빈플라 서비스 이용에 대한 약관입니다. 이 약관은 서비스 제공 및 사용에 필요한 내용을 포함합니다.루빈플라 서비스 이용에 대한 약관입니다. 이 약관은 서비스 제공 및 사용에 필요한 내용을 포함합니다.'
  },
  {
    'id': 'privacy_policy',
    'title': '루빈플라 이용약관 동의',
    'description':
        '루빈플라의 개인정보 처리방침입니다. 이 방침은 개인정보 수집, 사용, 공유 및 보호와 관련된 사항을 포함합니다.루빈플라의 개인정보 처리방침입니다. 이 방침은 개인정보 수집, 사용, 공유 및 보호와 관련된 사항을 포함합니다.루빈플라의 개인정보 처리방침입니다. 이 방침은 개인정보 수집, 사용, 공유 및 보호와 관련된 사항을 포함합니다.루빈플라의 개인정보 처리방침입니다. 이 방침은 개인정보 수집, 사용, 공유 및 보호와 관련된 사항을 포함합니다.마케팅 정보 수신에 동의하시면 루빈플라에서 제공하는 다양한 할인 정보와 이벤트를 받아보실 수 있습니다.마케팅 정보 수신에 동의하시면 루빈플라에서 제공하는 다양한 할인 정보와 이벤트를 받아보실 수 있습니다.마케팅 정보 수신에 동의하시면 루빈플라에서 제공하는 다양한 할인 정보와 이벤트를 받아보실 수 있습니다.마케팅 정보 수신에 동의하시면 루빈플라에서 제공하는 다양한 할인 정보와 이벤트를 받아보실 수 있습니다.마케팅 정보 수신에 동의하시면 루빈플라에서 제공하는 다양한 할인 정보와 이벤트를 받아보실 수 있습니다.마케팅 정보 수신에 동의하시면 루빈플라에서 제공하는 다양한 할인 정보와 이벤트를 받아보실 수 있습니다.마케팅 정보 수신에 동의하시면 루빈플라에서 제공하는 다양한 할인 정보와 이벤트를 받아보실 수 있습니다.마케팅 정보 수신에 동의하시면 루빈플라에서 제공하는 다양한 할인 정보와 이벤트를 받아보실 수 있습니다.마케팅 정보 수신에 동의하시면 루빈플라에서 제공하는 다양한 할인 정보와 이벤트를 받아보실 수 있습니다.마케팅 정보 수신에 동의하시면 루빈플라에서 제공하는 다양한 할인 정보와 이벤트를 받아보실 수 있습니다.'
  },
  {
    'id': 'marketing_info',
    'title': '개인정보 수집 및 이용 동의',
    'description':
        '마케팅 정보 수신에 동의하시면 루빈플라에서 제공하는 다양한 할인 정보와 이벤트를 받아보실 수 있습니다.마케팅 정보 수신에 동의하시면 루빈플라에서 제공하는 다양한 할인 정보와 이벤트를 받아보실 수 있습니다.마케팅 정보 수신에 동의하시면 루빈플라에서 제공하는 다양한 할인 정보와 이벤트를 받아보실 수 있습니다.마케팅 정보 수신에 동의하시면 루빈플라에서 제공하는 다양한 할인 정보와 이벤트를 받아보실 수 있습니다.마케팅 정보 수신에 동의하시면 루빈플라에서 제공하는 다양한 할인 정보와 이벤트를 받아보실 수 있습니다.마케팅 정보 수신에 동의하시면 루빈플라에서 제공하는 다양한 할인 정보와 이벤트를 받아보실 수 있습니다.마케팅 정보 수신에 동의하시면 루빈플라에서 제공하는 다양한 할인 정보와 이벤트를 받아보실 수 있습니다.마케팅 정보 수신에 동의하시면 루빈플라에서 제공하는 다양한 할인 정보와 이벤트를 받아보실 수 있습니다.마케팅 정보 수신에 동의하시면 루빈플라에서 제공하는 다양한 할인 정보와 이벤트를 받아보실 수 있습니다.마케팅 정보 수신에 동의하시면 루빈플라에서 제공하는 다양한 할인 정보와 이벤트를 받아보실 수 있습니다.마케팅 정보 수신에 동의하시면 루빈플라에서 제공하는 다양한 할인 정보와 이벤트를 받아보실 수 있습니다.마케팅 정보 수신에 동의하시면 루빈플라에서 제공하는 다양한 할인 정보와 이벤트를 받아보실 수 있습니다.'
  },
  {
    'id': 'event_notifications',
    'title': '마케팅 활용 및 광고성 정보 수집 동의',
    'description':
        '이벤트 알림 수신 동의 시 최신 이벤트 및 혜택을 안내드립니다.마케팅 정보 수신에 동의하시면 루빈플라에서 제공하는 다양한 할인 정보와 이벤트를 받아보실 수 있습니다.마케팅 정보 수신에 동의하시면 루빈플라에서 제공하는 다양한 할인 정보와 이벤트를 받아보실 수 있습니다.마케팅 정보 수신에 동의하시면 루빈플라에서 제공하는 다양한 할인 정보와 이벤트를 받아보실 수 있습니다.마케팅 정보 수신에 동의하시면 루빈플라에서 제공하는 다양한 할인 정보와 이벤트를 받아보실 수 있습니다.마케팅 정보 수신에 동의하시면 루빈플라에서 제공하는 다양한 할인 정보와 이벤트를 받아보실 수 있습니다.마케팅 정보 수신에 동의하시면 루빈플라에서 제공하는 다양한 할인 정보와 이벤트를 받아보실 수 있습니다.마케팅 정보 수신에 동의하시면 루빈플라에서 제공하는 다양한 할인 정보와 이벤트를 받아보실 수 있습니다.마케팅 정보 수신에 동의하시면 루빈플라에서 제공하는 다양한 할인 정보와 이벤트를 받아보실 수 있습니다.마케팅 정보 수신에 동의하시면 루빈플라에서 제공하는 다양한 할인 정보와 이벤트를 받아보실 수 있습니다.마케팅 정보 수신에 동의하시면 루빈플라에서 제공하는 다양한 할인 정보와 이벤트를 받아보실 수 있습니다.마케팅 정보 수신에 동의하시면 루빈플라에서 제공하는 다양한 할인 정보와 이벤트를 받아보실 수 있습니다.마케팅 정보 수신에 동의하시면 루빈플라에서 제공하는 다양한 할인 정보와 이벤트를 받아보실 수 있습니다.'
  },
];

class _StepSixScreenState extends State<StepSixScreen> {
  bool isMandatory1Selected = false;
  bool isMandatory2Selected = false;
  bool isOptional1Selected = false;
  bool isOptional2Selected = false;

  bool get isNextDisabled => !(isMandatory1Selected && isMandatory2Selected);

  _goToConsentDetails(String consentType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConsentDetailsScreen(
          consentType: consentType,
          userData: widget.userData, // Pass the userData
          onConsentAccepted: (type) {
            // Update the state when consent is accepted
            setState(() {
              if (type == 'terms_of_service') {
                isMandatory1Selected = true;
              } else if (type == 'privacy_policy') {
                isMandatory2Selected = true;
              } else if (type == 'marketing_info') {
                isOptional1Selected = true;
              } else if (type == 'event_notifications') {
                isOptional2Selected = true;
              }
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
              text: '서비스 이용 동의',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: '(6/6)',
                  style: TextStyle(
                    fontSize: 14.0,
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
            onPressed: isNextDisabled ? null : _goToFinal,
            child: Text(
              '다음',
              style: TextStyle(
                color: isNextDisabled ? Colors.grey : Colors.black,
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
            _buildConsentOption(
              title: '모두 동의',
              value: isOptional1Selected,
              onChanged: (value) {
                setState(() {
                  isOptional1Selected = value ?? false;
                });
              },
              onArrowPressed: () => _goToConsentDetails('terms_of_service'),
            ),
            _buildConsentOption(
              title: '루빈플라 이용약관 동의 *',
              value: isMandatory1Selected,
              onChanged: (value) {
                setState(() {
                  isMandatory1Selected = value ?? false;
                });
              },
              onArrowPressed: () => _goToConsentDetails('privacy_policy'),
            ),
            _buildConsentOption(
              title: '개인정보 수집 및 이용 동의 *',
              value: isMandatory2Selected,
              onChanged: (value) {
                setState(() {
                  isMandatory2Selected = value ?? false;
                });
              },
              onArrowPressed: () => _goToConsentDetails('marketing_info'),
            ),
            _buildConsentOption(
              title: '마케팅 활용 및 광고성 정보 수집 동의',
              value: isOptional2Selected,
              onChanged: (value) {
                setState(() {
                  isOptional2Selected = value ?? false;
                });
              },
              onArrowPressed: () => _goToConsentDetails('event_notifications'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsentOption({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
    required VoidCallback onArrowPressed,
  }) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.black,
        ),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
        IconButton(
          style: IconButton.styleFrom(overlayColor: Colors.transparent),
          icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          onPressed: onArrowPressed,
        ),
      ],
    );
  }

  Future<void> _goToFinal() async {
    // Update consents in userData
    widget.userData.consents = {
      "terms_of_service": isMandatory1Selected,
      "privacy_policy": isMandatory2Selected,
      "marketing_info": isOptional1Selected,
      "event_notifications": isOptional2Selected,
    };

    // Construct the JSON body
    final requestBody = {
      "email": widget.userData.email,
      "password": widget.userData.password,
      "name": {
        "surName": widget.userData.surname,
        "givenName": widget.userData.name,
      },
      "phoneNumber": widget.userData.phone,
      "company": widget.userData.company,
      "jobTitle": widget.userData.position,
      "invitationCode": widget.userData.invitationCode,
      "termsOfServiceAccepted": widget.userData.consents["terms_of_service"],
      "marketingAgreementAccepted": widget.userData.consents["marketing_info"],
    };

    print('Request body: ${json.encode(requestBody)}');
    try {
      // Make the API call
      final response = await http.post(
        Uri.parse('http://15.165.115.39:8080/api/auths/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        // Navigate to the next screen on success
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const StepFinalScreen(),
          ),
        );
      } else {
        // Handle error response
        throw Exception('Registration failed: ${response.body}');
      }
    } catch (error) {
      print('Error during registration: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration failed. Please try again.')),
      );
    }
  }
}

class ConsentDetailsScreen extends StatefulWidget {
  final String consentType;
  final UserData userData;
  final Function(String) onConsentAccepted;

  const ConsentDetailsScreen({
    super.key,
    required this.consentType,
    required this.userData,
    required this.onConsentAccepted,
  });

  @override
  _ConsentDetailsScreenState createState() => _ConsentDetailsScreenState();
}

class _ConsentDetailsScreenState extends State<ConsentDetailsScreen> {
  late ScrollController _scrollController;
  bool _isAtBottom = false;
  bool _isShortContent = false;
  bool _isButtonVisible = false; // Control the visibility of the button
  final GlobalKey _scrollViewKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Add listener to detect if user has scrolled to the bottom
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          setState(() {
            _isAtBottom = true; // User has scrolled to the bottom
          });
        } else {
          setState(() {
            _isAtBottom = false; // User is not at the bottom
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Find the consent data based on consentType
    final consentDetail = consentData.firstWhere(
      (consent) => consent['id'] == widget.consentType,
      orElse: () => {
        'title': 'Unknown',
        'description': 'No details available for this consent type.',
      },
    );

    // Check if content fits the screen or if scrolling is needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox =
          _scrollViewKey.currentContext?.findRenderObject() as RenderBox;
      final contentHeight = renderBox.size.height;
      final screenHeight = MediaQuery.of(context).size.height;

      // If content is shorter than the screen height, show the button immediately
      if (contentHeight < screenHeight) {
        setState(() {
          _isShortContent =
              true; // Content fits in the screen, no scrolling needed
          _isButtonVisible = true; // Show button immediately
        });
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(consentDetail['title'] ?? '상세 내용'),
        leading: IconButton(
          style: IconButton.styleFrom(overlayColor: Colors.transparent),
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 80),
                    controller: _scrollController,
                    child: Text(
                      consentDetail['description'] ?? '',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Button visibility logic
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Visibility(
              visible: _isShortContent ||
                  _isAtBottom, // Show button if content is short or at bottom
              child: ElevatedButton(
                onPressed: () {
                  // Update the consent status in userData
                  widget.userData.consents[widget.consentType] = true;

                  // Call the callback to notify the parent screen to update its state
                  widget.onConsentAccepted(widget.consentType);

                  // Navigate back to the previous screen
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                ),
                child: const Text(
                  '동의하기',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
