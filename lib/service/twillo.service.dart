import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class TwilioService {
  final String accountSid = 'AC4b9aac6378fcf434f6dc351c3c2bf9f2';
  final String twilioNumber = '18884934980';

  Future<void> sendSms(List<String> recipients, String message) async {
    for (String to in recipients) {
      final Uri url = Uri.parse(
        'https://api.twilio.com/2010-04-01/Accounts/$accountSid/Messages.json',
      );

      final response = await http.post(
        url,
        headers: {
          'Authorization':
              'Basic QUM0YjlhYWM2Mzc4ZmNmNDM0ZjZkYzM1MWMzYzJiZjlmMjphYTAyNDU1ZDk1NTQ3MzYwNGI5YWQyMTNlN2YyZjI4Zg==',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'From': twilioNumber, 'To': to, 'Body': message},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('SMS sent to $to successfully!');
      } else {
        print('Failed to send SMS to $to: ${response.body}');
      }
    }
  }

  Future<String> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
    }

    // Check and request location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return 'Location permissions are denied.';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return 'Location permissions are permanently denied.';
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Generate Google Maps link
    String googleMapsLink =
        'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';

    return googleMapsLink;
  }
}
