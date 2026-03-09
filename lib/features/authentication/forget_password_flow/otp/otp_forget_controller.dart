import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../resend_rest_otp/resend_rest_otp_modal.dart';
import 'otp_forget_modal.dart';
import 'otp_forget_repo.dart';

class OtpVerifyController extends StateNotifier<AsyncValue<VerifyOtpModel?>> {
  final OtpVerifyRepository repository;

  OtpVerifyController(this.repository) : super(const AsyncValue.data(null));

  /// VERIFY OTP
  Future<void> verifyOtp(String email, String otp) async {
    state = const AsyncValue.loading();

    try {
      final result = await repository.verifyOtp(email: email, otp: otp);

      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// RESEND OTP
  Future<ResendOtpModel?> resendOtp(String email) async {
    try {
      final result = await repository.resendOtp(email: email);

      return result;
    } catch (e) {
      rethrow;
    }
  }
}

final otpVerifyControllerProvider =
    StateNotifierProvider<OtpVerifyController, AsyncValue<VerifyOtpModel?>>((
      ref,
    ) {
      final repo = ref.watch(otpVerifyRepositoryProvider);
      return OtpVerifyController(repo);
    });
