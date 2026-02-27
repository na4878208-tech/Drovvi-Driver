import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'forget_password_modal.dart';
import 'forget_password_repo.dart';

class ForgotPasswordController extends StateNotifier<AsyncValue<ForgotPasswordModel?>> {
  final ForgotPasswordRepository repository;

  ForgotPasswordController(this.repository) : super(const AsyncValue.data(null));

  Future<void> sendOtp(String email) async {
    state = const AsyncValue.loading();

    try {
      final result = await repository.sendOtp(email: email);
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final forgotPasswordControllerProvider =
    StateNotifierProvider<ForgotPasswordController, AsyncValue<ForgotPasswordModel?>>(
  (ref) {
    final repo = ref.watch(forgotPasswordRepositoryProvider);
    return ForgotPasswordController(repo);
  },
);
