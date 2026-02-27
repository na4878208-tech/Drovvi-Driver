

double parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

// ------------------- Earning Model -------------------
class EarningModel {
  final int id;
  final int orderId;
  final String orderNumber;
  final double baseAmount;
  final double commissionAmount;
  final double bonusAmount;
  final double deductionAmount;
  final double fuelAllowance;
  final double totalEarnings;
  final String status;
  final DateTime earnedAt;
  final DateTime? paidAt;

  EarningModel({
    required this.id,
    required this.orderId,
    required this.orderNumber,
    required this.baseAmount,
    required this.commissionAmount,
    required this.bonusAmount,
    required this.deductionAmount,
    required this.fuelAllowance,
    required this.totalEarnings,
    required this.status,
    required this.earnedAt,
    this.paidAt,
  });

  factory EarningModel.fromJson(Map<String, dynamic> json) {
    return EarningModel(
      id: json['id'] ?? 0,
      orderId: json['order_id'] ?? 0,
      orderNumber: json['order_number'] ?? '',
      baseAmount: parseDouble(json['base_amount']),
      commissionAmount: parseDouble(json['commission_amount']),
      bonusAmount: parseDouble(json['bonus_amount']),
      deductionAmount: parseDouble(json['deduction_amount']),
      fuelAllowance: parseDouble(json['fuel_allowance']),
      totalEarnings: parseDouble(json['total_earnings']),
      status: json['status'] ?? '',
      earnedAt: DateTime.parse(json['earned_at']),
      paidAt: json['paid_at'] != null ? DateTime.tryParse(json['paid_at']) : null,
    );
  }
}

// ------------------- Summary Model -------------------
class EarningSummary {
  final String period;
  final DateTime fromDate;
  final DateTime toDate;
  final int totalTrips;
  final double baseEarnings;
  final double commissionEarnings;
  final double bonuses;
  final double deductions;
  final double fuelAllowance;
  final double totalEarnings;
  final double paidAmount;
  final double pendingAmount;

  EarningSummary({
    required this.period,
    required this.fromDate,
    required this.toDate,
    required this.totalTrips,
    required this.baseEarnings,
    required this.commissionEarnings,
    required this.bonuses,
    required this.deductions,
    required this.fuelAllowance,
    required this.totalEarnings,
    required this.paidAmount,
    required this.pendingAmount,
  });

  factory EarningSummary.fromJson(Map<String, dynamic> json) {
    return EarningSummary(
      period: json['period'] ?? '',
      fromDate: DateTime.parse(json['from_date']),
      toDate: DateTime.parse(json['to_date']),
      totalTrips: json['total_trips'] ?? 0,
      baseEarnings: parseDouble(json['base_earnings']),
      commissionEarnings: parseDouble(json['commission_earnings']),
      bonuses: parseDouble(json['bonuses']),
      deductions: parseDouble(json['deductions']),
      fuelAllowance: parseDouble(json['fuel_allowance']),
      totalEarnings: parseDouble(json['total_earnings']),
      paidAmount: parseDouble(json['paid_amount']),
      pendingAmount: parseDouble(json['pending_amount']),
    );
  }
}
