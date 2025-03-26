import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:my_new_app/main.dart';
import 'package:my_new_app/screens/maps.screen.dart';
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

    await _fetchAndStoreEmergencyContacts();
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
        "From $name\n APP Testing, Hey! am in danger Here's my current location: $locationLink";

    setState(() {
      sosClicked = true;
    });

    _startCountdown(phoneNumbers, message);
  }

  int _countdown = 3; // Start from 3

  void _startCountdown(List<String> phoneNumbers, String message) {
    setState(() {
      _countdown = 3; // Reset countdown
    });

    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_countdown > 1) {
        setState(() {
          _countdown--;
        });
      } else {
        timer.cancel(); // Stop timer
        setState(() {
          sosClicked = false;
        });

        // TODO enable live testing
        // await twilio.sendSms(phoneNumbers, message);
      }
    });
  }

  bool sosClicked = false;

  final TextEditingController sourceController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final String apiKey =
      "AIzaSyDoKln5E27FzBbZsE3cruHXK8O0VzGsfsE"; // Replace with your API key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.pink.shade100,
      ),
      body: Container(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [
                      GooglePlaceAutoCompleteTextField(
                        textEditingController: sourceController,
                        googleAPIKey: apiKey,
                        debounceTime: 800,
                        // Optional: Adjust debounce time
                        isLatLngRequired: true,
                        // If you need latitude & longitude
                        getPlaceDetailWithLatLng: (prediction) {
                          print(
                            "Latitude: ${prediction.lat}, Longitude: ${prediction.lng}",
                          );
                        },
                        itemClick: (prediction) {
                          sourceController.text = prediction.description!;
                          sourceController
                              .selection = TextSelection.fromPosition(
                            TextPosition(offset: sourceController.text.length),
                          );
                        },
                        inputDecoration: InputDecoration(
                          hintText: "Search source...",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_on),
                        ),
                      ),

                      const SizedBox(height: 10),
                      GooglePlaceAutoCompleteTextField(
                        textEditingController: destinationController,
                        googleAPIKey: apiKey,
                        debounceTime: 800,
                        // Optional: Adjust debounce time
                        isLatLngRequired: true,
                        // If you need latitude & longitude
                        getPlaceDetailWithLatLng: (prediction) {
                          print(
                            "Latitude: ${prediction.lat}, Longitude: ${prediction.lng}",
                          );
                        },
                        itemClick: (prediction) {
                          destinationController.text = prediction.description!;
                          destinationController
                              .selection = TextSelection.fromPosition(
                            TextPosition(
                              offset: destinationController.text.length,
                            ),
                          );
                        },
                        inputDecoration: InputDecoration(
                          hintText: "Search destination...",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_on),
                        ),
                      ),

                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MapScreen(),
                            ),
                          );
                        },
                        child: Text('Navigate To Map'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: InkWell(
                      onTap: _triggerSOS,
                      splashColor: Colors.green,
                      borderRadius: BorderRadius.circular(75),
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            "SOS",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const CommunityForumScreen(),
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
                ),
                const SizedBox(height: 20),
              ],
            ),
            if (sosClicked)
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Text(
                    '$_countdown',
                    style: TextStyle(fontSize: 50, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
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
