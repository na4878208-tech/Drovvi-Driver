import 'package:geolocator/geolocator.dart';

/// Ye function driver ka current GPS location fetch karega
Future<Position> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // 1️⃣ Location service check
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('Location services are disabled.');
  }

  // 2️⃣ Permission check
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception('Location permissions are permanently denied');
  }

  // 3️⃣ Return current position
  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}
