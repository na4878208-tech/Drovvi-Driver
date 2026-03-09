class ProfileResponse {
  final bool success;
  final ProfileData data;

  ProfileResponse({required this.success, required this.data});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      success: json["success"] ?? false,
      data: ProfileData.fromJson(json["data"] ?? {}),
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
      user: User.fromJson(json["user"] ?? {}),
      driver: Driver.fromJson(json["driver"] ?? {}),
      vehicle: Vehicle.fromJson(json["vehicle"] ?? {}),
      earnings: Earnings.fromJson(json["earnings"] ?? {}),
      bankAccount: json["bank_account"] != null
          ? BankAccount.fromJson(json["bank_account"])
          : null,
      stats: Stats.fromJson(json["stats"] ?? {}),
      alerts: Alerts.fromJson(json["alerts"] ?? {}),
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
      id: json["id"] ?? 0,
      name: json["name"]?.toString() ?? "",
      email: json["email"]?.toString() ?? "",
      phone: json["phone"]?.toString() ?? "",
      role: json["role"]?.toString() ?? "",
      status: json["status"]?.toString() ?? "",
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
  final double? currentLatitude; // <- fixed
  final double? currentLongitude; // <- fixed
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
    this.currentLatitude,
    this.currentLongitude,
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
      id: json["id"] ?? 0,
      licenseNumber: json["license_number"]?.toString() ?? "",
      licenseType: json["license_type"]?.toString(),
      licenseCategory: json["license_category"]?.toString() ?? "",
      licenseExpiry: json["license_expiry"]?.toString() ?? "",
      licenseExpiringSoon: json["license_expiring_soon"] ?? false,
      prdpNumber: json["prdp_number"]?.toString() ?? "",
      prdpExpiry: json["prdp_expiry"]?.toString() ?? "",
      prdpExpiringSoon: json["prdp_expiring_soon"] ?? false,
      dateOfBirth: json["date_of_birth"]?.toString() ?? "",
      age: json["age"] ?? 0,
      emergencyContactName: json["emergency_contact_name"]?.toString() ?? "",
      emergencyContactPhone: json["emergency_contact_phone"]?.toString() ?? "",
      status: json["status"]?.toString() ?? "",
      approvalStatus: json["approval_status"]?.toString() ?? "",
      isApproved: json["is_approved"] ?? false,
      isOnline: json["is_online"] ?? false,
      canAcceptOrders: json["can_accept_orders"] ?? false,
      driverRating: (json["driver_rating"] as num?)?.toDouble() ?? 0,
      totalRatings: json["total_ratings"] ?? 0,
      totalTrips: json["total_trips"] ?? 0,
      completedTrips: json["completed_trips"] ?? 0,
      cancelledTrips: json["cancelled_trips"] ?? 0,
      onTimePercentage: json["on_time_percentage"] ?? 0,
      currentLatitude: double.tryParse(
        json["current_latitude"]?.toString() ?? "",
      ),
      currentLongitude: double.tryParse(
        json["current_longitude"]?.toString() ?? "",
      ),
      hasAllDocuments: json["has_all_documents"] ?? false,
      missingDocuments: json["missing_documents"] is Map
          ? (json["missing_documents"] as Map).values
                .map((e) => e.toString())
                .toList()
          : List<String>.from(json["missing_documents"] ?? []),
      documentsVerified: json["documents_verified"] ?? false,
      company: Company.fromJson(json["company"] ?? {}),
      depot: Depot.fromJson(json["depot"] ?? {}),
    );
  }
}

class Company {
  final int id;
  final String name;
  final String type;

  Company({required this.id, required this.name, required this.type});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json["id"] ?? 0,
      name: json["name"]?.toString() ?? "",
      type: json["type"]?.toString() ?? "",
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
      id: json["id"] ?? 0,
      name: json["name"]?.toString() ?? "",
      address: json["address"]?.toString() ?? "",
      city: json["city"]?.toString() ?? "",
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
      id: json["id"] ?? 0,
      registrationNumber: json["registration_number"]?.toString() ?? "",
      make: json["make"]?.toString() ?? "",
      model: json["model"]?.toString() ?? "",
      year: json["year"] ?? 0,
      vehicleType: json["vehicle_type"]?.toString() ?? "",
      color: json["color"]?.toString() ?? "",
      maxWeightTons: json["max_weight_tons"]?.toString() ?? "",
      status: json["status"]?.toString() ?? "",
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
      totalEarnings: (json["total_earnings"] as num?)?.toDouble() ?? 0,
      pendingEarnings: (json["pending_earnings"] as num?)?.toDouble() ?? 0,
      approvedEarnings: (json["approved_earnings"] as num?)?.toDouble() ?? 0,
      paidEarnings: (json["paid_earnings"] as num?)?.toDouble() ?? 0,
      thisMonthEarnings: (json["this_month_earnings"] as num?)?.toDouble() ?? 0,
      averagePerDelivery:
          (json["average_per_delivery"] as num?)?.toDouble() ?? 0,
      currency: json["currency"]?.toString() ?? "",
    );
  }
}

class BankAccount {
  final String bankName;
  final String accountNumber;

  BankAccount({required this.bankName, required this.accountNumber});

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      bankName: json["bank_name"]?.toString() ?? "",
      accountNumber: json["account_number"]?.toString() ?? "",
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
      totalTrips: json["total_trips"] ?? 0,
      completedTrips: json["completed_trips"] ?? 0,
      cancelledTrips: json["cancelled_trips"] ?? 0,
      rating: (json["rating"] as num?)?.toDouble() ?? 0,
      totalRatings: json["total_ratings"] ?? 0,
      onTimePercentage: json["on_time_percentage"] ?? 0,
      monthsActive: (json["months_active"] as num?)?.toDouble() ?? 0,
      daysSinceRegistration:
          (json["days_since_registration"] as num?)?.toDouble() ?? 0,
      completionRate: (json["completion_rate"] as num?)?.toDouble() ?? 0,
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
      licenseExpiringSoon: json["license_expiring_soon"] ?? false,
      prdpExpiringSoon: json["prdp_expiring_soon"] ?? false,
      missingDocuments: json["missing_documents"] ?? false,
      notApproved: json["not_approved"] ?? false,
      cannotAcceptOrders: json["cannot_accept_orders"] ?? false,
    );
  }
}
