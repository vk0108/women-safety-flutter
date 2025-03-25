import 'package:flutter/material.dart';

class SafetyToolsScreen extends StatelessWidget {
  const SafetyToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Safety Tools & Tips",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.pink.shade400,
        foregroundColor: Colors.white,
        elevation: 5,
      ),
      body: SingleChildScrollView(  // ✅ Added to enable scrolling
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Text(
                  "Stay Safe & Prepared! 🛡️",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink.shade700,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Things to Carry Section
              _buildExpansionTile(
                title: "Things to Carry",
                icon: Icons.backpack,
                color: Colors.pink.shade100,
                children: [
                  _buildListItem("🔦 Flashlight (or phone with flashlight)"),
                  _buildListItem("🔋 Power bank for emergency charging"),
                  _buildListItem("📱 Mobile phone with emergency contacts saved"),
                  _buildListItem("🔑 Personal safety alarm or whistle"),
                  _buildListItem("💊 Basic medical kit (band-aids, sanitizer, etc.)"),
                  _buildListItem("💳 ID card or photocopy of essential documents"),
                  _buildListItem("💰 Emergency cash or a backup debit card"),
                ],
              ),

              const SizedBox(height: 10),

              // What to Do in Danger Section
              _buildExpansionTile(
                title: "What to Do in Danger",
                icon: Icons.warning_amber_rounded,
                color: Colors.pink.shade200,
                children: [
                  _buildListItem("📍 Share your live location with trusted contacts."),
                  _buildListItem("🚨 Scream or use a personal alarm to attract attention."),
                  _buildListItem("📞 Call emergency services immediately."),
                  _buildListItem("🛑 Avoid confrontation; try to escape safely."),
                  _buildListItem("📝 Observe surroundings (license plates, landmarks) and report details later."),
                  _buildListItem("🚶‍♀️ Stay in well-lit areas; avoid isolated shortcuts."),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom ExpansionTile with color
  Widget _buildExpansionTile({required String title, required IconData icon, required Color color, required List<Widget> children}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      color: color,
      child: ExpansionTile(
        title: Row(
          children: [
            Icon(icon, color: Colors.pink.shade700),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink.shade900),
            ),
          ],
        ),
        children: children,
      ),
    );
  }

  // Custom List Item
  Widget _buildListItem(String text) {
    return ListTile(
      leading: const Icon(Icons.check_circle, color: Colors.pink),
      title: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }
}
