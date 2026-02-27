import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../constants/api_url.dart';
import '../../../../../../constants/local_storage.dart';
import 'stop_action_model.dart';

final stopActionRepositoryProvider = Provider<StopActionRepository>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiUrls.baseurl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: true,
    ),
  );

  return StopActionRepository(dio);
});

class StopActionRepository {
  final Dio dio;
  StopActionRepository(this.dio);

  /// 🚩 ARRIVED API
  Future<StopActionResponse> arrivedStop({
    required int orderId,
    required int stopId,
  }) async {
    final token = await LocalStorage.getToken();
    if (token == null) throw Exception("Token not found");

    final response = await dio.post(
      "${ApiUrls.ordersdetails}/$orderId/stops/arrived",
      data: {"stop_id": stopId},
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        validateStatus: (status) => status! < 500,
      ),
    );

    print("🚏 STOP ARRIVED RESPONSE => ${response.data}");

    if (response.statusCode == 200) {
      return StopActionResponse.fromJson(response.data);
    } else {
      throw Exception(response.data['message'] ?? "Arrived failed");
    }
  }

  /// ✅ COMPLETE API (OTP Optional)
  Future<StopActionResponse> completeStop({
    required int orderId,
    required int stopId,
    String? otp, // 🔥 Added
  }) async {
    final token = await LocalStorage.getToken();
    if (token == null) throw Exception("Token not found");

    // 👇 Only include OTP if provided
    final Map<String, dynamic> body = {"stop_id": stopId};

    if (otp != null && otp.isNotEmpty) {
      body["otp"] = otp;
    }

    final response = await dio.post(
      "${ApiUrls.ordersdetails}/$orderId/stops/complete",
      data: body,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        validateStatus: (status) => status! < 500,
      ),
    );

    print("✅ STOP COMPLETE RESPONSE => ${response.data}");

    if (response.statusCode == 200) {
      return StopActionResponse.fromJson(response.data);
    } else {
      throw Exception(response.data['message'] ?? "Complete failed");
    }
  }
}
