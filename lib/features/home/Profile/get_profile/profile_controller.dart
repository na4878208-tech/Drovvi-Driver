import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:logisticdriverapp/features/home/Profile/get_profile/profile_model.dart';
import 'package:logisticdriverapp/features/home/Profile/get_profile/profile_repository.dart';

final profileControllerProvider =
    StateNotifierProvider<ProfileController, AsyncValue<ProfileResponse>>(
      (ref) => ProfileController(ref),
    );

class ProfileController extends StateNotifier<AsyncValue<ProfileResponse>> {
  final Ref ref;

  ProfileController(this.ref) : super(const AsyncLoading()) {
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      state = const AsyncLoading();
      final repo = ref.read(profileRepositoryProvider);
      final response = await repo.getProfile();
      state = AsyncData(response);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh() async {
    await fetchProfile();
  }
}
