import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart'; // For Flutter mobile
import 'package:latlong2/latlong.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showLocation = false;
  LatLng? _userLocation;
  LocationPermission? permission; // Declare permission variable here

  Future<void> _requestLocationPermission() async {
    // Implement platform-specific logic to request location permission
    // and handle errors appropriately. For example, on Flutter mobile:
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      // Handle permanently denied permission (e.g., display an error message)
      return;
    }
  }

  Future<void> _getUserLocation() async {
    // Use the appropriate location service library to get the user's
    // current location (e.g., `Geolocation.getCurrentPosition()` on web,
    // `Geolocator.getCurrentPosition()` on mobile).
    // Update the `_userLocation` state variable with the obtained LatLng.
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      // Handle location request errors appropriately (e.g., display an error message)
      print("Error getting location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(
              51.509364, -0.128928), // Replace with your default location
          initialZoom: 9.2,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName:
                'com.example.app', // Replace with your app name
          ),
          CircleLayer(
            circles: [
              if (_userLocation != null)
                CircleMarker(
                  point: _userLocation!,
                  color: Colors.blue.withOpacity(0.3),
                  radius: 100, // Adjust radius as needed
                  useRadiusInMeter: true, // Customize based on requirements
                  borderStrokeWidth: 2,
                  borderColor: Colors.blue,
                ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (!_showLocation) {
            await _requestLocationPermission();
            if (permission == LocationPermission.whileInUse) {
              // Use whileInUse
              await _getUserLocation();
            }
          }
          setState(() {
            _showLocation = !_showLocation;
          });
        },
        child: Icon(_showLocation ? Icons.location_on : Icons.location_off),
      ),
    );
  }
}
