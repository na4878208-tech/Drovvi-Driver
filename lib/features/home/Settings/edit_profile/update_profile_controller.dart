import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
import 'update_profile_repository.dart';
import 'edit_profile_modal.dart';

final updateProfileControllerProvider =
    StateNotifierProvider<
      UpdateProfileController,
      AsyncValue<UpdateProfileResponse?>
    >((ref) {
      return UpdateProfileController(ref);
    });

class UpdateProfileController
    extends StateNotifier<AsyncValue<UpdateProfileResponse?>> {
  final Ref ref;

  UpdateProfileController(this.ref) : super(const AsyncData(null));

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String emergencyName,
    required String emergencyPhone,
    required String latitude,
    required String longitude,
    XFile? image,
  }) async {
    state = const AsyncLoading();

    try {
      final repo = ref.read(updateProfileRepositoryProvider);

      final response = await repo.updateProfile(
        name: name,
        phone: phone,
        emergencyName: emergencyName,
        emergencyPhone: emergencyPhone,
        latitude: latitude,
        longitude: longitude,
        image: image,
      );

      print("PROFILE UPDATED SUCCESSFULLY");
      print(response.message);

      state = AsyncData(response);
    } catch (e, st) {
      print("PROFILE UPDATE ERROR");
      print(e);
      state = AsyncError(e, st);
    }
  }
}
