import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'Change_password_modal.dart';
import 'Change_password_repo.dart';

class ChangePasswordController
    extends StateNotifier<AsyncValue<ChangePasswordModel?>> {

  final ChangePasswordRepository repository;

  ChangePasswordController(this.repository)
      : super(const AsyncData(null));

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {

    state = const AsyncLoading();

    try {
      final result = await repository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      /// ✅ PRINT RESPONSE
      print("CHANGE PASSWORD SUCCESS => ${result.message}");

      state = AsyncData(result);

    } catch (e, st) {

      print("Change Password Controller Error => $e");

      state = AsyncError(e, st);
    }
  }
}

final changePasswordControllerProvider =
    StateNotifierProvider<ChangePasswordController,
        AsyncValue<ChangePasswordModel?>>((ref) {

  final repo = ref.watch(changePasswordRepositoryProvider);

  return ChangePasswordController(repo);
});