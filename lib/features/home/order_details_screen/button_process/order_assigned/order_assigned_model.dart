class StartOrderResponse {
  final bool success;
  final String message;
  final String pickupOtp;

  StartOrderResponse({
    required this.success,
    required this.message,
    required this.pickupOtp,
  });

  factory StartOrderResponse.fromJson(Map<String, dynamic> json) {
    return StartOrderResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      pickupOtp: json['data']?['pickup_otp'] ?? '',
    );
  }
}
