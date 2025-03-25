import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_new_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'community_forum.dart';
import 'safety_tools_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = "";
  String phone = "";
  String emergency1 = "";
  String emergency2 = "";
  String emergency3 = "";

  @override
  void initState() {
    super.initState();
    _loadEmergencyContacts();
  }

  Future<void> _loadEmergencyContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString('name') ?? "";
      phone = prefs.getString('phone') ?? "";
      emergency1 = prefs.getString('emergency1') ?? "";
      emergency2 = prefs.getString('emergency2') ?? "";
      emergency3 = prefs.getString('emergency3') ?? "";
    });

    print("📥 Loaded from SharedPreferences:");
    print("User Phone: $phone");
    print("Emergency Contact 1: $emergency1");
    print("Emergency Contact 2: $emergency2");
    print("Emergency Contact 3: $emergency3");

    if (phone.isEmpty || emergency1.isEmpty) {
      print("❗ Data missing in SharedPreferences. Fetching from Firebase...");
      await _fetchAndStoreEmergencyContacts();
    }
  }

  Future<void> _fetchAndStoreEmergencyContacts() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      print("❌ No user logged in.");
      return;
    }

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('id', isEqualTo: uid)
              .get();

      for (var doc in querySnapshot.docs) {
        if (doc.exists) {
          Map<String, dynamic>? userData = doc.data() as Map<String, dynamic>?;
          if (userData != null) {
            SharedPreferences prefs = await SharedPreferences.getInstance();

            setState(() {
              name = userData['name'] ?? "";
              phone = userData['phone'] ?? "";
              emergency1 = userData['emergency1'] ?? "";
              emergency2 = userData['emergency2'] ?? "";
              emergency3 = userData['emergency3'] ?? "";
            });

            await prefs.setString('name', name);
            await prefs.setString('phone', phone);
            await prefs.setString('emergency1', emergency1);
            await prefs.setString('emergency2', emergency2);
            await prefs.setString('emergency3', emergency3);

            print("✅ Emergency contacts fetched and stored locally!");
          }
          break;
        } else {
          print("❌ User document does not exist.");
        }
      }
    } catch (e) {
      print("🔥 Error fetching emergency contacts: $e");
    }
  }

  void _triggerSOS() async {
    print("🚨 SOS Triggered!");
    print("User name: $name");
    print("User Phone: $phone");
    print("Emergency Contact 1: $emergency1");
    print("Emergency Contact 2: $emergency2");
    print("Emergency Contact 3: $emergency3");

    if (phone.isEmpty || emergency1.isEmpty) {
      print("❌ Error: Emergency contacts are missing!");
      return;
    }

    List<String> phoneNumbers = [
      '+91${emergency1}',
      '+91${emergency2}',
    ]; // Add multiple numbers

    String locationLink = await twilio.getCurrentLocation();
    String message =
        "From $name\n Hey! am in danger Here's my current location: $locationLink";

    await twilio.sendSms(phoneNumbers, message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home"), backgroundColor: Colors.purple),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                const TextField(
                  decoration: InputDecoration(
                    labelText: "From",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                const TextField(
                  decoration: InputDecoration(
                    labelText: "To",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: _triggerSOS,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      "SOS",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CommunityForumScreen(),
                    ),
                  );
                },
                child: _buildButton("Community Forum"),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SafetyToolsScreen(),
                    ),
                  );
                },
                child: _buildButton("Safety Tools & Tips"),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildButton(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(128, 128, 128, 0.3),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
