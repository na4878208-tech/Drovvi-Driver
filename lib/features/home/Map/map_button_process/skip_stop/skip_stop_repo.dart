import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../constants/api_url.dart';
import '../../../../../constants/local_storage.dart';
import 'skip_stop_model.dart';

final skipStopRepositoryProvider = Provider<SkipStopRepository>((ref) {
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

  return SkipStopRepository(dio: dio);
});

class SkipStopRepository {
  final Dio dio;

  SkipStopRepository({required this.dio});

  /// 🔹 REQUEST SKIP
  Future<SkipStopResponse> requestSkip({
    required int orderId,
    required int stopId,
    required String reason,
  }) async {
    final token = await LocalStorage.getToken();

    final response = await dio.post(
      "${ApiUrls.ordersdetails}/$orderId/stops/request-skip",
      data: {"stop_id": stopId, "reason": reason},
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
    );

    debugPrint("SKIP STOP REQUEST RESPONSE => ${response.data}");

    if (response.statusCode == 200) {
      return SkipStopResponse.fromJson(response.data);
    } else {
      throw Exception(response.data['message'] ?? "Skip request failed");
    }
  }

  /// 🔹 GET SKIP STATUS
  Future<SkipStopResponse> getSkipStatus({
    required int orderId,
    required int stopId,
  }) async {
    final token = await LocalStorage.getToken();

    try {
      final response = await dio.get(
        "${ApiUrls.ordersdetails}/$orderId/stops/$stopId/skip-status",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          validateStatus: (status) {
            // Accept 200 and 404 so we can handle 404 gracefully
            return status == 200 || status == 404;
          },
        ),
      );

      debugPrint("SKIP STATUS RESPONSE => ${response.data}");

      if (response.statusCode == 200) {
        return SkipStopResponse.fromJson(response.data);
      } else if (response.statusCode == 404) {
        // No skip request exists yet
        return SkipStopResponse(
          success: false,
          message: "No skip request found for this stop",
          data: null,
        );
      } else {
        throw Exception(
          response.data['message'] ?? "Failed to load skip status",
        );
      }
    } on DioException catch (e) {
      debugPrint(
        "DioException: ${e.response?.statusCode} | ${e.response?.data}",
      );
      throw Exception(
        "Failed to fetch skip status: ${e.response?.statusCode} ${e.response?.data}",
      );
    }
  }
}
