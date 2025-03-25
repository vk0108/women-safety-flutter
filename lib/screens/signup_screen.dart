import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_new_app/main.dart';
import 'package:my_new_app/screens/home_screen.dart';
import 'otp_verification_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emergency1Controller = TextEditingController();
  final TextEditingController emergency2Controller = TextEditingController();
  final TextEditingController emergency3Controller = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
              ),
              TextField(
                controller: dobController,
                decoration: const InputDecoration(labelText: "Date of Birth"),
              ),
              TextField(
                controller: emergency1Controller,
                decoration: const InputDecoration(
                  labelText: "Emergency Contact 1",
                ),
              ),
              TextField(
                controller: emergency2Controller,
                decoration: const InputDecoration(
                  labelText: "Emergency Contact 2",
                ),
              ),
              TextField(
                controller: emergency3Controller,
                decoration: const InputDecoration(
                  labelText: "Emergency Contact 3 (Optional)",
                ),
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: "Address"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _createAccountAndSaveInformation(context);
                },
                child: const Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createAccountAndSaveInformation(BuildContext context) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString(),
      );
      print('${userCredential.user}');

      if (userCredential.user != null) {
        HashMap<String, dynamic> map = HashMap<String, dynamic>();

        map['name'] = nameController.text.toString();
        map['dob'] = dobController.text.toString();
        map['email'] = emailController.text.toString();
        map['phone'] = phoneController.text.toString();
        map['emergency1'] = emergency1Controller.text.toString();
        map['emergency2'] = emergency2Controller.text.toString();
        map['emergency3'] = emergency3Controller.text.toString();
        map['id'] = userCredential.user?.uid;

        await FirebaseFirestore.instance.collection('users').add(map);

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) {
              return HomeScreen();
            },
          ),
          (route) {
            // if( route is (MaterialPageRoute('/')))
            // {

            // }
            // print(route);
            return false;
          },
        );
      } else {}
    } catch (e) {
      print(e);
    } finally {}
  }
}
