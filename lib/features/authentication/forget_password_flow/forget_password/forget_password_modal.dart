class ForgotPasswordModel {
  final bool success;
  final String message;

  ForgotPasswordModel({required this.success, required this.message});

  factory ForgotPasswordModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
    );
  }
}
