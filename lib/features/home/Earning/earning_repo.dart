import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/api_url.dart';
import '../../../../constants/local_storage.dart';
import 'earning_model.dart';

final earningRepositoryProvider = Provider<EarningRepository>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiUrls.baseurl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );
  return EarningRepository(dio: dio);
});

class EarningRepository {
  final Dio dio;
  EarningRepository({required this.dio});

  /// Fetch earnings with period and page-based pagination
  Future<List<EarningModel>> getEarnings({
    String period = "week",
    int page = 1,
    int perPage = 10,
  }) async {
    final token = await LocalStorage.getToken();
    final response = await dio.get(
      ApiUrls.earnings,
      queryParameters: {"period": period, "page": page, "per_page": perPage},
      options: Options(
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
      ),
    );

    if (response.statusCode == 200) {
      // FIX: Parse correct data array from API response
      final data = response.data['data']['data'] as List<dynamic>? ?? [];
      return data.map((e) => EarningModel.fromJson(e)).toList();
    } else {
      throw Exception(response.data['message'] ?? 'Failed to fetch earnings');
    }
  }

  /// Fetch summary with period
  Future<EarningSummary> getEarningsSummary({String period = "week"}) async {
    final token = await LocalStorage.getToken();
    final response = await dio.get(
      ApiUrls.earningsSummary,
      queryParameters: {"period": period},
      options: Options(
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
      ),
    );

    if (response.statusCode == 200) {
      final data =
          response.data['data']['summary'] as Map<String, dynamic>? ?? {};
      return EarningSummary.fromJson(data);
    } else {
      throw Exception(
        response.data['message'] ?? 'Failed to fetch earnings summary',
      );
    }
  }
}
