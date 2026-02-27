// // ------------------------------
// // SAFE NUM PARSER
// // ------------------------------
// num parseNum(dynamic value) {
//   if (value == null) return 0;
//   if (value is num) return value;
//   if (value is String) return num.tryParse(value) ?? 0;
//   return 0;
// }

// // ------------------------------
// // DASHBOARD MODEL
// // ------------------------------
// class DashboardModel {
//   final DriverInfo driverInfo;
//   final Stats stats;
//   final Order? activeOrder;
//   final List<Order> availableOrders;
//   final List<RecentOrder> recentOrders;

//   DashboardModel({
//     required this.driverInfo,
//     required this.stats,
//     required this.activeOrder,
//     required this.availableOrders,
//     required this.recentOrders,
//   });

//   factory DashboardModel.fromJson(Map<String, dynamic> json) {
//     final data = json['data'] ?? {};
//     return DashboardModel(
//       driverInfo: DriverInfo.fromJson(data['driver_info'] ?? {}),
//       stats: Stats.fromJson(data['stats'] ?? {}),
//       activeOrder: data['active_order'] != null
//           ? Order.fromJson(data['active_order'])
//           : null,
//       availableOrders: (data['available_orders'] as List<dynamic>? ?? [])
//           .map((e) => Order.fromJson(e))
//           .toList(),
//       recentOrders: (data['recent_orders'] as List<dynamic>? ?? [])
//           .map((e) => RecentOrder.fromJson(e))
//           .toList(),
//     );
//   }

//   // copyWith to update status
//   DashboardModel copyWithStatus(String newStatus) {
//     return DashboardModel(
//       driverInfo: driverInfo.copyWith(status: newStatus),
//       stats: stats,
//       activeOrder: activeOrder,
//       availableOrders: availableOrders,
//       recentOrders: recentOrders,
//     );
//   }
// }

// // ------------------------------
// // DRIVER INFO
// // ------------------------------
// class DriverInfo {
//   final int id;
//   final String name;
//   final String phone;
//   final String email;
//   final String licenseNumber;
//   final String prdpNumber;
//   final double rating;
//   final String status;
//   final int totalTrips;
//   final Company? company;
//   final Depot? depot;
//   final Vehicle? vehicle;

//   DriverInfo({
//     required this.id,
//     required this.name,
//     required this.phone,
//     required this.email,
//     required this.licenseNumber,
//     required this.prdpNumber,
//     required this.rating,
//     required this.status,
//     required this.totalTrips,
//     this.company,
//     this.depot,
//     this.vehicle,
//   });

//   factory DriverInfo.fromJson(Map<String, dynamic> json) {
//     return DriverInfo(
//       id: json['id'] ?? 0,
//       name: json['name'] ?? '',
//       phone: json['phone'] ?? '',
//       email: json['email'] ?? '',
//       licenseNumber: json['license_number'] ?? '',
//       prdpNumber: json['prdp_number'] ?? '',
//       rating: parseNum(json['rating']).toDouble(),
//       status: json['status'] ?? '',
//       totalTrips: json['total_trips'] ?? 0,
//       company: json['company'] != null
//           ? Company.fromJson(json['company'])
//           : null,
//       depot: json['depot'] != null ? Depot.fromJson(json['depot']) : null,
//       vehicle: json['vehicle'] != null
//           ? Vehicle.fromJson(json['vehicle'])
//           : null,
//     );
//   }

//   DriverInfo copyWith({String? status}) {
//     return DriverInfo(
//       id: id,
//       name: name,
//       phone: phone,
//       email: email,
//       licenseNumber: licenseNumber,
//       prdpNumber: prdpNumber,
//       rating: rating,
//       status: status ?? this.status,
//       totalTrips: totalTrips,
//       company: company,
//       depot: depot,
//       vehicle: vehicle,
//     );
//   }
// }

// // ------------------------------
// // VEHICLE
// // ------------------------------
// class Vehicle {
//   final String registrationNumber;
//   final String vehicleType;

//   Vehicle({required this.registrationNumber, required this.vehicleType});

//   factory Vehicle.fromJson(Map<String, dynamic> json) {
//     return Vehicle(
//       registrationNumber: json['registration_number'] ?? '',
//       vehicleType: json['vehicle_type'] ?? '',
//     );
//   }
// }

// // ------------------------------
// // STATS MAIN
// // ------------------------------
// class Stats {
//   final StatsSection today;
//   final StatsSection week;
//   final TotalStats total;

//   Stats({required this.today, required this.week, required this.total});

