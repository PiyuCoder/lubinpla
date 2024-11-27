import 'package:flutter/material.dart';

class StepFinalScreen extends StatelessWidget {
  const StepFinalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 80.0),
          // Logo
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              'assets/big-logo.png', // Replace with your logo's path
              height: 150.0,
              width: 150.0,
            ),
          ),
          const SizedBox(height: 20.0),

          // Main content (Welcome text and Hello text)
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '김아무개 님', // Change name as required
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 2.0),
                Text(
                  '반가워요',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // Button taking full width
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: SizedBox(
              width: double.infinity, // Makes the button take full width
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/dashboard');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                ),
                child: const Text(
                  '시작',
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
