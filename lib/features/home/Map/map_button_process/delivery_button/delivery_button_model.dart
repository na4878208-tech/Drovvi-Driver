class ConfirmDeliveryResponse {
  final bool success;
  final String message;
  final String? orderNumber;
  final double? earning;
  final String? completedAt;
  final String? driverStatus;

  ConfirmDeliveryResponse({
    required this.success,
    required this.message,
    this.orderNumber,
    this.earning,
    this.completedAt,
    this.driverStatus,
  });

  factory ConfirmDeliveryResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return ConfirmDeliveryResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      orderNumber: data?['order_number'],
      earning: (data?['earning'] != null)
          ? double.tryParse(data['earning'].toString())
          : null,
      completedAt: data?['completed_at'],
      driverStatus: data?['driver_status'],
    );
  }
}
