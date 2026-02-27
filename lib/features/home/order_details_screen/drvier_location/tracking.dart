import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'driver_location_controller.dart';

final driverLocationTrackerProvider =
    Provider<DriverLocationTracker>((ref) {
  return DriverLocationTracker(ref);
});

class DriverLocationTracker {
  final Ref ref;
  Timer? _timer;

  DriverLocationTracker(this.ref);

  /// ▶️ START TRACKING
  void start() {
    if (_timer != null) return; // already running

    if (kDebugMode) {
      print("🟢 DRIVER LOCATION TRACKING STARTED");
    }

    _timer = Timer.periodic(const Duration(seconds: 15), (timer) async {
      try {
        final pos = await Geolocator.getCurrentPosition(
          // ignore: deprecated_member_use
          desiredAccuracy: LocationAccuracy.high,
        );

        if (kDebugMode) {
          print(
            "📡 LOCATION UPDATE → "
            "Lat: ${pos.latitude}, "
            "Lng: ${pos.longitude}, "
            "Speed: ${pos.speed}",
          );
        }

        await ref
            .read(driverLocationControllerProvider.notifier)
            .updateLocation(
              latitude: pos.latitude,
              longitude: pos.longitude,
              speed: pos.speed,
            );
      } catch (e) {
        if (kDebugMode) {
          print("❌ LOCATION TRACK ERROR: $e");
        }
      }
    });
  }

  /// ⏹ STOP TRACKING
  void stop() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;

      if (kDebugMode) {
        print("🔴 DRIVER LOCATION TRACKING STOPPED");
      }
    }
  }
}
