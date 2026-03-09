class ResetPasswordModel {
  final bool success;
  final String message;

  ResetPasswordData? data;

  ResetPasswordModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory ResetPasswordModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? ResetPasswordData.fromJson(json['data']) : null,
    );
  }
}

class ResetPasswordData {
  final String? email; // optional
  ResetPasswordData({this.email});

  factory ResetPasswordData.fromJson(Map<String, dynamic> json) {
    return ResetPasswordData(
      email: json['email'],
    );
  }
}