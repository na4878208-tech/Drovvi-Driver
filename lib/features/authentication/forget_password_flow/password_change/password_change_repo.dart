import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/api_url.dart';
import '../../../../constants/dio.dart';
import 'password_change_modal.dart';

final resetPasswordRepositoryProvider = Provider<ResetPasswordRepository>((
  ref,
) {
  final dio = ref.watch(dioProvider);
  return ResetPasswordRepository(dio: dio);
});

class ResetPasswordRepository {
  final Dio dio;
  ResetPasswordRepository({required this.dio});

  Future<ResetPasswordModel> resetPassword({
    required String resetToken,
    required String password,
    required String passwordConfirmation,
  }) async {
    final url = ApiUrls.baseurl + ApiUrls.changePassword;

    try {
      final response = await dio.post(
        url,
        data: {
          "reset_token": resetToken,
          "password": password,
          "password_confirmation": passwordConfirmation,
        },
      );

      print("ResetPassword Response => ${response.data}");

      if (response.statusCode == 200) {
        return ResetPasswordModel.fromJson(response.data);
      } else {
        throw Exception(response.data['message'] ?? 'Reset password failed');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Reset password request failed',
      );
    }
  }
}
