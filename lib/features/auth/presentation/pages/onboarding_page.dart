import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pushReplacementNamed(AppRoutes.login),
          child: const Text('Get Started'),
        ),
      ),
    );
  }
}
