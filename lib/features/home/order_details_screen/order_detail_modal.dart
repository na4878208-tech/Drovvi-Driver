// Helper functions
int parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  if (value is double) return value.toInt();
  return 0;
}

double parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

/// ---------------- ORDER MODEL ----------------
class OrderModel {
  final int id;
  final String orderNumber;
  final String trackingCode;
  final String status;
  final String paymentStatus;
  final bool isMultiStop;
  final int stopsCount;
  final List<OrderStop> stops;

  final Customer customer;
  final Pickup pickup;
  final Delivery delivery;

  final List<Item> items;
  final PackageInfo packageInfo;
  final OrderDetails orderDetails;
  final AddOns addOns;
  final Payment payment;
  final List<dynamic> tracking;
  final OrderTimestamps timestamps;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.trackingCode,
    required this.status,
    required this.paymentStatus,
    required this.isMultiStop,
    required this.stopsCount,
    required this.stops,
    required this.customer,
    required this.pickup,
    required this.delivery,
    required this.items,
    required this.packageInfo,
    required this.orderDetails,
    required this.addOns,
    required this.payment,
    required this.tracking,
    required this.timestamps,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: parseInt(json['id']),
      orderNumber: json['order_number'] ?? '',
      trackingCode: json['tracking_code'] ?? '',
      status: json['status'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      isMultiStop:
          (json['is_multi_stop'] == 1 || json['is_multi_stop'] == true),
      stopsCount: parseInt(json['stops_count']),
      stops: (json['stops'] as List<dynamic>? ?? [])
          .map((e) => OrderStop.fromJson(e))
          .toList(),
      customer: Customer.fromJson(json['customer'] ?? {}),
      pickup: Pickup.fromJson(json['pickup'] ?? {}),
      delivery: Delivery.fromJson(json['delivery'] ?? {}),
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => Item.fromJson(e))
          .toList(),
      packageInfo: json['package'] != null
          ? PackageInfo.fromJson(json['package'])
          : PackageInfo.empty(),
      orderDetails: json['order_details'] != null
          ? OrderDetails.fromJson(json['order_details'])
          : OrderDetails.empty(),
      addOns: json['add_ons'] != null
          ? AddOns.fromJson(json['add_ons'])
          : AddOns.empty(),
      payment: json['payment'] != null
          ? Payment.fromJson(json['payment'])
          : Payment.empty(),
      tracking: (json['tracking'] as List<dynamic>? ?? []),
      timestamps: json['timestamps'] != null
          ? OrderTimestamps.fromJson(json['timestamps'])
          : OrderTimestamps.empty(),
    );
  }
}

/// ---------------- ORDER STOP ----------------
class OrderStop {
  final int id;
  final String stopType;
  final int sequenceNumber;
  final String address;
  final String city;
  final String state;
  final String latitude;
  final String longitude;
  final String contactName;
  final String contactPhone;
  final String notes;
  final String status;
  final String? arrivalTime;
  final String? departureTime;
  final bool requiresOtp; // ✅ ADD

  OrderStop({
    required this.id,
    required this.stopType,
    required this.sequenceNumber,
    required this.address,
    required this.city,
    required this.state,
    required this.latitude,
    required this.longitude,
    required this.contactName,
    required this.contactPhone,
    required this.notes,
    required this.status,
    this.arrivalTime,
    this.departureTime,
    this.requiresOtp = false, // ✅ DEFAULT
  });

  factory OrderStop.fromJson(Map<String, dynamic> json) => OrderStop(
    id: parseInt(json['id']),
    stopType: json['stop_type'] ?? '',
    sequenceNumber: parseInt(json['sequence_number']),
    address: json['address'] ?? '',
    city: json['city'] ?? '',
    state: json['state'] ?? '',
    latitude: json['latitude']?.toString() ?? '',
    longitude: json['longitude']?.toString() ?? '',
    contactName: json['contact_name'] ?? '',
    contactPhone: json['contact_phone'] ?? '',
    notes: json['notes'] ?? '',
    status: json['status'] ?? '',
    arrivalTime: json['arrival_time'],
    departureTime: json['departure_time'],
  );
}

/// ---------------- CUSTOMER ----------------
class Customer {
  final String name;
  final String phone;

  Customer({required this.name, required this.phone});

  factory Customer.fromJson(Map<String, dynamic> json) =>
      Customer(name: json['name'] ?? '', phone: json['phone'] ?? '');
}