//   factory Stats.fromJson(Map<String, dynamic> json) {
//     return Stats(
//       today: StatsSection.fromJson(json['today'] ?? {}),
//       week: StatsSection.fromJson(json['week'] ?? {}),
//       total: TotalStats.fromJson(json['total'] ?? {}),
//     );
//   }
// }

// // ------------------------------
// // EACH STATS SECTION
// // ------------------------------
// class StatsSection {
//   final num earnings;
//   final int? orders;

//   StatsSection({required this.earnings, this.orders});

//   factory StatsSection.fromJson(Map<String, dynamic> json) {
//     return StatsSection(
//       earnings: parseNum(json['earnings']),
//       orders: json['orders'] != null
//           ? int.tryParse(json['orders'].toString())
//           : null,
//     );
//   }
// }

// // ------------------------------
// // Company
// // ------------------------------
// class Company {
//   final int id;
//   final String name;
//   final String phone;
//   final String email;
//   final String type;

//   Company({
//     required this.id,
//     required this.name,
//     required this.phone,
//     required this.email,
//     required this.type,
//   });

//   factory Company.fromJson(Map<String, dynamic> json) {
//     return Company(
//       id: json['id'] ?? 0,
//       name: (json['name'] ?? '').toString(),
//       phone: (json['phone'] ?? '').toString(),
//       email: (json['email'] ?? '').toString(),
//       type: (json['type'] ?? '').toString(),
//     );
//   }

//   bool get isEmpty => name.isEmpty && phone.isEmpty && email.isEmpty;
// }

// // ------------------------------
// // Deport
// // ------------------------------
// class Depot {
//   final int id;
//   final String name;
//   final String code;
//   final String address;
//   final String city;
//   final double latitude;
//   final double longitude;

//   Depot({
//     required this.id,
//     required this.name,
//     required this.code,
//     required this.address,
//     required this.city,
//     required this.latitude,
//     required this.longitude,
//   });

//   factory Depot.fromJson(Map<String, dynamic> json) {
//     return Depot(
//       id: json['id'] ?? 0,
//       name: json['name'] ?? '',
//       code: json['code'] ?? '',
//       address: json['address'] ?? '',
//       city: json['city'] ?? '',
//       latitude: parseNum(json['latitude']).toDouble(),
//       longitude: parseNum(json['longitude']).toDouble(),
//     );
//   }
//   bool get isEmpty => name.isEmpty && address.isEmpty && city.isEmpty;
// }

// // ------------------------------
// // Multiple Stop
// // ------------------------------
// class OrderStop {
//   final int id;
//   final String stopType;
//   final int sequence;
//   final String address;
//   final String city;
//   final String status;
//   final String? arrivalTime;
//   final String? departureTime;

//   OrderStop({
//     required this.id,
//     required this.stopType,
//     required this.sequence,
//     required this.address,
//     required this.city,
//     required this.status,
//     this.arrivalTime,
//     this.departureTime,
//   });

//   factory OrderStop.fromJson(Map<String, dynamic> json) {
//     return OrderStop(
//       id: json['id'] ?? 0,
//       stopType: json['stop_type'] ?? '',
//       sequence: json['sequence_number'] ?? 0,
//       address: json['address'] ?? '',
//       city: json['city'] ?? '',
//       status: json['status'] ?? '',
//       arrivalTime: json['arrival_time'],
//       departureTime: json['departure_time'],
//     );
//   }
// }

// // ------------------------------
// // TOTAL STATS
// // ------------------------------
// class TotalStats {
//   final int completedOrders;
//   final String rating;

//   TotalStats({required this.completedOrders, required this.rating});

//   factory TotalStats.fromJson(Map<String, dynamic> json) {
//     return TotalStats(
//       completedOrders: json['completed_orders'] ?? 0,
//       rating: json['rating']?.toString() ?? '0',
//     );
//   }
// }

// // ------------------------------
// // ORDER MODEL
// // ------------------------------
// class Order {
//   final int id;
//   final String orderNumber;
//   final String status;
//   final String paymentStatus;
//   final bool isMultiStop;
//   final int stopsCount;
//   final List<OrderStop> stops;
//   final String customerName;
//   final String customerPhone;
//   final num finalCost;
//   final num estimatedEarning;
//   final num distanceKm;

//   Order({
//     required this.id,
//     required this.orderNumber,
//     required this.status,
//     required this.paymentStatus,
//     required this.isMultiStop,
//     required this.stopsCount,
//     required this.stops,
//     required this.customerName,
//     required this.customerPhone,
//     required this.finalCost,
//     required this.estimatedEarning,
//     required this.distanceKm,
//   });

