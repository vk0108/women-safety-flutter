import 'package:flutter/material.dart';

class SafetyToolsScreen extends StatelessWidget {
  const SafetyToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Safety Tools & Tips")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Safety Tools & Tips",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Things to Carry Section
            ExpansionTile(
              title: Text(
                "Things to Carry",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              children: [
                ListTile(title: Text("🔦 Flashlight (or a phone with a flashlight)")),
                ListTile(title: Text("🔋 Power bank for emergency charging")),
                ListTile(title: Text("📱 Fully charged mobile phone with emergency contacts saved")),
                ListTile(title: Text("🔑 Personal safety alarm or whistle")),
                ListTile(title: Text("💊 Basic medical kit (band-aids, sanitizer, pepper spray, etc.)")),
                ListTile(title: Text("💳 ID card or a photocopy of essential documents")),
                ListTile(title: Text("💰 Emergency cash or a backup debit card")),
              ],
            ),

            SizedBox(height: 10),

            // What to Do in Danger Section
            ExpansionTile(
              title: Text(
                "What to Do in Danger",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              children: [
                ListTile(title: Text("📍 Share your live location with trusted contacts using the SOS feature.")),
                ListTile(title: Text("🚨 Scream or use a personal alarm to attract attention.")),
                ListTile(title: Text("📞 Call emergency services (police, ambulance) immediately.")),
                ListTile(title: Text("🛑 Avoid confrontation; try to escape the situation safely.")),
                ListTile(title: Text("📝 Observe surroundings (license plates, landmarks) and report details later.")),
                ListTile(title: Text("🚶‍♀️ Stay in well-lit areas and avoid shortcuts through isolated places.")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
