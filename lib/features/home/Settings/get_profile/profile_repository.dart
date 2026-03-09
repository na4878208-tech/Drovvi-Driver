import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticdriverapp/constants/dio.dart';
import 'package:logisticdriverapp/constants/local_storage.dart';
import 'package:logisticdriverapp/features/home/Settings/get_profile/profile_model.dart';

import '../../../../constants/api_url.dart';

class ProfileRepository {
  final Dio dio;
  final Ref ref;

  ProfileRepository({required this.dio, required this.ref});

  Future<ProfileResponse> getProfile() async {
    try {
      final url = ApiUrls.baseurl + ApiUrls.getprofile;;
      final token = await LocalStorage.getToken() ?? "";

      final response = await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      print("Profile API Status: ${response.statusCode}");
      print("Profile API Data: ${response.data}");

      if (response.statusCode == 200) {
        return ProfileResponse.fromJson(response.data);
      } else {
        throw Exception("Failed to load profile");
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
      throw Exception(e.response?.data?["message"] ?? "Profile API failed");
    } catch (e) {
      throw Exception("Profile loading failed");
    }
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(
    dio: ref.watch(dioProvider),
    ref: ref,
  );
});