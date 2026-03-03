import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:logisticdriverapp/constants/local_storage.dart';
import 'package:logisticdriverapp/features/home/Map/resentotp_stop/ResendOtpResponse_modal.dart';

final orderStopRepositoryProvider =
    Provider<OrderrepositoryStop>((ref) {
  final dio = Dio(); // fresh Dio since full URL use kar rahe ho
  return OrderrepositoryStop(dio);
});

class OrderrepositoryStop {
  final Dio _dio;

  OrderrepositoryStop(this._dio);

  Future<ResendOtpResponse> resendOtp({
    required int orderId,
    required int stopId,
  }) async {
    try {
      final token = await LocalStorage.getToken();

      if (token == null || token.isEmpty) {
        throw Exception("Token not found. Please login again.");
      }

      final response = await _dio.post(
        'https://drovvi.com/api/v1/driver/orders/$orderId/stops/resend-otp',
        data: {
          "stop_id": stopId,
        },
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      return ResendOtpResponse.fromJson(response.data);
    } on DioException catch (e) {
      print("STATUS CODE: ${e.response?.statusCode}");
      print("ERROR DATA: ${e.response?.data}");
      print("REQUEST URI: ${e.requestOptions.uri}");
      rethrow;
    }
  }
}