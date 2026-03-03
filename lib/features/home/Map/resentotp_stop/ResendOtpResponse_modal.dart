class ResendOtpResponse {
  final bool success;
  final String message;
  final ResendOtpData data;

  ResendOtpResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ResendOtpResponse.fromJson(Map<String, dynamic> json) {
    return ResendOtpResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ResendOtpData.fromJson(json['data'] ?? {}),
    );
  }
}

class ResendOtpData {
  final int stopId;
  final String stopType;
  final int sequenceNumber;

  ResendOtpData({
    required this.stopId,
    required this.stopType,
    required this.sequenceNumber,
  });

  factory ResendOtpData.fromJson(Map<String, dynamic> json) {
    return ResendOtpData(
      stopId: json['stop_id'] ?? 0,
      stopType: json['stop_type'] ?? '',
      sequenceNumber: json['sequence_number'] ?? 0,
    );
  }
}