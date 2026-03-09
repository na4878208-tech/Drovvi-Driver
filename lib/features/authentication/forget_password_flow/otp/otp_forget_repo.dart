import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/api_url.dart';
import '../../../../constants/dio.dart';
import '../resend_rest_otp/resend_rest_otp_modal.dart';
import 'otp_forget_modal.dart';

final otpVerifyRepositoryProvider = Provider<OtpVerifyRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return OtpVerifyRepository(dio);
});

class OtpVerifyRepository {
  final Dio dio;

  OtpVerifyRepository(this.dio);

  /// VERIFY OTP
  Future<VerifyOtpModel> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final url = ApiUrls.baseurl + ApiUrls.otpforgotPassword;

    try {
      final response = await dio.post(url, data: {"email": email, "otp": otp});

      print("VERIFY OTP RESPONSE => ${response.data}");

      return VerifyOtpModel.fromJson(response.data);
    } on DioException catch (e) {
      print("VERIFY OTP ERROR => ${e.response?.data}");

      throw Exception(
        e.response?.data?["message"] ?? "OTP verification failed",
      );
    }
  }

  /// RESEND OTP
  Future<ResendOtpModel> resendOtp({required String email}) async {
    final url = ApiUrls.baseurl + ApiUrls.resendotpforgotPassword;

    try {
      final response = await dio.post(url, data: {"email": email});

      print("RESEND OTP RESPONSE => ${response.data}");

      return ResendOtpModel.fromJson(response.data);
    } on DioException catch (e) {
      print("RESEND OTP ERROR => ${e.response?.data}");

      throw Exception(e.response?.data?["message"] ?? "Resend OTP failed");
    }
  }
}
