import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LatLng? _location;
  final TextEditingController _addressController =
      TextEditingController(text: "Mountain View");

  final String apiKey = "YOUR_API_KEY";

  Future<void> _getLatLngFromAddress(String address) async {
    final url =
        "https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$apiKey";

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['status'] == "OK") {
      final location = data['results'][0]['geometry']['location'];
      final lat = location['lat'];
      final lng = location['lng'];

      setState(() {
        _location = LatLng(lat, lng);
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_location!, 14),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getLatLngFromAddress("Mountain View");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Google Map View")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      hintText: "Enter Address",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _getLatLngFromAddress(_addressController.text);
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: _location == null
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _location!,
                      zoom: 14,
                    ),
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                    markers: {
                      Marker(
                        markerId: const MarkerId("selected-location"),
                        position: _location!,
                      ),
                    },
                  ),
          ),
        ],
      ),
    );
  }
}