import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_new_app/service/twillo.service.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/otp_verification_screen.dart';
import 'screens/signup_screen.dart';

late FirebaseApp app;
late FirebaseAuth auth;
User? currentUser;
late TwilioService twilio;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  app = await Firebase.initializeApp();
  auth = FirebaseAuth.instanceFor(app: app);
  currentUser = auth.currentUser;
  twilio = TwilioService();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My New App',
      theme: ThemeData(primarySwatch: Colors.purple),
      initialRoute: currentUser != null ? '/home' : '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
        '/otp': (context) => const OTPVerificationScreen(),
      },
    );
  }
}