//   factory Order.fromJson(Map<String, dynamic> json) {
//     return Order(
//       id: json['id'] ?? 0,
//       orderNumber: json['order_number'] ?? '',
//       status: json['status'] ?? '',
//       paymentStatus: json['payment_status'] ?? '',
//       isMultiStop: json['is_multi_stop'] == 1 || json['is_multi_stop'] == true,
//       stopsCount: json['stops_count'] ?? 0,
//       stops: (json['stops'] as List<dynamic>? ?? [])
//           .map((e) => OrderStop.fromJson(e))
//           .toList(),

//       customerName: json['customer_name'] ?? 'Customer',
//       customerPhone: json['customer_phone'] ?? '-',
//       finalCost: parseNum(json['final_cost']),
//       estimatedEarning: parseNum(json['estimated_earning']),
//       distanceKm: parseNum(json['distance_km']),
//     );
//   }
// }

// // ------------------------------
// // RECENT ORDER
// // ------------------------------
// class RecentOrder {
//   final int id;
//   final String orderNumber;
//   final String deliveryAddress;
//   final String? completedAt;
//   final num? earning;

//   RecentOrder({
//     required this.id,
//     required this.orderNumber,
//     required this.deliveryAddress,
//     this.completedAt,
//     this.earning,
//   });

//   factory RecentOrder.fromJson(Map<String, dynamic> json) {
//     return RecentOrder(
//       id: json['id'] ?? 0,
//       orderNumber: json['order_number'] ?? '',
//       deliveryAddress: json['delivery_address'] ?? '',
//       completedAt: json['completed_at']?.toString(),
//       earning: parseNum(json['earning']),
//     );
//   }
// }

// ------------------------------
// SAFE NUM PARSER
// ------------------------------
num parseNum(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value;
  if (value is String) return num.tryParse(value) ?? 0;
  return 0;
}

// ------------------------------
// DASHBOARD MODEL
// ------------------------------
class DashboardModel {
  final DriverInfo driverInfo;
  final Stats stats;
  final Order? activeOrder;
  final List<Order> pendingOrders;
  final List<RecentOrder> recentOrders;

  DashboardModel({
    required this.driverInfo,
    required this.stats,
    required this.activeOrder,
    required this.pendingOrders,
    required this.recentOrders,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    return DashboardModel(
      driverInfo: DriverInfo.fromJson(data['driver_info'] ?? {}),
      stats: Stats.fromJson(data['stats'] ?? {}),
      activeOrder: data['active_order'] != null
          ? Order.fromJson(data['active_order'])
          : null,
      pendingOrders: (data['pending_orders'] as List<dynamic>? ?? [])
          .map((e) => Order.fromJson(e))
          .toList(),
      recentOrders: (data['recent_orders'] as List<dynamic>? ?? [])
          .map((e) => RecentOrder.fromJson(e))
          .toList(),
    );
  }

  DashboardModel copyWith({
  DriverInfo? driverInfo,
  Stats? stats,
  Order? activeOrder,
  List<Order>? pendingOrders,
  List<RecentOrder>? recentOrders,
}) {
  return DashboardModel(
    driverInfo: driverInfo ?? this.driverInfo,
    stats: stats ?? this.stats,
    activeOrder: activeOrder ?? this.activeOrder,
    pendingOrders: pendingOrders ?? this.pendingOrders,
    recentOrders: recentOrders ?? this.recentOrders,
  );
}
}

////////////////////////////////////////////////////////////////
//////////////////// DRIVER INFO ///////////////////////////////
////////////////////////////////////////////////////////////////

class DriverInfo {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String licenseNumber;
  final String prdpNumber;
  final String prdpExpiry;
  final String licenseExpiry;
  final double rating;
  final String status;
  final int totalTrips;
  final String approvalStatus;
  final bool canAcceptOrders;
  final Company? company;
  final Depot? depot;
  final Vehicle? vehicle;

  DriverInfo({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.licenseNumber,
    required this.prdpNumber,
    required this.prdpExpiry,
    required this.licenseExpiry,
    required this.rating,
    required this.status,
    required this.totalTrips,
    required this.approvalStatus,
    required this.canAcceptOrders,
    this.company,
    this.depot,
    this.vehicle,
  });

