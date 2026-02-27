class SkipStopData {
  final int requestId;
  final int stopId;
  final String status;
  final String reason;
  final String? adminNotes;
  final String? requestedAt;
  final String? reviewedAt;
  final String? reviewedBy;

  SkipStopData({
    required this.requestId,
    required this.stopId,
    required this.status,
    required this.reason,
    this.adminNotes,
    this.requestedAt,
    this.reviewedAt,
    this.reviewedBy,
  });

  factory SkipStopData.fromJson(Map<String, dynamic> json) {
    return SkipStopData(
      requestId: json['request_id'] != null ? int.tryParse(json['request_id'].toString()) ?? 0 : 0,
      stopId: json['stop_id'] != null ? int.tryParse(json['stop_id'].toString()) ?? 0 : 0,
      status: json['status']?.toString() ?? 'pending',
      reason: json['reason']?.toString() ?? '',
      adminNotes: json['admin_notes']?.toString(),
      requestedAt: json['requested_at']?.toString(),
      reviewedAt: json['reviewed_at']?.toString(),
      reviewedBy: json['reviewed_by']?.toString(),
    );
  }
}

class SkipStopResponse {
  final bool success;
  final String message;
  final SkipStopData? data;

  SkipStopResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory SkipStopResponse.fromJson(Map<String, dynamic> json) {
    return SkipStopResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null
          ? SkipStopData.fromJson(json['data'])
          : null,
    );
  }
}
