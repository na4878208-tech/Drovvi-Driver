import 'package:flutter/foundation.dart';

double parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}


class OrderModel {
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
  final String pickupCity;
  final String pickupState;
  final String pickupContactName;
  final String pickupContactPhone;
  final double pickupLatitude;
  final double pickupLongitude;
  final String deliveryAddress;
  final String deliveryCity;
  final String deliveryState;
  final String deliveryContactName;
  final String deliveryContactPhone;
  final double deliveryLatitude;
  final double deliveryLongitude;
  final List<OrderItem> items;
  final int totalItems;
  final double totalWeight;
  final String packageDescription;
  final String serviceType;
  final String? vehicleType;
  final String priority;
  final double distanceKm;
  final List<OrderAddOn> addOns;
  final double addOnsCost;
  final bool hasInsurance;
  final bool requiresSignature;
  final bool isFragile;
  final double estimatedCost;
  final double finalCost;
  final double estimatedEarning;
  final String paymentMethod;
  final DateTime createdAt;

  OrderModel({
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
    required this.pickupCity,
    required this.pickupState,
    required this.pickupContactName,
    required this.pickupContactPhone,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.deliveryAddress,
    required this.deliveryCity,
    required this.deliveryState,
    required this.deliveryContactName,
    required this.deliveryContactPhone,
    required this.deliveryLatitude,
    required this.deliveryLongitude,
    required this.items,
    required this.totalItems,
    required this.totalWeight,
    required this.packageDescription,
    required this.serviceType,
    required this.vehicleType,
    required this.priority,
    required this.distanceKm,
    required this.addOns,
    required this.addOnsCost,
    required this.hasInsurance,
    required this.requiresSignature,
    required this.isFragile,
    required this.estimatedCost,
    required this.finalCost,
    required this.estimatedEarning,
    required this.paymentMethod,
    required this.createdAt,
  });

 factory OrderModel.fromJson(Map<String, dynamic> json) {
  if (kDebugMode) {
    print("🟡 Parsing Order ID: ${json['id']}");
  }
  if (kDebugMode) {
    print("🟡 estimated_earning RAW => ${json['estimated_earning']}");
  }

  return OrderModel(
    id: json['id'] ?? 0,
    orderNumber: json['order_number'] ?? '',
    trackingCode: json['tracking_code'] ?? '',
    status: json['status'] ?? '',
    paymentStatus: json['payment_status'] ?? '',
    isMultiStop: (json['is_multi_stop'] ?? 0) == 1,
    stopsCount: json['stops_count'] ?? 0,

    stops: (json['stops'] as List<dynamic>? ?? [])
        .map((e) => OrderStop.fromJson(e))
        .toList(),

    customerName: json['customer_name'] ?? '',
    customerPhone: json['customer_phone'] ?? '',

    pickupAddress: json['pickup_address'] ?? '',
    pickupCity: json['pickup_city'] ?? '',
    pickupState: json['pickup_state'] ?? '',
    pickupContactName: json['pickup_contact_name'] ?? '',
    pickupContactPhone: json['pickup_contact_phone'] ?? '',
    pickupLatitude: parseDouble(json['pickup_latitude']),
    pickupLongitude: parseDouble(json['pickup_longitude']),

    deliveryAddress: json['delivery_address'] ?? '',
    deliveryCity: json['delivery_city'] ?? '',
    deliveryState: json['delivery_state'] ?? '',
    deliveryContactName: json['delivery_contact_name'] ?? '',
    deliveryContactPhone: json['delivery_contact_phone'] ?? '',
    deliveryLatitude: parseDouble(json['delivery_latitude']),
    deliveryLongitude: parseDouble(json['delivery_longitude']),

    items: (json['items'] as List<dynamic>? ?? [])
        .map((e) => OrderItem.fromJson(e))
        .toList(),

    totalItems: json['total_items'] ?? 0,
    totalWeight: parseDouble(json['total_weight']),

    packageDescription: json['package_description'] ?? '',
    serviceType: json['service_type'] ?? '',
    vehicleType: json['vehicle_type'],
    priority: json['priority'] ?? '',

    distanceKm: parseDouble(json['distance_km']),

    addOns: (json['add_ons'] as List<dynamic>? ?? [])
        .map((e) => OrderAddOn.fromJson(e))
        .toList(),

    addOnsCost: parseDouble(json['add_ons_cost']),
    hasInsurance: json['has_insurance'] ?? false,
    requiresSignature: json['requires_signature'] ?? false,
    isFragile: json['is_fragile'] ?? false,

    estimatedCost: parseDouble(json['estimated_cost']),
    finalCost: parseDouble(json['final_cost']),
    estimatedEarning: parseDouble(json['estimated_earning']),

    paymentMethod: json['payment_method'] ?? '',
    createdAt: DateTime.parse(json['created_at']),
  );
}
}

class OrderStop {
  final int id;
  final String stopType;
  final int sequenceNumber;
  final String address;
  final String? city;
  final String? state;
  final double? latitude;
  final double? longitude;
  final String? contactName;
  final String? contactPhone;
  final String? notes;
  final String status;

  OrderStop({
    required this.id,
    required this.stopType,
    required this.sequenceNumber,
    required this.address,
    this.city,
    this.state,
    this.latitude,
    this.longitude,
    this.contactName,
    this.contactPhone,
    this.notes,
    required this.status,
  });

  factory OrderStop.fromJson(Map<String, dynamic> json) {
    return OrderStop(
      id: json['id'] ?? 0,
      stopType: json['stop_type'] ?? '',
      sequenceNumber: json['sequence_number'] ?? 0,
      address: json['address'] ?? '',
      city: json['city'],
      state: json['state'],
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
      contactName: json['contact_name'],
      contactPhone: json['contact_phone'],
      notes: json['notes'],
      status: json['status'] ?? '',
    );
  }
}

class OrderItem {
  final int id;
  final String productName;
  final String? description;
  final int quantity;
  final double weightKg;
  final String? dimensions;
  final double? declaredValue;

  OrderItem({
    required this.id,
    required this.productName,
    this.description,
    required this.quantity,
    required this.weightKg,
    this.dimensions,
    this.declaredValue,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? 0,
      productName: json['product_name'] ?? '',
      description: json['description'],
      quantity: json['quantity'] ?? 0,
      weightKg: parseDouble(json['weight_kg']),
      dimensions: json['dimensions'],
      declaredValue: json['declared_value'] != null
          ? double.tryParse(json['declared_value'].toString())
          : null,
    );
  }
}

class OrderAddOn {
  final String code;
  final String name;
  final String? description;
  final String? icon;
  final String? driverAction;

  OrderAddOn({
    required this.code,
    required this.name,
    this.description,
    this.icon,
    this.driverAction,
  });

  factory OrderAddOn.fromJson(Map<String, dynamic> json) {
    return OrderAddOn(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      icon: json['icon'],
      driverAction: json['driver_action'],
    );
  }
}