  factory DriverInfo.fromJson(Map<String, dynamic> json) {
    return DriverInfo(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      licenseNumber: json['license_number'] ?? '',
      prdpNumber: json['prdp_number'] ?? '',
      prdpExpiry: json['prdp_expiry'] ?? '',
      licenseExpiry: json['license_expiry'] ?? '',
      rating: parseNum(json['rating']).toDouble(),
      status: json['status'] ?? '',
      totalTrips: json['total_trips'] ?? 0,
      approvalStatus: json['approval_status'] ?? '',
      canAcceptOrders: json['can_accept_orders'] ?? false,
      company:
          json['company'] != null ? Company.fromJson(json['company']) : null,
      depot: json['depot'] != null ? Depot.fromJson(json['depot']) : null,
      vehicle:
          json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null,
    );
  }

DriverInfo copyWith({
  int? id,
  String? name,
  String? phone,
  String? email,
  String? licenseNumber,
  String? prdpNumber,
  String? prdpExpiry,
  String? licenseExpiry,
  double? rating,
  String? status,
  int? totalTrips,
  String? approvalStatus,
  bool? canAcceptOrders,
  Company? company,
  Depot? depot,
  Vehicle? vehicle,
}) {
  return DriverInfo(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    licenseNumber: licenseNumber ?? this.licenseNumber,
    prdpNumber: prdpNumber ?? this.prdpNumber,
    prdpExpiry: prdpExpiry ?? this.prdpExpiry,
    licenseExpiry: licenseExpiry ?? this.licenseExpiry,
    rating: rating ?? this.rating,
    status: status ?? this.status,
    totalTrips: totalTrips ?? this.totalTrips,
    approvalStatus: approvalStatus ?? this.approvalStatus,
    canAcceptOrders: canAcceptOrders ?? this.canAcceptOrders,
    company: company ?? this.company,
    depot: depot ?? this.depot,
    vehicle: vehicle ?? this.vehicle,
  );
}
}

////////////////////////////////////////////////////////////////
//////////////////// COMPANY //////////////////////////////////
////////////////////////////////////////////////////////////////

class Company {
  final int id;
  final String name;
  final String? tradingName;
  final String type;
  final String phone;
  final String email;
  final String? registrationNumber;

  Company({
    required this.id,
    required this.name,
    this.tradingName,
    required this.type,
    required this.phone,
    required this.email,
    this.registrationNumber,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      tradingName: json['trading_name'],
      type: json['type'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      registrationNumber: json['registration_number'],
    );
  }
}

////////////////////////////////////////////////////////////////
//////////////////// DEPOT ////////////////////////////////////
////////////////////////////////////////////////////////////////

class Depot {
  final int id;
  final String name;
  final String code;
  final String address;
  final String city;
  final String state;
  final String contactPerson;
  final String contactPhone;
  final double latitude;
  final double longitude;

  Depot({
    required this.id,
    required this.name,
    required this.code,
    required this.address,
    required this.city,
    required this.state,
    required this.contactPerson,
    required this.contactPhone,
    required this.latitude,
    required this.longitude,
  });

  factory Depot.fromJson(Map<String, dynamic> json) {
    return Depot(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      contactPerson: json['contact_person'] ?? '',
      contactPhone: json['contact_phone'] ?? '',
      latitude: parseNum(json['latitude']).toDouble(),
      longitude: parseNum(json['longitude']).toDouble(),
    );
  }
}

////////////////////////////////////////////////////////////////
//////////////////// VEHICLE //////////////////////////////////
////////////////////////////////////////////////////////////////

class Vehicle {
  final int id;
  final String registrationNumber;
  final String vehicleType;
  final String make;
  final String model;
  final num capacityWeight;
  final num maxWeightTons;

  Vehicle({
    required this.id,
    required this.registrationNumber,
    required this.vehicleType,
    required this.make,
    required this.model,
    required this.capacityWeight,
    required this.maxWeightTons,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] ?? 0,
      registrationNumber: json['registration_number'] ?? '',
      vehicleType: json['vehicle_type'] ?? '',
      make: json['make'] ?? '',
      model: json['model'] ?? '',
      capacityWeight: parseNum(json['capacity_weight']),
      maxWeightTons: parseNum(json['max_weight_tons']),
    );
  }
}

////////////////////////////////////////////////////////////////
//////////////////// STATS ////////////////////////////////////
////////////////////////////////////////////////////////////////

class Stats {
  final StatsSection today;
  final StatsSection week;
  final TotalStats total;

  Stats({
    required this.today,
    required this.week,
    required this.total,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      today: StatsSection.fromJson(json['today'] ?? {}),
      week: StatsSection.fromJson(json['week'] ?? {}),
      total: TotalStats.fromJson(json['total'] ?? {}),
    );
  }
}

class StatsSection {
  final num earnings;
  final int? orders;

  StatsSection({required this.earnings, this.orders});

