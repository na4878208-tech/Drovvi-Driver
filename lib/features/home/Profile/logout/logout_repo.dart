import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticdriverapp/constants/dio.dart';
import 'package:logisticdriverapp/constants/local_storage.dart';

final logoutRepositoryProvider = Provider<LogoutRepository>((ref) {
  final dio = ref.read(dioProvider);
  return LogoutRepository(dio);
});

class LogoutRepository {
  final Dio _dio;

  LogoutRepository(this._dio);

  Future<String> logout() async {
    try {
      final response = await _dio.post("/driver/auth/logout");

      if (response.data["success"] == true) {
        // ✅ Clear token after successful logout
        await LocalStorage.clearToken();
        return response.data["message"] ?? "Logged out successfully";
      } else {
        throw Exception(response.data["message"] ?? "Logout failed");
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?["message"] ?? "Logout API failed",
      );
    }
  }
}