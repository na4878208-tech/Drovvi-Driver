import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logisticdriverapp/constants/dio.dart';
import 'package:logisticdriverapp/constants/local_storage.dart';
import 'edit_profile_modal.dart';
import '../../../../constants/api_url.dart';

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
    XFile? image,
  }) async {
    final url = "${ApiUrls.baseurl}${ApiUrls.getprofile}";
    final token = await LocalStorage.getToken() ?? "";

    Response response;

    if (image != null) {
      // Multipart for image upload
      FormData formData = FormData.fromMap({
        "name": name,
        "phone": phone,
        "emergency_contact_name": emergencyName,
        "emergency_contact_phone": emergencyPhone,
        "current_latitude": latitude,
        "current_longitude": longitude,
        "image": await MultipartFile.fromFile(image.path, filename: image.name),
      });

      response = await dio.put(
        url,
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
            "Content-Type": "multipart/form-data",
          },
        ),
      );
    } else {
      // JSON body for normal update
      response = await dio.put(
        url,
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
            "Content-Type": "application/json",
          },
        ),
      );
    }

    print("UPDATE PROFILE RESPONSE:");
    print(response.data);

    return UpdateProfileResponse.fromJson(response.data);
  }
}

final updateProfileRepositoryProvider = Provider<UpdateProfileRepository>((
  ref,
) {
  return UpdateProfileRepository(dio: ref.watch(dioProvider), ref: ref);
});
