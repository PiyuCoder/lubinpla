import 'package:flutter/material.dart';
import 'package:lubinpla/models/user_data.dart';
import 'package:lubinpla/components/register/screen_one.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a new instance of UserData
    final userData = UserData();

    return MaterialApp(
      home: StepOneScreen(userData: userData), // Pass UserData to StepOneScreen
    );
  }
}
