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

  Future<List<EarningModel>> getEarnings() async {
    final token = await LocalStorage.getToken();
    final response = await dio.get(
      ApiUrls.earnings,
      options: Options(
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data['data']['data'] as List<dynamic>? ?? [];
      return data.map((e) => EarningModel.fromJson(e)).toList();
    } else {
      throw Exception(response.data['message'] ?? 'Failed to fetch earnings');
    }
  }

  Future<EarningSummary> getEarningsSummary() async {
    final token = await LocalStorage.getToken();
    final response = await dio.get(
      ApiUrls.earningsSummary,
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
