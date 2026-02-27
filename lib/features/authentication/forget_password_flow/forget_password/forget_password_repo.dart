import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/api_url.dart';
import '../../../../constants/dio.dart';
import 'forget_password_modal.dart';

final forgotPasswordRepositoryProvider = Provider<ForgotPasswordRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ForgotPasswordRepository(dio: dio);
});

class ForgotPasswordRepository {
  final Dio dio;

  ForgotPasswordRepository({required this.dio});

  Future<ForgotPasswordModel> sendOtp({required String email}) async {
    final url = ApiUrls.baseurl + ApiUrls.forgotPassword;

    try {
      final response = await dio.post(url, data: {"email": email});
      print("ForgotPassword Response => ${response.data}");

      if (response.statusCode == 200) {
        return ForgotPasswordModel.fromJson(response.data);
      } else {
        throw Exception(response.data["message"] ?? "Request failed");
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? "Forgot password request failed");
    }
  }
}
