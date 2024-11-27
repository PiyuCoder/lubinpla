import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lubinpla/screens/login_screen.dart';
import 'package:lubinpla/screens/register_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  late Timer _timer;

  // List of images and their associated texts
  final List<Map<String, String>> _sliderData = [
    {
      'image': 'assets/slider.png',
      'text': '실시간 현장 데이터 수집으로 가장 완벽한 의사결정을',
    },
    {
      'image': 'assets/slider.png',
      'text': '윤활유 특화 인공지능으로 가장 전문적인 대화를 ',
    },
    {
      'image': 'assets/slider.png',
      'text': '추가적인 제품 정보 및 고객 일지로 나만의 개인 맞춤 챗봇을',
    },
  ];

  @override
  void initState() {
    super.initState();

    // Start automatic sliding
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < _sliderData.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0; // Restart with the first image
      }

      // Animate to the next page (loop back to the first page if necessary)
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),

                    // Slider implementation with text
                    Expanded(
                      flex: 20,
                      child: SizedBox(
                        // height: 360, // Adjust height as needed
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _sliderData.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Expanded(
                                  child: Image.asset(
                                    _sliderData[index]['image']!,
                                    fit: BoxFit.cover,
                                    // height: 320,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _sliderData[index]['text']!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Indicators for the slider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _sliderData.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          width: _currentPage == index ? 12.0 : 8.0,
                          height: 5.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                backgroundColor: Colors.grey.shade100,
                              ),
                              child: const Text(
                                '회원가입',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                backgroundColor: Colors.black,
                              ),
                              child: const Text(
                                '로그인',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
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
