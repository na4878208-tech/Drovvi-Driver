abstract class ApiUrls {
  //Base Url
  static String baseurl = "https://drovvi.com/api/v1";

  //Login
  static String login = "/driver/auth/login";

  //get
  static String getprofile = "/driver/auth/profile";

  //forget password
  static String forgotPassword = "/driver/auth/forgot-password";

  //profile change password
  static String profilechangePassword = "/driver/auth/change-password";

  //otp forget password
  static String otpforgotPassword = "/driver/auth/verify-reset-otp";

  //resend otp forget password
  static String resendotpforgotPassword = "/driver/auth/resend-reset-otp";

  //change password
  static String changePassword = "/driver/auth/reset-password";

  //Dashboard
  static String dashboard = "/driver/dashboard";

  // Available status
  static String available = "/driver/availability";


  // my orders
  static String myorders = "/driver/orders/my-orders";

  // order details
  static String ordersdetails = "/driver/orders";

  // Current Location
  static const updateDriverLocation = "/driver/location";

  //Earning history
  static const earnings = "/driver/earnings";

  static const earningsSummary = "/driver/earnings/summary";


  static const logout = "/driver/auth/logout";
}
