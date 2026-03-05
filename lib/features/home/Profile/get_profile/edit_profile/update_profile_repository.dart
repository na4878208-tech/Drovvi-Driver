import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticdriverapp/constants/dio.dart';
import 'package:logisticdriverapp/constants/local_storage.dart';
import 'package:logisticdriverapp/features/home/Profile/get_profile/edit_profile/edit_profile_modal.dart';


class UpdateProfileRepository {
  final Dio dio;
  final Ref ref;

  UpdateProfileRepository({required this.dio, required this.ref});

  Future<UpdateProfileResponse> updateProfile({
    required String name,
    required String phone,
    required String emergencyName,
    required String emergencyPhone,
    required String latitude,
    required String longitude,
  }) async {
    try {
      final token = await LocalStorage.getToken() ?? "";

      final response = await dio.put(
        "/driver/auth/profile",
        data: {
          "name": name,
          "phone": phone,
          "emergency_contact_name": emergencyName,
          "emergency_contact_phone": emergencyPhone,
          "current_latitude": latitude,
          "current_longitude": longitude,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        return UpdateProfileResponse.fromJson(response.data);
      } else {
        throw Exception("Profile update failed");
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data?["message"] ?? "Update failed");
    }
  }
}

final updateProfileRepositoryProvider = Provider<UpdateProfileRepository>((ref) {
  return UpdateProfileRepository(
    dio: ref.watch(dioProvider),
    ref: ref,
  );
});