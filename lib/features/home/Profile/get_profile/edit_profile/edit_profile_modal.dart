class UpdateProfileResponse {
  final bool success;
  final String message;
  final UpdateProfileData data;

  UpdateProfileResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponse(
      success: json["success"],
      message: json["message"],
      data: UpdateProfileData.fromJson(json["data"]),
    );
  }
}

class UpdateProfileData {
  final UpdateUser user;
  final UpdateDriver driver;

  UpdateProfileData({
    required this.user,
    required this.driver,
  });

  factory UpdateProfileData.fromJson(Map<String, dynamic> json) {
    return UpdateProfileData(
      user: UpdateUser.fromJson(json["user"]),
      driver: UpdateDriver.fromJson(json["driver"]),
    );
  }
}

class UpdateUser {
  final int id;
  final String name;
  final String email;
  final String phone;

  UpdateUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory UpdateUser.fromJson(Map<String, dynamic> json) {
    return UpdateUser(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      phone: json["phone"],
    );
  }
}

class UpdateDriver {
  final String emergencyContactName;
  final String emergencyContactPhone;
  final String currentLatitude;
  final String currentLongitude;

  UpdateDriver({
    required this.emergencyContactName,
    required this.emergencyContactPhone,
    required this.currentLatitude,
    required this.currentLongitude,
  });

  factory UpdateDriver.fromJson(Map<String, dynamic> json) {
    return UpdateDriver(
      emergencyContactName: json["emergency_contact_name"],
      emergencyContactPhone: json["emergency_contact_phone"],
      currentLatitude: json["current_latitude"],
      currentLongitude: json["current_longitude"],
    );
  }
}