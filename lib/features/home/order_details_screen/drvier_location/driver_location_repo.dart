import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/api_url.dart';
import '../../../../constants/local_storage.dart';
import '../../../../constants/dio.dart';
import 'driver_location_model.dart';

/// ===============================
/// DRIVER LOCATION REPOSITORY PROVIDER
/// ===============================
final driverLocationRepositoryProvider =
    Provider<DriverLocationRepository>((ref) {
  final dio = ref.watch(dioProvider); // 👈 common Dio instance
  return DriverLocationRepository(dio: dio);
});

/// ===============================
/// DRIVER LOCATION REPOSITORY
/// ===============================
class DriverLocationRepository {
  final Dio dio;

  DriverLocationRepository({required this.dio});

  /// ===============================
  /// UPDATE DRIVER CURRENT LOCATION
  /// ===============================
  Future<DriverLocationResponse> updateDriverLocation({
    required double latitude,
    required double longitude,
    double speed = 0.0,
  }) async {
    try {
      final token = await LocalStorage.getToken();

      final headers = {
        "Content-Type": "application/json",
        if (token != null && token.isNotEmpty)
          "Authorization": "Bearer $token",
      };

      if (kDebugMode) {
        print("📍 UPDATE DRIVER LOCATION");
        print("Lat: $latitude, Lng: $longitude, Speed: $speed");
      }

      final response = await dio.post(
        ApiUrls.updateDriverLocation,
        data: {
          "latitude": latitude,
          "longitude": longitude,
          "speed": speed,
        },
        options: Options(headers: headers),
      );

      if (kDebugMode) {
        print("📍 LOCATION API RESPONSE");
        print(response.data);
      }

      if (response.statusCode == 200) {
        return DriverLocationResponse.fromJson(response.data);
      } else {
        throw Exception(
          response.data['message'] ?? "Failed to update location",
        );
      }
    } on DioError catch (e) {
      final msg = e.response?.data['message'] ?? e.message;
      if (kDebugMode) {
        print("❌ LOCATION API ERROR: $msg");
      }
      throw Exception("Network error: $msg");
    } catch (e) {
      if (kDebugMode) {
        print("❌ LOCATION UNKNOWN ERROR: $e");
      }
      throw Exception("Unexpected error: $e");
    }
  }
}
