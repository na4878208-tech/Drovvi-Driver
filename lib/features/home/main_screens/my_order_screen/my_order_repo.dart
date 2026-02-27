import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/api_url.dart';
import '../../../../constants/local_storage.dart';
import 'my_order_modal.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiUrls.baseurl, // 👈 VERY IMPORTANT
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  return OrderRepository(dio: dio);
});

class OrderRepository {
  final Dio dio;

  OrderRepository({required this.dio});

  Future<List<OrderModel>> getMyOrders() async {
    final token = await LocalStorage.getToken();
    final response = await dio.get(
      ApiUrls.myorders,
      options: Options(
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data['data'] as List;
      return data.map((e) => OrderModel.fromJson(e)).toList();
    } else {
      throw Exception(response.data['message'] ?? 'Failed to fetch my orders');
    }
  }
}
