// lib/repositories/order_repository.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticdriverapp/constants/local_storage.dart';
import '../../../../constants/api_url.dart';
import '../../../../constants/dio.dart';
import 'button_process/order_assigned/order_assigned_model.dart';
import 'order_detail_modal.dart';

/// Repository Provider
final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final dio = ref.watch(dioProvider); // common Dio instance
  return OrderRepository(dio: dio);
});

class OrderRepository {
  final Dio dio;

  OrderRepository({required this.dio});

  /// ===============================
  /// FETCH ORDER DETAILS BY ID
  /// ===============================
  Future<OrderModel> fetchOrderDetails(int id) async {
    try {
      final token = await LocalStorage.getToken();

      final headers = {
        "Content-Type": "application/json",
        if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
      };

      if (kDebugMode) {
        print("===== FETCH ORDER DETAILS =====");
        print("Order ID: $id");
        print("Token: ${token != null ? 'Present' : 'Not found'}");
      }

      final response = await dio.get(
        "${ApiUrls.ordersdetails}/$id", // `/driver/orders/{id}`
        options: Options(headers: headers),
      );

      if (kDebugMode) {
        print("===== RAW API RESPONSE =====");
        print(response.data);
        print("============================");
      }

      if (response.statusCode == 200) {
        return OrderModel.fromJson(response.data['data']);
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to fetch order details',
        );
      }
    } on DioError catch (e) {
      final msg = e.response?.data['message'] ?? e.message;
      if (kDebugMode) {
        print("API ERROR: $msg");
      }
      throw Exception("Network error: $msg");
    } catch (e) {
      if (kDebugMode) {
        print("Unexpected Error: $e");
      }
      throw Exception("Unexpected error: $e");
    }
  }

  /// ===============================
  /// ACCEPT ORDER
  /// ===============================
  Future<OrderModel> acceptOrder(int orderId) async {
    try {
      final token = await LocalStorage.getToken();

      if (token == null || token.isEmpty) {
        throw Exception("Token not found. Please login again.");
      }

      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      final response = await dio.post(
        "${ApiUrls.ordersdetails}/$orderId/accept",
        options: Options(
          headers: headers,
          validateStatus: (status) => status! < 500, // allow 4xx to return
        ),
      );

      print("ACCEPT ORDER STATUS: ${response.statusCode}");
      print("ACCEPT ORDER RESPONSE: ${response.data}");

      if (response.statusCode == 200 && response.data['success'] == true) {
        return OrderModel.fromJson(response.data['data']);
      } else {
        // Safely extract message
        final msg = response.data?['message'] ?? 'Failed to accept order';
        throw Exception(msg);
      }
    } on DioError catch (e) {
      print("DioError: ${e.response?.data ?? e.message}");
      throw Exception(e.response?.data['message'] ?? e.message);
    } catch (e) {
      print("AcceptOrder Error: $e");
      rethrow;
    }
  }

  /// ===============================
  /// REJECT ORDER
  /// ===============================
  Future<void> rejectOrder(int orderId) async {
    try {
      final token = await LocalStorage.getToken();

      final headers = {
        "Content-Type": "application/json",
        if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
      };

      final response = await dio.post(
        "${ApiUrls.ordersdetails}/$orderId//reject",
        options: Options(headers: headers),
      );

      if (kDebugMode) {
        print("REJECT ORDER RESPONSE => ${response.data}");
      }

      if (response.statusCode != 200 || response.data['success'] != true) {
        throw Exception(response.data['message'] ?? "Failed to reject order");
      }
    } on DioError catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  /// ===============================
  /// START ORDER (ASSIGNED → IN_TRANSIT)
  /// ===============================
  Future<StartOrderResponse> startOrder(int orderId) async {
    try {
      final token = await LocalStorage.getToken();

      final headers = {
        "Content-Type": "application/json",
        if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
      };

      if (kDebugMode) {
        print("===== START ORDER =====");
        print("Order ID: $orderId");
      }

      final response = await dio.post(
        "${ApiUrls.ordersdetails}/$orderId/start",
        options: Options(headers: headers),
      );

      if (kDebugMode) {
        print("===== START ORDER RESPONSE =====");
        print(response.data);
      }

      if (response.statusCode == 200) {
        return StartOrderResponse.fromJson(response.data);
      } else {
        throw Exception(response.data['message'] ?? "Failed to start order");
      }
    } on DioError catch (e) {
      final msg = e.response?.data['message'] ?? e.message;
      throw Exception("Network error: $msg");
    }
  }
}
