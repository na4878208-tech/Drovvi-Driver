import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/api_url.dart';
import '../../../../constants/dio.dart';
import '../../../../constants/local_storage.dart';
import '../../Settings/Change_password_flow/Change_password_modal.dart';

final changePasswordRepositoryProvider = Provider<ChangePasswordRepository>((
  ref,
) {
  final dio = ref.watch(dioProvider);
  return ChangePasswordRepository(dio: dio);
});

class ChangePasswordRepository {
  final Dio dio;

  ChangePasswordRepository({required this.dio});

  Future<ChangePasswordModel> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final url = ApiUrls.baseurl + ApiUrls.profilechangePassword;

    try {
      final token = await LocalStorage.getToken();

final response = await dio.post(
  url,
  data: {
    "current_password": currentPassword,
    "new_password": newPassword,
    "new_password_confirmation": confirmPassword,
  },
  options: Options(
    headers: {
      "Authorization": "Bearer $token", // 🔑 token add
    },
  ),
);

      /// ✅ FULL API RESPONSE PRINT
      print("========== CHANGE PASSWORD API ==========");
      print(response.data);
      print("=========================================");

      final model = ChangePasswordModel.fromJson(response.data);

      if (model.success) {
        return model;
      } else {
        throw Exception(model.message);
      }
    } on DioException catch (e) {
      print("Change Password Error => ${e.response?.data}");

      throw Exception(e.response?.data?["message"] ?? "Change password failed");
    }
  }
}
