import 'package:flutter/material.dart';
import 'package:lubinpla/components/dashboard/project_screen.dart';
import 'package:lubinpla/screens/dashboard.dart';
import 'package:lubinpla/screens/intro_screen.dart';
import 'package:lubinpla/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginScreen(), // Start with the Login screen
    );
  }
}
