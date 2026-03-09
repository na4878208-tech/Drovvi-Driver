class AppValidators {
  // ---------------- EMAIL ----------------
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required";
    }

    final emailRegex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[A-Za-z]{2,}$",
    );

    if (!emailRegex.hasMatch(value)) {
      return "Enter a valid Email ID";
    }
    return null;
  }

  // ---------------- PASSWORD ----------------
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }

    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }

    return null;
  }

  // ---------------- STRONG PASSWORD ----------------
  static String? newPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "New password is required";
    }

    if (value.length < 8) {
      return "Minimum 8 characters required";
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Must contain at least one uppercase letter";
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return "Must contain at least one lowercase letter";
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Must contain at least one number";
    }

    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return "Must contain at least one special character";
    }

    return null;
  }

  // ---------------- CONFIRM PASSWORD ----------------
  static String? confirmPassword(String? value, String newPassword) {
    if (value == null || value.isEmpty) {
      return "Confirm your password";
    }

    if (value != newPassword) {
      return "Passwords do not match";
    }

    return null;
  }

  // ---------------- OTP ----------------
  static String? otp(String? value) {
    if (value == null || value.isEmpty) {
      return "OTP is required";
    }

    if (value.length != 6) {
      return "Enter 6-digit OTP";
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return "OTP must be numeric";
    }

    return null;
  }

  // ---------------- NAME ----------------
  static String? name(String? value, {String fieldName = "Name"}) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName is required";
    }

    if (!RegExp(r'^[A-Za-z ]+$').hasMatch(value)) {
      return "$fieldName must contain only letters";
    }

    if (value.length < 2) {
      return "$fieldName is too short";
    }

    return null;
  }

  // ---------------- PHONE ----------------
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Mobile number is required";
    }

    if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
      return "Enter valid mobile number";
    }

    return null;
  }

  // ---------------- DATE (MM-DD-YYYY) ----------------
  static String? dob(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Date is required";
    }

    final dobRegex = RegExp(r'^\d{2}-\d{2}-\d{4}$');
    if (!dobRegex.hasMatch(value)) {
      return "Enter date in MM-DD-YYYY format";
    }

    try {
      final parts = value.split("-");
      final month = int.parse(parts[0]);
      final day = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      final date = DateTime(year, month, day);

      if (date.month != month || date.day != day) {
        return "Invalid date";
      }
    } catch (e) {
      return "Invalid date";
    }

    return null;
  }

  // ---------------- FUTURE DATE (EXPIRY) ----------------
  static String? expiryDate(String? value, {String field = "Expiry Date"}) {
    if (value == null || value.trim().isEmpty) {
      return "$field is required";
    }

    final regex = RegExp(r'^\d{2}-\d{2}-\d{4}$');
    if (!regex.hasMatch(value)) {
      return "Enter date in MM-DD-YYYY format";
    }

    try {
      final parts = value.split("-");
      final month = int.parse(parts[0]);
      final day = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      final date = DateTime(year, month, day);

      if (date.month != month || date.day != day) {
        return "Invalid date";
      }

      if (date.isBefore(DateTime.now())) {
        return "$field must be a future date";
      }
    } catch (e) {
      return "Invalid date";
    }

    return null;
  }

  // ---------------- LICENSE NUMBER ----------------
  static String? licenseNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "License number is required";
    }

    if (value.length < 5) {
      return "License number is too short";
    }

    return null;
  }

  // ---------------- PRDP NUMBER ----------------
  static String? prdpNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "PrDP number is required";
    }

    if (value.length < 5) {
      return "Invalid PrDP number";
    }

    return null;
  }

  // ---------------- DROPDOWN / SELECTION ----------------
  static String? selection(String? value, {String field = "Selection"}) {
    if (value == null || value.isEmpty) {
      return "$field is required";
    }
    return null;
  }

  // ---------------- REQUIRED GENERIC ----------------
  static String? required(String? value, {String field = "Field"}) {
    if (value == null || value.trim().isEmpty) {
      return "$field is required";
    }
    return null;
  }

  // ---------------- NUMERIC ONLY ----------------
  static String? numeric(String? value, {String field = "Value"}) {
    if (value == null || value.trim().isEmpty) {
      return "$field is required";
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return "$field must be numeric";
    }

    return null;
  }
}
