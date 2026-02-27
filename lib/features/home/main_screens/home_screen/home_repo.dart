// lib/repositories/dashboard_repository.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticdriverapp/constants/local_storage.dart';
import '../../../../constants/api_url.dart';
import '../../../../constants/dio.dart';
import 'home_modal.dart';

/// Repository Provider
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return DashboardRepository(dio: dio);
});

class DashboardRepository {
  final Dio dio;

  DashboardRepository({required this.dio});

  /// ===============================
  /// FETCH DASHBOARD DATA
  /// ===============================
  Future<DashboardModel> fetchDashboard() async {
    try {
      final token = await LocalStorage.getToken();

      final response = await dio.get(
        ApiUrls.dashboard,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            if (token != null && token.isNotEmpty)
              "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("===== DRIVER DASHBOARD RESPONSE =====");
          print(response.data);
          print("====================================");
        }

        return DashboardModel.fromJson(response.data);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load dashboard');
      }
    } on DioError catch (e) {
      final msg = e.response?.data['message'] ?? e.message;
      throw Exception("Network error: $msg");
    }
  }

  /// ===============================
  /// UPDATE DRIVER AVAILABILITY
  /// ===============================
  Future<Map<String, dynamic>> updateAvailability(bool isOnline) async {
    try {
      final token = await LocalStorage.getToken();

      final response = await dio.put(
        ApiUrls.available,
        data: {"status": isOnline ? "available" : "off_duty"},
        options: Options(
          headers: {
            "Content-Type": "application/json",
            if (token != null && token.isNotEmpty)
              "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200) {
        return {
          "status": response.data['data']?['status'],
          "canReceiveOrders":
              response.data['data']?['can_receive_orders'] ?? false,
          "message": response.data['message'] ?? '',
        };
      } else {
        throw Exception(response.data['message'] ?? 'Failed to update status');
      }
    } on DioError catch (e) {
      final msg = e.response?.data['message'] ?? e.message;
      throw Exception(msg);
    }
  }
}