  factory StatsSection.fromJson(Map<String, dynamic> json) {
    return StatsSection(
      earnings: parseNum(json['earnings']),
      orders:
          json['orders'] != null ? int.tryParse(json['orders'].toString()) : null,
    );
  }
}

class TotalStats {
  final int completedOrders;
  final String rating;

  TotalStats({required this.completedOrders, required this.rating});

  factory TotalStats.fromJson(Map<String, dynamic> json) {
    return TotalStats(
      completedOrders: json['completed_orders'] ?? 0,
      rating: json['rating']?.toString() ?? '0',
    );
  }
}

////////////////////////////////////////////////////////////////
//////////////////// ORDER ////////////////////////////////////
////////////////////////////////////////////////////////////////

class Order {
  final int id;
  final String orderNumber;
  final String trackingCode;
  final String status;
  final String paymentStatus;
  final bool isMultiStop;
  final int stopsCount;
  final List<OrderStop> stops;

  final String customerName;
  final String customerPhone;

  final String pickupAddress;
  final String deliveryAddress;

  final num totalWeight;
  final num finalCost;
  final num estimatedEarning;
  final num distanceKm;

  Order({
    required this.id,
    required this.orderNumber,
    required this.trackingCode,
    required this.status,
    required this.paymentStatus,
    required this.isMultiStop,
    required this.stopsCount,
    required this.stops,
    required this.customerName,
    required this.customerPhone,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.totalWeight,
    required this.finalCost,
    required this.estimatedEarning,
    required this.distanceKm,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? 0,
      orderNumber: json['order_number'] ?? '',
      trackingCode: json['tracking_code'] ?? '',
      status: json['status'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      isMultiStop: json['is_multi_stop'] == true || json['is_multi_stop'] == 1,
      stopsCount: json['stops_count'] ?? 0,
      stops: (json['stops'] as List<dynamic>? ?? [])
          .map((e) => OrderStop.fromJson(e))
          .toList(),
      customerName: json['customer_name'] ?? '',
      customerPhone: json['customer_phone'] ?? '',
      pickupAddress: json['pickup_address'] ?? '',
      deliveryAddress: json['delivery_address'] ?? '',
      totalWeight: parseNum(json['total_weight']),
      finalCost: parseNum(json['final_cost']),
      estimatedEarning: parseNum(json['estimated_earning']),
      distanceKm: parseNum(json['distance_km']),
    );
  }
}

////////////////////////////////////////////////////////////////
//////////////////// ORDER STOP ////////////////////////////////
////////////////////////////////////////////////////////////////

class OrderStop {
  final int id;
  final String stopType;
  final int sequenceNumber;
  final String address;
  final String city;
  final String state;
  final double latitude;
  final double longitude;
  final String status;
  final String? arrivalTime;
  final String? departureTime;

  OrderStop({
    required this.id,
    required this.stopType,
    required this.sequenceNumber,
    required this.address,
    required this.city,
    required this.state,
    required this.latitude,
    required this.longitude,
    required this.status,
    this.arrivalTime,
    this.departureTime,
  });

  factory OrderStop.fromJson(Map<String, dynamic> json) {
    return OrderStop(
      id: json['id'] ?? 0,
      stopType: json['stop_type'] ?? '',
      sequenceNumber: json['sequence_number'] ?? 0,
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      latitude: parseNum(json['latitude']).toDouble(),
      longitude: parseNum(json['longitude']).toDouble(),
      status: json['status'] ?? '',
      arrivalTime: json['arrival_time'],
      departureTime: json['departure_time'],
    );
  }
}

////////////////////////////////////////////////////////////////
//////////////////// RECENT ORDER //////////////////////////////
////////////////////////////////////////////////////////////////

class RecentOrder {
  final int id;
  final String orderNumber;
  final String trackingCode;
  final String deliveryAddress;
  final bool isMultiStop;
  final int stopsCount;
  final String? completedAt;
  final num earning;

  RecentOrder({
    required this.id,
    required this.orderNumber,
    required this.trackingCode,
    required this.deliveryAddress,
    required this.isMultiStop,
    required this.stopsCount,
    this.completedAt,
    required this.earning,
  });

  factory RecentOrder.fromJson(Map<String, dynamic> json) {
    return RecentOrder(
      id: json['id'] ?? 0,
      orderNumber: json['order_number'] ?? '',
      trackingCode: json['tracking_code'] ?? '',
      deliveryAddress: json['delivery_address'] ?? '',
      isMultiStop: json['is_multi_stop'] == 1,
      stopsCount: json['stops_count'] ?? 0,
      completedAt: json['completed_at'],
      earning: parseNum(json['earning']),
    );
  }
}