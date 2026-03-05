class ProfileResponse {
  final bool success;
  final ProfileData data;

  ProfileResponse({
    required this.success,
    required this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      success: json["success"] ?? false,
      data: ProfileData.fromJson(json["data"]),
    );
  }
}

class ProfileData {
  final User user;
  final Driver driver;
  final Vehicle vehicle;
  final Earnings earnings;
  final BankAccount? bankAccount;
  final Stats stats;
  final Alerts alerts;

  ProfileData({
    required this.user,
    required this.driver,
    required this.vehicle,
    required this.earnings,
    this.bankAccount,
    required this.stats,
    required this.alerts,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      user: User.fromJson(json["user"]),
      driver: Driver.fromJson(json["driver"]),
      vehicle: Vehicle.fromJson(json["vehicle"]),
      earnings: Earnings.fromJson(json["earnings"]),
      bankAccount: json["bank_account"] != null
          ? BankAccount.fromJson(json["bank_account"])
          : null,
      stats: Stats.fromJson(json["stats"]),
      alerts: Alerts.fromJson(json["alerts"]),
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String status;
  final bool emailVerified;
  final bool phoneVerified;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.status,
    required this.emailVerified,
    required this.phoneVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      phone: json["phone"],
      role: json["role"],
      status: json["status"],
      emailVerified: json["email_verified"] ?? false,
      phoneVerified: json["phone_verified"] ?? false,
    );
  }
}

class Driver {
  final int id;
  final String licenseNumber;
  final String? licenseType;
  final String licenseCategory;
  final String licenseExpiry;
  final bool licenseExpiringSoon;
  final String prdpNumber;
  final String prdpExpiry;
  final bool prdpExpiringSoon;
  final String dateOfBirth;
  final int age;
  final String emergencyContactName;
  final String emergencyContactPhone;
  final String status;
  final String approvalStatus;
  final bool isApproved;
  final bool isOnline;
  final bool canAcceptOrders;
  final double driverRating;
  final int totalRatings;
  final int totalTrips;
  final int completedTrips;
  final int cancelledTrips;
  final int onTimePercentage;
  final bool hasAllDocuments;
  final List<String> missingDocuments;
  final bool documentsVerified;
  final Company company;
  final Depot depot;

  Driver({
    required this.id,
    required this.licenseNumber,
    this.licenseType,
    required this.licenseCategory,
    required this.licenseExpiry,
    required this.licenseExpiringSoon,
    required this.prdpNumber,
    required this.prdpExpiry,
    required this.prdpExpiringSoon,
    required this.dateOfBirth,
    required this.age,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
    required this.status,
    required this.approvalStatus,
    required this.isApproved,
    required this.isOnline,
    required this.canAcceptOrders,
    required this.driverRating,
    required this.totalRatings,
    required this.totalTrips,
    required this.completedTrips,
    required this.cancelledTrips,
    required this.onTimePercentage,
    required this.hasAllDocuments,
    required this.missingDocuments,
    required this.documentsVerified,
    required this.company,
    required this.depot,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json["id"],
      licenseNumber: json["license_number"],
      licenseType: json["license_type"],
      licenseCategory: json["license_category"],
      licenseExpiry: json["license_expiry"],
      licenseExpiringSoon: json["license_expiring_soon"] ?? false,
      prdpNumber: json["prdp_number"],
      prdpExpiry: json["prdp_expiry"],
      prdpExpiringSoon: json["prdp_expiring_soon"] ?? false,
      dateOfBirth: json["date_of_birth"],
      age: json["age"],
      emergencyContactName: json["emergency_contact_name"],
      emergencyContactPhone: json["emergency_contact_phone"],
      status: json["status"],
      approvalStatus: json["approval_status"],
      isApproved: json["is_approved"],
      isOnline: json["is_online"],
      canAcceptOrders: json["can_accept_orders"],
      driverRating: (json["driver_rating"] as num).toDouble(),
      totalRatings: json["total_ratings"],
      totalTrips: json["total_trips"],
      completedTrips: json["completed_trips"],
      cancelledTrips: json["cancelled_trips"],
      onTimePercentage: json["on_time_percentage"],
      hasAllDocuments: json["has_all_documents"],
      missingDocuments: List<String>.from(json["missing_documents"] ?? []),
      documentsVerified: json["documents_verified"],
      company: Company.fromJson(json["company"]),
      depot: Depot.fromJson(json["depot"]),
    );
  }
}

