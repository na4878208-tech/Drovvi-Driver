import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'driver_location_model.dart';
import 'driver_location_repo.dart';

/// ===============================
/// DRIVER LOCATION CONTROLLER PROVIDER
/// ===============================
final driverLocationControllerProvider =
    StateNotifierProvider<
      DriverLocationController,
      AsyncValue<DriverLocationResponse>
    >((ref) {
      final repo = ref.watch(driverLocationRepositoryProvider);
      return DriverLocationController(repo);
    });

/// ===============================
/// DRIVER LOCATION CONTROLLER
/// ===============================
class DriverLocationController
    extends StateNotifier<AsyncValue<DriverLocationResponse>> {
  final DriverLocationRepository repository;

  DriverLocationController(this.repository)
    : super(
        AsyncValue.data(DriverLocationResponse(success: false, message: '')),
      );

  /// ===============================
  /// UPDATE DRIVER LOCATION
  /// ===============================
  Future<void> updateLocation({
    required double latitude,
    required double longitude,
    double speed = 0.0,
  }) async {
    state = const AsyncValue.loading();
    try {
      final res = await repository.updateDriverLocation(
        latitude: latitude,
        longitude: longitude,
        speed: speed,
      );
      state = AsyncValue.data(res);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
