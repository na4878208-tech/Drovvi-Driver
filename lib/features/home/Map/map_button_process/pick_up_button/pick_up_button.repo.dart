import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../constants/api_url.dart';
import '../../../../../constants/local_storage.dart';
import 'pick_up_button.model.dart';

final confirmPickupRepositoryProvider = Provider<ConfirmPickupRepository>((
  ref,
) {
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

  return ConfirmPickupRepository(dio);
});

class ConfirmPickupRepository {
  final Dio dio;
  ConfirmPickupRepository(this.dio);

  Future<ConfirmPickupResponse> confirmPickup({
    required int orderId,
    required String otp,
  }) async {
    final token = await LocalStorage.getToken();
    if (token == null) {
      throw Exception("Token not found. Please login again.");
    }

    // ✅ Log for debugging
    print("✅ Sending OTP: $otp, OrderId: $orderId, Token: $token");

    final response = await dio.post(
      "${ApiUrls.ordersdetails}/$orderId/pickup",
      data: {"otp": otp}, // API expects 4-digit string
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        validateStatus: (status) {
          return status! <
              500; // allow 4xx to return response instead of throwing
        },
      ),
    );

    print("📦 Pickup API Response: ${response.statusCode} => ${response.data}");

    if (response.statusCode == 200) {
      return ConfirmPickupResponse.fromJson(response.data);
    } else {
      // Extract API error message safely
      final msg = response.data?['message'] ?? 'Pickup failed';
      throw Exception(msg);
    }
  }
}
