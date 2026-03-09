class ResendOtpModel {
  final bool success;
  final String message;
  final ResendOtpData? data;

  ResendOtpModel({required this.success, required this.message, this.data});

  factory ResendOtpModel.fromJson(Map<String, dynamic> json) {
    return ResendOtpModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] != null ? ResendOtpData.fromJson(json["data"]) : null,
    );
  }
}

class ResendOtpData {
  final String email;
  final int otpExpiresIn;
  final int demoOtp;

  ResendOtpData({
    required this.email,
    required this.otpExpiresIn,
    required this.demoOtp,
  });

  factory ResendOtpData.fromJson(Map<String, dynamic> json) {
    return ResendOtpData(
      email: json["email"] ?? "",
      otpExpiresIn: json["otp_expires_in"] ?? 0,
      demoOtp: json["demo_otp"] ?? 0,
    );
  }
}
