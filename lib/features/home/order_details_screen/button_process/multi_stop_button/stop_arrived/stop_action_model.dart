// class StopActionResponse {
//   final bool success;
//   final String message;
//   final StopData? data;

//   StopActionResponse({required this.success, required this.message, this.data});

//   factory StopActionResponse.fromJson(Map<String, dynamic> json) {
//     return StopActionResponse(
//       success: json['success'] ?? false,
//       message: json['message'] ?? '',
//       data: json['data'] != null ? StopData.fromJson(json['data']) : null,
//     );
//   }
// }

// class StopData {
//   final int stopId;
//   final String stopType;
//   final int sequenceNumber;
//   final String status;
//   final String? arrivalTime;
//   final String? departureTime;
//   final String? orderStatus;
//   final bool? isOrderCompleted;
//   final bool? requiresOtp; // ✅ ADD THIS

//   StopData({
//     required this.stopId,
//     required this.stopType,
//     required this.sequenceNumber,
//     required this.status,
//     this.arrivalTime,
//     this.departureTime,
//     this.orderStatus,
//     this.isOrderCompleted,
//     this.requiresOtp, // ✅ ADD
//   });

//   factory StopData.fromJson(Map<String, dynamic> json) {
//     return StopData(
//       stopId: json['stop_id'],
//       stopType: json['stop_type'],
//       sequenceNumber: json['sequence_number'],
//       status: json['status'],
//       arrivalTime: json['arrival_time'],
//       departureTime: json['departure_time'],
//       orderStatus: json['order_status'],
//       isOrderCompleted: json['is_order_completed'],
//       requiresOtp: json['requires_otp'], // ✅ ADD
//     );
//   }
// }
class StopActionResponse {
  final bool success;
  final String message;
  final StopData? data;

  StopActionResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory StopActionResponse.fromJson(Map<String, dynamic> json) {
    return StopActionResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data:
          json['data'] != null ? StopData.fromJson(json['data']) : null,
    );
  }
}

class StopData {
  final int stopId;
  final String stopType;
  final int sequenceNumber;
  final String status;
  final String? arrivalTime;
  final String? departureTime;
  final String? orderStatus;
  final bool? isOrderCompleted;

  StopData({
    required this.stopId,
    required this.stopType,
    required this.sequenceNumber,
    required this.status,
    this.arrivalTime,
    this.departureTime,
    this.orderStatus,
    this.isOrderCompleted,
  });

  factory StopData.fromJson(Map<String, dynamic> json) {
    return StopData(
      stopId: json['stop_id'],
      stopType: json['stop_type'],
      sequenceNumber: json['sequence_number'],
      status: json['status'],
      arrivalTime: json['arrival_time'],
      departureTime: json['departure_time'],
      orderStatus: json['order_status'],
      isOrderCompleted: json['is_order_completed'],
    );
  }

}
