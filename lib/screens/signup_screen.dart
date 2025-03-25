import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_new_app/screens/home_screen.dart';

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
      appBar: AppBar(
        title: Center(
          child: Text(
            "Sign Up",
            style: GoogleFonts.merriweather(
              fontWeight: FontWeight.bold,
              color: Colors.pink.shade700,
            ),
          ),
        ),
        backgroundColor: Colors.pink.shade50,
      ),
      body: Stack(
        children: [
          // Background Color with Transparency
          Container(
            color: Colors.pink.shade50.withOpacity(0.5),
          ),

          // Women Logo Background with Transparency
          Positioned.fill(
            child: Image.asset(
              "assets/icon/icon.png",
              fit: BoxFit.cover,
              color: Colors.white.withOpacity(0.2),
              colorBlendMode: BlendMode.dstATop,
            ),
          ),

          // Main Content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTextField(phoneController, "Phone", Icons.phone),
                    _buildTextField(emailController, "Email", Icons.email),
                    _buildTextField(nameController, "Name", Icons.person),
                    _buildTextField(passwordController, "Password", Icons.lock, obscureText: true),
                    _buildDatePickerField(),
                    _buildTextField(emergency1Controller, "Emergency Contact 1", Icons.contact_phone),
                    _buildTextField(emergency2Controller, "Emergency Contact 2", Icons.contact_phone),
                    _buildTextField(emergency3Controller, "Emergency Contact 3 (Optional)", Icons.contact_phone),
                    _buildTextField(addressController, "Address", Icons.home, maxLines: 3),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _createAccountAndSaveInformation(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink.shade500,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        "Register",
                        style: GoogleFonts.tektur(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, IconData icon, {bool obscureText = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon, color: Colors.pink.shade700),
          filled: true,
          fillColor: Colors.white.withOpacity(0.8),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildDatePickerField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: dobController,
        readOnly: true,
        decoration: InputDecoration(
          labelText: "Date of Birth",
          prefixIcon: Icon(Icons.calendar_today, color: Colors.pink.shade700),
          filled: true,
          fillColor: Colors.white.withOpacity(0.8),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null) {
            setState(() {
              dobController.text = "${pickedDate.toLocal()}".split(' ')[0];
            });
          }
        },
      ),
    );
  }

  void _createAccountAndSaveInformation(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        HashMap<String, dynamic> map = HashMap<String, dynamic>();
        map['name'] = nameController.text.trim();
        map['dob'] = dobController.text.trim();
        map['email'] = emailController.text.trim();
        map['phone'] = phoneController.text.trim();
        map['emergency1'] = emergency1Controller.text.trim();
        map['emergency2'] = emergency2Controller.text.trim();
        map['emergency3'] = emergency3Controller.text.trim();
        map['address'] = addressController.text.trim();
        map['id'] = userCredential.user?.uid;

        await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set(map);

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
