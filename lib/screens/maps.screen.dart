import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    _loadCrimeData();
    super.initState();
  }

  Future<BitmapDescriptor> createRoundMarker(Color color) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Paint paint = Paint()..color = color;
    const double size = 16; // Size of marker

    // Draw the circle
    canvas.drawCircle(const Offset(size / 2, size / 2), size / 2, paint);

    final ui.Picture picture = pictureRecorder.endRecording();
    final ui.Image image = await picture.toImage(size.toInt(), size.toInt());
    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    final Uint8List uint8list = byteData!.buffer.asUint8List();

    return BitmapDescriptor.bytes(uint8list);
  }

  Future<void> _loadCrimeData() async {
    final String response = await rootBundle.loadString('assets/ml.json');
    final List<dynamic> data = json.decode(response);

    Set<Marker> markers = {};

    for (var crime in data) {
      double latitude = crime['latitude'];
      double longitude = crime['longitude'];
      double crimeScore = crime['crime_score'];

      // BitmapDescriptor markerColor =
      //     crimeScore < 0.5
      //         ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
      //         : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);

      Color markerColor = crimeScore < 0.5 ? Colors.green : Colors.red;

      markers.add(
        Marker(
          markerId: MarkerId('$latitude,$longitude'),
          position: LatLng(latitude, longitude),
          icon: await createRoundMarker(markerColor),
          infoWindow: InfoWindow(
            title: crime['Crime_Type'],
            snippet: 'Crime Score: $crimeScore',
          ),
        ),
      );
    }

    setState(() {
      _markers = markers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google Maps in Flutter')),
      body: GoogleMap(
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(12.9716, 77.5946),
          // Default location (adjust as needed)
          zoom: 12,
        ),
        markers: _markers,
      ),
    );
  }
}
