import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_computing/services/location.dart'; // Assuming this is your custom service

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LatLng? _initialLocation;
  String? query;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Position position = await LocationService().getCurrentLocation();
    setState(() {
      _initialLocation = LatLng(position.latitude, position.longitude);
    });
    controller.move(_initialLocation!, 16);
  }

  final controller = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            if (_initialLocation !=
                null) // Display map only if location is obtained
              FlutterMap(
                options: MapOptions(
                  center:
                      _initialLocation!, // Use center instead of initialCenter for smoothness
                  zoom: 16, // Set initial zoom level
                  maxZoom: 20,
                ),
                mapController: controller,
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        height: 80,
                        width: 80,
                        point: _initialLocation!,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              shape: BoxShape.circle),
                          child: Icon(
                            Icons.pin_drop,
                            size: 20,
                            color: Colors.red.shade800,
                          ),
                        ),
                        rotate: true,
                      ),
                    ],
                  ),
                ],
              ),
            Center(
              // Display progress indicator only while loading
              child: _initialLocation == null
                  ? CircularProgressIndicator()
                  : SizedBox(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchBar(
                hintText: "Search Location",
                constraints: BoxConstraints(minHeight: 45),
                trailing: [
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () async {
                      // Handle search functionality as needed (replace with your implementation)
                      // For example, use a dialog or sheet to enter search terms
                      // and call LocationService.searchLocation(query) to retrieve results.
                      // Update UI accordingly based on the search results.

                      debugPrint(
                          'Search button pressed, implement your search logic here.');
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.location_on),
        backgroundColor: Colors.black,
        foregroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        onPressed: () {
          _getCurrentLocation();
        },
      ),
    );
  }
}
