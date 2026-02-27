class DriverLocationResponse {
  final bool success;
  final String message;

  DriverLocationResponse({
    required this.success,
    required this.message,
  });

  factory DriverLocationResponse.fromJson(Map<String, dynamic> json) {
    return DriverLocationResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
