import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class CommunityForumScreen extends StatefulWidget {
  const CommunityForumScreen({super.key});

  @override
  CommunityForumScreenState createState() => CommunityForumScreenState();
}

class CommunityForumScreenState extends State<CommunityForumScreen> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _incidentController = TextEditingController();
  final String _currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  // Submit incident report to Firestore
  void _submitReport() async {
    if (_locationController.text.trim().isNotEmpty &&
        _incidentController.text.trim().isNotEmpty) {
      await FirebaseFirestore.instance.collection('community_reports').add({
        'userId': _currentUserId,
        'location': _locationController.text.trim(),
        'message': _incidentController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      _locationController.clear();
      _incidentController.clear();
      Navigator.of(context).pop(); // Close the dialog
    }
  }

  // Open the "New Incident" dialog
  void _showNewIncidentDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Report a New Incident"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: "Location",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _incidentController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Incident Details",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: _submitReport,
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  // Format Firestore timestamp
  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return "Unknown time";
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp.toDate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50], // Light pink background
      appBar: AppBar(
        backgroundColor: Colors.pink, // Pink theme
        title: const Text(
          "📝 Community Forum",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto', // Use a stylish font
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('community_reports')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No reports yet."));
                }

                var reports = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    var report = reports[index];
                    final data = report.data() as Map<String, dynamic>;
                    final bool isMine = data['userId'] == _currentUserId;

                    return Align(
                      alignment:
                      isMine ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMine ? Colors.pink[200] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Display Location
                            Text(
                              "📍 ${data['location'] ?? 'Unknown Location'}",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink.shade900,
                              ),
                            ),
                            const SizedBox(height: 5),

                            // Display Incident Message
                            Text(
                              data['message'] ?? '',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 5),

                            // Display Timestamp
                            Text(
                              _formatTimestamp(data['timestamp']),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink, // Pink button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                ),
                onPressed: _showNewIncidentDialog,
                child: const Text(
                  "+ New Incident",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
