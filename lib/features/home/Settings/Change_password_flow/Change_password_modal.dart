class ChangePasswordModel {
  final bool success;
  final String message;
  final Map<String, dynamic>? errors;

  ChangePasswordModel({
    required this.success,
    required this.message,
    this.errors,
  });

  factory ChangePasswordModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      errors: json["errors"],
    );
  }
}