/// ---------------- PICKUP ----------------
class Pickup {
  final String address;
  final String city;
  final String state;
  final String latitude;
  final String longitude;
  final String contactName;
  final String contactPhone;
  final String? scheduledDate;
  final String? scheduledTime;
  final String? otp;

  Pickup({
    required this.address,
    required this.city,
    required this.state,
    required this.latitude,
    required this.longitude,
    required this.contactName,
    required this.contactPhone,
    this.scheduledDate,
    this.scheduledTime,
    this.otp,
  });

  factory Pickup.fromJson(Map<String, dynamic> json) => Pickup(
    address: json['address'] ?? "",
    city: json['city'] ?? "",
    state: json['state'] ?? "",
    latitude: json['latitude']?.toString() ?? "",
    longitude: json['longitude']?.toString() ?? "",
    contactName: json['contact_name'] ?? "",
    contactPhone: json['contact_phone'] ?? "",
    scheduledDate: json['scheduled_date'],
    scheduledTime: json['scheduled_time'],
    otp: json['otp'],
  );
}

/// ---------------- DELIVERY ----------------
class Delivery {
  final String address;
  final String city;
  final String state;
  final String latitude;
  final String longitude;
  final String contactName;
  final String contactPhone;
  final String? scheduledDate;
  final String? scheduledTime;
  final String? instructions;
  final String? otp;

  Delivery({
    required this.address,
    required this.city,
    required this.state,
    required this.latitude,
    required this.longitude,
    required this.contactName,
    required this.contactPhone,
    this.scheduledDate,
    this.scheduledTime,
    this.instructions,
    this.otp,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
    address: json['address'] ?? "",
    city: json['city'] ?? "",
    state: json['state'] ?? "",
    latitude: json['latitude']?.toString() ?? "",
    longitude: json['longitude']?.toString() ?? "",
    contactName: json['contact_name'] ?? "",
    contactPhone: json['contact_phone'] ?? "",
    scheduledDate: json['scheduled_date'],
    scheduledTime: json['scheduled_time'],
    instructions: json['instructions'],
    otp: json['otp'],
  );
}

/// ---------------- ITEMS ----------------
class Item {
  final int id;
  final String productName;
  final String description;
  final String sku;
  final int quantity;
  final String weightKg;
  final dynamic volume;
  final dynamic dimensions;
  final String declaredValue;
  final dynamic specialHandling;

  Item({
    required this.id,
    required this.productName,
    required this.description,
    required this.sku,
    required this.quantity,
    required this.weightKg,
    this.volume,
    this.dimensions,
    required this.declaredValue,
    this.specialHandling,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: parseInt(json['id']),
    productName: json['product_name'] ?? '',
    description: json['description'] ?? '',
    sku: json['sku'] ?? '',
    quantity: parseInt(json['quantity']),
    weightKg: json['weight_kg']?.toString() ?? '0',
    volume: json['volume'],
    dimensions: json['dimensions'],
    declaredValue: json['declared_value']?.toString() ?? '0',
    specialHandling: json['special_handling'],
  );
}

/// ---------------- PACKAGE INFO ----------------
class PackageInfo {
  final int totalItems;
  final int totalWeight;
  final int totalValue;
  final String description;

  PackageInfo({
    required this.totalItems,
    required this.totalWeight,
    required this.totalValue,
    required this.description,
  });

  factory PackageInfo.fromJson(Map<String, dynamic> json) => PackageInfo(
    totalItems: parseInt(json['total_items']),
    totalWeight: parseInt(json['total_weight']),
    totalValue: parseInt(json['total_value']),
    description: json['description'] ?? '',
  );

  factory PackageInfo.empty() => PackageInfo(
    totalItems: 0,
    totalWeight: 0,
    totalValue: 0,
    description: '',
  );
}

/// ---------------- ORDER DETAILS ----------------
class OrderDetails {
  final String serviceType;
  final String vehicleType;
  final String priority;
  final String distanceKm;

  OrderDetails({
    required this.serviceType,
    required this.vehicleType,
    required this.priority,
    required this.distanceKm,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) => OrderDetails(
    serviceType: json['service_type'] ?? "",
    vehicleType: json['vehicle_type'] ?? "",
    priority: json['priority'] ?? "",
    distanceKm: (json['distance_km'] ?? "").toString(),
  );

  factory OrderDetails.empty() => OrderDetails(
    serviceType: '',
    vehicleType: '',
    priority: '',
    distanceKm: '',
  );
}

/// ---------------- ADD ONS ----------------
class AddOns {
  final List<AddOnSelected> selected;
  final double cost;
  final QuickFlags quickFlags;

