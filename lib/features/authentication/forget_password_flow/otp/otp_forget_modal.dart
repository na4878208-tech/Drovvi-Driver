class VerifyOtpModel {
  final bool success;
  final String message;
  final VerifyOtpData? data;

  VerifyOtpModel({required this.success, required this.message, this.data});

  factory VerifyOtpModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] != null ? VerifyOtpData.fromJson(json["data"]) : null,
    );
  }
}

class VerifyOtpData {
  final String email;
  final String resetToken;
  final int tokenExpiresIn;

  VerifyOtpData({
    required this.email,
    required this.resetToken,
    required this.tokenExpiresIn,
  });

  factory VerifyOtpData.fromJson(Map<String, dynamic> json) {
    return VerifyOtpData(
      email: json["email"] ?? "",
      resetToken: json["reset_token"] ?? "",
      tokenExpiresIn: json["token_expires_in"] ?? 0,
    );
  }
}
