class ConfirmPickupResponse {
  final bool success;
  final String message;
  final String? deliveryOtp;

  ConfirmPickupResponse({
    required this.success,
    required this.message,
    this.deliveryOtp,
  });

  factory ConfirmPickupResponse.fromJson(Map<String, dynamic> json) {
    return ConfirmPickupResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      deliveryOtp: json['data']?['delivery_otp'],
    );
  }
}
