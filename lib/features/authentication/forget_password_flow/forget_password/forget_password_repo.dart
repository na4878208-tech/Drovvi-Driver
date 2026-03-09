import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/api_url.dart';
import '../../../../constants/dio.dart';
import 'forget_password_modal.dart';

final forgotPasswordRepositoryProvider =
    Provider<ForgotPasswordRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ForgotPasswordRepository(dio: dio);
});

class ForgotPasswordRepository {
  final Dio dio;

  ForgotPasswordRepository({required this.dio});

  Future<ForgotPasswordModel> sendOtp({required String email}) async {
    final url = ApiUrls.baseurl + ApiUrls.forgotPassword;

    try {
      final response = await dio.post(
        url,
        data: {"email": email},
      );

      /// ✅ FULL API RESPONSE PRINT
      print("========== FORGOT PASSWORD API ==========");
      print(response.data);
      print("=========================================");

      final model = ForgotPasswordModel.fromJson(response.data);

      if (model.success) {
        return model;
      } else {
        throw Exception(model.message);
      }
    } on DioException catch (e) {
      print("Forgot Password Error => ${e.response?.data}");

      throw Exception(
        e.response?.data?["message"] ?? "Forgot password failed",
      );
    }
  }
}