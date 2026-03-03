class ProfileResponse {
  final bool success;
  final ProfileData data;

  ProfileResponse({
    required this.success,
    required this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      success: json['success'],
      data: ProfileData.fromJson(json['data']),
    );
  }
}

class ProfileData {
  final User user;
  final Driver driver;
  final Vehicle vehicle;
  final Stats stats;

  ProfileData({
    required this.user,
    required this.driver,
    required this.vehicle,
    required this.stats,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      user: User.fromJson(json['user']),
      driver: Driver.fromJson(json['driver']),
      vehicle: Vehicle.fromJson(json['vehicle']),
      stats: Stats.fromJson(json['stats']),
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

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      status: json['status'],
    );
  }
}

class Driver {
  final int id;
  final String licenseNumber;
  final String? licenseType;
  final String licenseExpiry;
  final String dateOfBirth;
  final String? address;
  final String? city;
  final String? state;
  final String status;
  final String rating;
  final int totalTrips;
  final Company company;

  Driver({
    required this.id,
    required this.licenseNumber,
    this.licenseType,
    required this.licenseExpiry,
    required this.dateOfBirth,
    this.address,
    this.city,
    this.state,
    required this.status,
    required this.rating,
    required this.totalTrips,
    required this.company,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      licenseNumber: json['license_number'],
      licenseType: json['license_type'],
      licenseExpiry: json['license_expiry'],
      dateOfBirth: json['date_of_birth'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      status: json['status'],
      rating: json['rating'],
      totalTrips: json['total_trips'],
      company: Company.fromJson(json['company']),
    );
  }
}

class Company {
  final int id;
  final String name;

  Company({
    required this.id,
    required this.name,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Vehicle {
  final int id;
  final String registrationNumber;
  final String make;
  final String model;
  final String type;
  final String color;

  Vehicle({
    required this.id,
    required this.registrationNumber,
    required this.make,
    required this.model,
    required this.type,
    required this.color,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      registrationNumber: json['registration_number'],
      make: json['make'],
      model: json['model'],
      type: json['type'],
      color: json['color'],
    );
  }
}

class Stats {
  final int totalTrips;
  final String rating;
  final double monthsActive;

  Stats({
    required this.totalTrips,
    required this.rating,
    required this.monthsActive,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      totalTrips: json['total_trips'],
      rating: json['rating'],
      monthsActive: (json['months_active'] as num).toDouble(),
    );
  }
}