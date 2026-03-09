import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'forget_password_modal.dart';
import 'forget_password_repo.dart';

class ForgotPasswordController
    extends StateNotifier<AsyncValue<ForgotPasswordModel?>> {

  final ForgotPasswordRepository repository;

  ForgotPasswordController(this.repository)
      : super(const AsyncData(null));

  Future<void> sendOtp(String email) async {
    state = const AsyncLoading();

    try {
      final result = await repository.sendOtp(email: email);

      /// ✅ PRINT MODEL DATA
      print("OTP SENT TO => ${result.data?.email}");
      print("DEMO OTP => ${result.data?.demoOtp}");

      state = AsyncData(result);

    } catch (e, st) {
      print("Forgot Password Controller Error => $e");
      state = AsyncError(e, st);
    }
  }
}

final forgotPasswordControllerProvider =
    StateNotifierProvider<ForgotPasswordController,
        AsyncValue<ForgotPasswordModel?>>((ref) {

  final repo = ref.watch(forgotPasswordRepositoryProvider);

  return ForgotPasswordController(repo);
});