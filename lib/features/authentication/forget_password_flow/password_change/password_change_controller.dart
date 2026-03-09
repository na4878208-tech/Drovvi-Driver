import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'password_change_modal.dart';
import 'password_change_repo.dart';

class ResetPasswordController
    extends StateNotifier<AsyncValue<ResetPasswordModel?>> {
  final ResetPasswordRepository repository;

  ResetPasswordController(this.repository) : super(const AsyncValue.data(null));

  Future<void> resetPassword({
    required String resetToken,
    required String password,
    required String passwordConfirmation,
  }) async {
    state = const AsyncValue.loading();

    try {
      final result = await repository.resetPassword(
        resetToken: resetToken,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final resetPasswordControllerProvider =
    StateNotifierProvider<
      ResetPasswordController,
      AsyncValue<ResetPasswordModel?>
    >((ref) {
      final repo = ref.watch(resetPasswordRepositoryProvider);
      return ResetPasswordController(repo);
    });
