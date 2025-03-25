import 'package:flutter/material.dart';
import 'home_screen.dart';

class OTPVerificationScreen extends StatelessWidget {
  const OTPVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("OTP Verification")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to Home Page after OTP verification
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
          child: Text("Verify OTP"),
        ),
      ),
    );
  }
}