  AddOns({
    required this.selected,
    required this.cost,
    required this.quickFlags,
  });

  factory AddOns.fromJson(Map<String, dynamic> json) => AddOns(
    selected: (json['selected'] as List<dynamic>? ?? [])
        .map((e) => AddOnSelected.fromJson(e))
        .toList(),
    cost: parseDouble(json['cost']),
    quickFlags: QuickFlags.fromJson(json['quick_flags'] ?? {}),
  );

  factory AddOns.empty() =>
      AddOns(selected: [], cost: 0.0, quickFlags: QuickFlags.empty());
}

class AddOnSelected {
  final String code;
  final String name;
  final String description;
  final String icon;
  final String driverAction;

  AddOnSelected({
    required this.code,
    required this.name,
    required this.description,
    required this.icon,
    required this.driverAction,
  });

  factory AddOnSelected.fromJson(Map<String, dynamic> json) => AddOnSelected(
    code: json['code'] ?? '',
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    icon: json['icon'] ?? '',
    driverAction: json['driver_action'] ?? '',
  );
}

class QuickFlags {
  final bool hasInsurance;
  final bool requiresSignature;
  final bool isFragile;
  final bool needsPhoto;
  final bool ageCheck;
  final bool contactless;

  QuickFlags({
    required this.hasInsurance,
    required this.requiresSignature,
    required this.isFragile,
    required this.needsPhoto,
    required this.ageCheck,
    required this.contactless,
  });

  factory QuickFlags.fromJson(Map<String, dynamic> json) => QuickFlags(
    hasInsurance: json['has_insurance'] ?? false,
    requiresSignature: json['requires_signature'] ?? false,
    isFragile: json['is_fragile'] ?? false,
    needsPhoto: json['needs_photo'] ?? false,
    ageCheck: json['age_check'] ?? false,
    contactless: json['contactless'] ?? false,
  );

  factory QuickFlags.empty() => QuickFlags(
    hasInsurance: false,
    requiresSignature: false,
    isFragile: false,
    needsPhoto: false,
    ageCheck: false,
    contactless: false,
  );
}

/// ---------------- PAYMENT ----------------
class Payment {
  final String estimatedCost;
  final String finalCost;
  final String serviceFee;
  final String taxAmount;
  final String addOnsCost;
  final double driverEarning;
  final String paymentMethod;
  final String paymentStatus;

  Payment({
    required this.estimatedCost,
    required this.finalCost,
    required this.serviceFee,
    required this.taxAmount,
    required this.addOnsCost,
    required this.driverEarning,
    required this.paymentMethod,
    required this.paymentStatus,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    estimatedCost: json['estimated_cost']?.toString() ?? '0',
    finalCost: json['final_cost']?.toString() ?? '0',
    serviceFee: json['service_fee']?.toString() ?? '0',
    taxAmount: json['tax_amount']?.toString() ?? '0',
    addOnsCost: json['add_ons_cost']?.toString() ?? '0',
    driverEarning: parseDouble(json['driver_earning']),
    paymentMethod: json['payment_method'] ?? '',
    paymentStatus: json['payment_status'] ?? '',
  );

  factory Payment.empty() => Payment(
    estimatedCost: '0',
    finalCost: '0',
    serviceFee: '0',
    taxAmount: '0',
    addOnsCost: '0',
    driverEarning: 0.0,
    paymentMethod: '',
    paymentStatus: '',
  );
}

/// ---------------- TIMESTAMPS ----------------
class OrderTimestamps {
  final String createdAt;
  final String? assignedAt;
  final String? pickedUpAt;
  final String? completedAt;

  OrderTimestamps({
    required this.createdAt,
    this.assignedAt,
    this.pickedUpAt,
    this.completedAt,
  });

  factory OrderTimestamps.fromJson(Map<String, dynamic> json) =>
      OrderTimestamps(
        createdAt: json['created_at'] ?? '',
        assignedAt: json['assigned_at'],
        pickedUpAt: json['picked_up_at'],
        completedAt: json['completed_at'],
      );

  factory OrderTimestamps.empty() => OrderTimestamps(
    createdAt: '',
    assignedAt: null,
    pickedUpAt: null,
    completedAt: null,
  );
}
