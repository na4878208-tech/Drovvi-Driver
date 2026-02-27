import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../constants/api_url.dart';
import '../../../../../constants/local_storage.dart';
import 'delivery_button_model.dart';

final confirmDeliveryRepositoryProvider =
    Provider<ConfirmDeliveryRepository>((ref) {
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

  return ConfirmDeliveryRepository(dio);
});

class ConfirmDeliveryRepository {
  final Dio dio;
  ConfirmDeliveryRepository(this.dio);

  Future<ConfirmDeliveryResponse> confirmDelivery({
    required int orderId,
    required String otp,
  }) async {
    final token = await LocalStorage.getToken();
    if (token == null) {
      throw Exception("Token not found. Please login again.");
    }

    print("✅ Sending Delivery OTP: $otp, OrderId: $orderId, Token: $token");

    final response = await dio.post(
      "${ApiUrls.ordersdetails}/$orderId/deliver",
      data: {"otp": otp},
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        validateStatus: (status) => status! < 500,
      ),
    );

    print(
        "📦 Delivery API Response: ${response.statusCode} => ${response.data}");

    if (response.statusCode == 200) {
      return ConfirmDeliveryResponse.fromJson(response.data);
    } else {
      final msg = response.data?['message'] ?? 'Delivery failed';
      throw Exception(msg);
    }
  }
}