class Company {
  final int id;
  final String name;
  final String type;

  Company({
    required this.id,
    required this.name,
    required this.type,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json["id"],
      name: json["name"],
      type: json["type"],
    );
  }
}

class Depot {
  final int id;
  final String name;
  final String address;
  final String city;

  Depot({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
  });

  factory Depot.fromJson(Map<String, dynamic> json) {
    return Depot(
      id: json["id"],
      name: json["name"],
      address: json["address"],
      city: json["city"],
    );
  }
}

class Vehicle {
  final int id;
  final String registrationNumber;
  final String make;
  final String model;
  final int year;
  final String vehicleType;
  final String color;
  final String maxWeightTons;
  final String status;

  Vehicle({
    required this.id,
    required this.registrationNumber,
    required this.make,
    required this.model,
    required this.year,
    required this.vehicleType,
    required this.color,
    required this.maxWeightTons,
    required this.status,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json["id"],
      registrationNumber: json["registration_number"],
      make: json["make"],
      model: json["model"],
      year: json["year"],
      vehicleType: json["vehicle_type"],
      color: json["color"],
      maxWeightTons: json["max_weight_tons"],
      status: json["status"],
    );
  }
}

class Earnings {
  final double totalEarnings;
  final double pendingEarnings;
  final double approvedEarnings;
  final double paidEarnings;
  final double thisMonthEarnings;
  final double averagePerDelivery;
  final String currency;

  Earnings({
    required this.totalEarnings,
    required this.pendingEarnings,
    required this.approvedEarnings,
    required this.paidEarnings,
    required this.thisMonthEarnings,
    required this.averagePerDelivery,
    required this.currency,
  });

  factory Earnings.fromJson(Map<String, dynamic> json) {
    return Earnings(
      totalEarnings: (json["total_earnings"] as num).toDouble(),
      pendingEarnings: (json["pending_earnings"] as num).toDouble(),
      approvedEarnings: (json["approved_earnings"] as num).toDouble(),
      paidEarnings: (json["paid_earnings"] as num).toDouble(),
      thisMonthEarnings: (json["this_month_earnings"] as num).toDouble(),
      averagePerDelivery: (json["average_per_delivery"] as num).toDouble(),
      currency: json["currency"],
    );
  }
}

class BankAccount {
  final String bankName;
  final String accountNumber;

  BankAccount({
    required this.bankName,
    required this.accountNumber,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      bankName: json["bank_name"],
      accountNumber: json["account_number"],
    );
  }
}

class Stats {
  final int totalTrips;
  final int completedTrips;
  final int cancelledTrips;
  final double rating;
  final int totalRatings;
  final int onTimePercentage;
  final double monthsActive;
  final double daysSinceRegistration;
  final double completionRate;

  Stats({
    required this.totalTrips,
    required this.completedTrips,
    required this.cancelledTrips,
    required this.rating,
    required this.totalRatings,
    required this.onTimePercentage,
    required this.monthsActive,
    required this.daysSinceRegistration,
    required this.completionRate,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      totalTrips: json["total_trips"],
      completedTrips: json["completed_trips"],
      cancelledTrips: json["cancelled_trips"],
      rating: (json["rating"] as num).toDouble(),
      totalRatings: json["total_ratings"],
      onTimePercentage: json["on_time_percentage"],
      monthsActive: (json["months_active"] as num).toDouble(),
      daysSinceRegistration: (json["days_since_registration"] as num).toDouble(),
      completionRate: (json["completion_rate"] as num).toDouble(),
    );
  }
}

class Alerts {
  final bool licenseExpiringSoon;
  final bool prdpExpiringSoon;
  final bool missingDocuments;
  final bool notApproved;
  final bool cannotAcceptOrders;

  Alerts({
    required this.licenseExpiringSoon,
    required this.prdpExpiringSoon,
    required this.missingDocuments,
    required this.notApproved,
    required this.cannotAcceptOrders,
  });

  factory Alerts.fromJson(Map<String, dynamic> json) {
    return Alerts(
      licenseExpiringSoon: json["license_expiring_soon"],
      prdpExpiringSoon: json["prdp_expiring_soon"],
      missingDocuments: json["missing_documents"],
      notApproved: json["not_approved"],
      cannotAcceptOrders: json["cannot_accept_orders"],
    );
  }
}