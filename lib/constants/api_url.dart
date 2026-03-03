abstract class ApiUrls {
  //Base Url
  static String baseurl = "https://drovvi.com/api/v1";

  //Login
  static String login = "/driver/auth/login";

  //forget password
  static String forgotPassword = "/driver/auth/forgot-password";

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
