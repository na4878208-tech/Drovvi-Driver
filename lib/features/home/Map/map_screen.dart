import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import '../../../export.dart';
import '../order_details_screen/button_process/multi_stop_button/stop_arrived/stop_action_controller.dart';
import '../order_details_screen/button_process/multi_stop_button/stop_arrived/stop_action_model.dart';
import '../order_details_screen/drvier_location/tracking.dart';
import '../order_details_screen/order_detail_controller.dart';
import '../order_details_screen/order_detail_modal.dart';
import '../order_details_screen/order_detail_screen.dart';
import 'map_button_process/delivery_button/delivery_button_controller.dart';
import 'map_button_process/pick_up_button/pick_up_button_controller.dart';

class MapScreen extends ConsumerStatefulWidget {
  final int orderId;
  final String type;

  const MapScreen({super.key, required this.orderId, required this.type});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

/// ------------------- State -------------------

class _MapScreenState extends ConsumerState<MapScreen> {
  GoogleMapController? _googleMapController;
  StreamSubscription<Position>? _positionStream;
  bool _isProcessing = false;
  LatLng? _driverLocation;
  LatLng? _targetLocation;
  late final DriverLocationTracker _tracker;
  bool _isOtpFilled = false;
  final _formKey = GlobalKey<FormState>();
  Set<Polyline> _polylines = {};
  late final PolylinePoints polylinePoints;
  final String googleApiKey = "AIzaSyAvuqv3vjx8JCwe-dKXJWV_ggqraBqIFKs";
  String _otp = "";

  bool _isFirstStop(OrderModel order, OrderStop stop) {
    final sortedStops = [...order.stops]
      ..sort((a, b) => a.sequenceNumber.compareTo(b.sequenceNumber));
    return sortedStops.first.id == stop.id;
  }

  bool _isLastStop(OrderModel order, OrderStop stop) {
    final sortedStops = [...order.stops]
      ..sort((a, b) => a.sequenceNumber.compareTo(b.sequenceNumber));
    return sortedStops.last.id == stop.id;
  }

  bool _requiresOtp(OrderModel order, OrderStop stop) {
    return _isFirstStop(order, stop) || _isLastStop(order, stop);
  }

  @override
  void initState() {
    super.initState();

    polylinePoints = PolylinePoints.custom(
      apiKey: googleApiKey,
      preferRoutesApi: true,
    );
    _tracker = ref.read(driverLocationTrackerProvider);
    _tracker.start();
    _getCurrentLocation();

    _positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 5,
          ),
        ).listen((pos) {
          setState(() {
            _driverLocation = LatLng(pos.latitude, pos.longitude);
          });

          // Only redraw camera, not route
          if (_googleMapController != null) {
            _googleMapController!.animateCamera(
              CameraUpdate.newLatLng(_driverLocation!),
            );
          }
        });
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _tracker.stop();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enable location services")),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Location permission denied")),
          );
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Location permissions permanently denied. Enable in settings.",
            ),
          ),
        );
        await Geolocator.openAppSettings();
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!mounted) return;

      setState(() {
        _driverLocation = LatLng(pos.latitude, pos.longitude);
      });
    } catch (e) {
      debugPrint("Location Error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error fetching location")),
        );
      }
    }
  }

  Future<void> _createRoute() async {
    if (_driverLocation == null || _targetLocation == null) return;

    try {
      final request = RoutesApiRequest(
        origin: PointLatLng(
          _driverLocation!.latitude,
          _driverLocation!.longitude,
        ),
        destination: PointLatLng(
          _targetLocation!.latitude,
          _targetLocation!.longitude,
        ),
        travelMode: TravelMode.driving,
        routingPreference: RoutingPreference.trafficAware,
        polylineQuality: PolylineQuality.highQuality,
      );

      RoutesApiResponse response = await polylinePoints
          .getRouteBetweenCoordinatesV2(request: request);

      debugPrint("Status: ${response.status}");
      debugPrint("Error: ${response.errorMessage}");
      debugPrint("Routes: ${response.routes.length}");

      if (response.routes.isNotEmpty) {
        final route = response.routes.first;

        final points = route.polylinePoints ?? [];

        if (points.isEmpty) {
          debugPrint("No polyline points returned");
          return;
        }

        List<LatLng> polylineCoordinates = points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();

        setState(() {
          _polylines = {
            Polyline(
              polylineId: const PolylineId("route"),
              color: Colors.blue,
              width: 6,
              points: polylineCoordinates,
            ),
          };
        });
      }
    } catch (e) {
      debugPrint("Route exception: $e");
    }
  }

  void _centerMapOnDriver() {
    if (_googleMapController != null && _driverLocation != null) {
      _googleMapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_driverLocation!, 15),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Location unavailable")));
    }
  }

  OrderStop? getActiveStop(List<OrderStop> stops) {
    final pendingStops =
        stops
            .where((s) => s.status != "completed" && s.status != "skipped")
            .toList()
          ..sort((a, b) => a.sequenceNumber.compareTo(b.sequenceNumber));
    return pendingStops.isNotEmpty ? pendingStops.first : null;
  }

  String _getActionButtonText(OrderModel order) {
    if (order.isMultiStop) {
      final activeStop = getActiveStop(order.stops);
      if (activeStop == null) return "All Stops Completed";
      if (activeStop.status == "in_progress" ||
          activeStop.status == "arrived") {
        return "Complete Stop ${activeStop.sequenceNumber}";
      }
      if (activeStop.stopType == "pickup") {
        return "Start Pickup ${activeStop.sequenceNumber}";
      }
      return "Go to Stop ${activeStop.sequenceNumber}";
    }

    return widget.type.toLowerCase() == "pickup"
        ? "Confirm Pickup"
        : "Confirm Delivery";
  }

  Future<void> _onActionButtonPressed(OrderModel order) async {
    if (order.isMultiStop) {
      final activeStop = getActiveStop(order.stops);
      if (activeStop == null) {
        return;
      }

      setState(() => _isProcessing = true);

      try {
        final stopController = ref.read(stopActionControllerProvider.notifier);
        StopActionResponse res;

        if (activeStop.status != "arrived" &&
            activeStop.status != "in_progress") {
          // 🔹 Arrive Stop
          res = await stopController.arrivedStop(
            orderId: order.id,
            stopId: activeStop.id,
          );
        } else {
          // 🔹 Complete Stop

          final stopLat = double.tryParse(activeStop.latitude) ?? 0;
          final stopLng = double.tryParse(activeStop.longitude) ?? 0;

          bool isFirst = _isFirstStop(order, activeStop);
          bool isLast = _isLastStop(order, activeStop);

          // 👉 Middle Stop → location check required
          if (!isFirst && !isLast) {
            if (_driverLocation == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Driver location unavailable")),
              );
              return;
            }

            final distance = Geolocator.distanceBetween(
              _driverLocation!.latitude,
              _driverLocation!.longitude,
              stopLat,
              stopLng,
            );

            if (distance > 100) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "You must be within 100 meters to complete this stop",
                  ),
                ),
              );
              return;
            }
          }

          // 👉 First / Last Stop → OTP required
          if (_requiresOtp(order, activeStop)) {
            final otp = _otp.trim();

            if (otp.length != 4) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Enter valid 4-digit OTP")),
              );
              return;
            }

            res = await stopController.completeStop(
              orderId: order.id,
              stopId: activeStop.id,
              otp: otp,
            );
          } else {
            res = await stopController.completeStop(
              orderId: order.id,
              stopId: activeStop.id,
            );
          }

          // 🔴 STOP TRACKING if order completed
          if (res.data?.isOrderCompleted == true) {
            ref.read(driverLocationTrackerProvider).stop();
          }

          if (!mounted) return;

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(res.message)));

          // ✅ Replace screen instead of push
          context.go("/order-details", extra: widget.orderId);

          return;
        }

        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(res.message)));

        // Refresh after arrive
        // ignore: unused_result
        ref.refresh(orderDetailsControllerProvider(order.id));
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      } finally {
        if (mounted) setState(() => _isProcessing = false);
      }

      return;
    }

    // 🔹 Single Stop (unchanged)
    if (widget.type.toLowerCase() == "pickup") {
      _confirmPickup();
    } else {
      _confirmDelivery();
    }
  }

  void _confirmPickup() async {
    final otp = _otp.trim();

    if (otp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid 4-digit OTP")),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      await ref
          .read(confirmPickupControllerProvider.notifier)
          .confirmPickup(orderId: widget.orderId, otp: otp);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Pickup Confirmed ✅")));

      // ✅ PASS ORDER ID PROPERLY
      context.push(
        "/order-details",
        extra: widget.orderId, // 🔥 THIS WAS MISSING
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Pickup Failed: $e")));
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _confirmDelivery() async {
    final otp = _otp.trim();
    if (otp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid 4-digit OTP")),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      await ref
          .read(confirmDeliveryControllerProvider.notifier)
          .confirmDelivery(orderId: widget.orderId, otp: otp);

      // 🔴 STOP TRACKING
      ref.read(driverLocationTrackerProvider).stop();

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Delivery Confirmed ✅")));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OrderDetailsScreen(orderId: widget.orderId),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Delivery Failed: $e")));
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final inactiveColor = AppColors.mediumGray;
    final orderAsync = ref.watch(
      orderDetailsControllerProvider(widget.orderId),
    );

    return Scaffold(
      body: Form(
        key: _formKey,
        child: orderAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text(e.toString())),
          data: (OrderModel order) {
            // Initialize target location
            LatLng? newTarget;

            if (order.isMultiStop) {
              final activeStop = getActiveStop(order.stops);
              if (activeStop != null) {
                newTarget = LatLng(
                  double.tryParse(activeStop.latitude) ?? 0,
                  double.tryParse(activeStop.longitude) ?? 0,
                );
              }
            } else if (widget.type.toLowerCase() == "pickup") {
              newTarget = LatLng(
                double.tryParse(order.pickup.latitude) ?? 0,
                double.tryParse(order.pickup.longitude) ?? 0,
              );
            } else {
              newTarget = LatLng(
                double.tryParse(order.delivery.latitude) ?? 0,
                double.tryParse(order.delivery.longitude) ?? 0,
              );
            }

            if (newTarget != null &&
                (_targetLocation == null ||
                    _targetLocation!.latitude != newTarget.latitude ||
                    _targetLocation!.longitude != newTarget.longitude)) {
              _targetLocation = newTarget;

              WidgetsBinding.instance.addPostFrameCallback((_) {
                _createRoute();
              });
            }

            return Stack(
              children: [
                // MAP
                if (_driverLocation != null)
                  GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target:
                          _driverLocation ??
                          LatLng(24.8607, 67.0011), // Karachi default
                      zoom: 15,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    markers: {
                      // if (_driverLocation != null)
                      //   Marker(
                      //     markerId: MarkerId("driver"),
                      //     position: _driverLocation!,
                      //   ),
                      if (_targetLocation != null)
                        Marker(
                          markerId: const MarkerId("target"),
                          position: _targetLocation!,
                        ),
                    },
                    polylines: _polylines,
                    onMapCreated: (GoogleMapController controller) {
                      _googleMapController = controller;

                      if (_driverLocation != null && _targetLocation != null) {
                        _createRoute();
                      }
                    },
                  ),
                // BACK BUTTON
                Positioned(
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 16,
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black,
                        size: 18,
                      ),
                    ),
                  ),
                ),

                // CURRENT LOCATION BUTTON
                Positioned(
                  bottom: 140,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: _centerMapOnDriver,
                    backgroundColor: Colors.teal,
                    child: const Icon(Icons.my_location),
                  ),
                ),

                // DRAGGABLE BOTTOM SHEET
                DraggableScrollableSheet(
                  initialChildSize: 0.17,
                  minChildSize: 0.10,
                  maxChildSize: 0.6,
                  builder: (context, scrollController) {
                    List<Widget> stopWidgets = [];

                    if (order.isMultiStop) {
                      final activeStop = getActiveStop(order.stops);
                      if (activeStop != null) {
                        stopWidgets.add(
                          _infoCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _sectionTitle(
                                  "Stop ${activeStop.sequenceNumber} • ${activeStop.stopType.toUpperCase()}",
                                  Icons.flag,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "${activeStop.address}, ${activeStop.city}, ${activeStop.state}",
                                  style: const TextStyle(fontSize: 13),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Name: ${activeStop.contactName} | ${activeStop.contactPhone}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Status: ${activeStop.status.toUpperCase()}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                if (_requiresOtp(order, activeStop)) ...[
                                  const SizedBox(height: 16),
                                  _sectionTitle(
                                    "Enter OTP",
                                    Icons.lock_outline,
                                  ),
                                  const SizedBox(height: 10),
                                  PinCodeTextField(
                                    appContext: context,
                                    length: 4,
                                    keyboardType: TextInputType.number,
                                    animationType: AnimationType.fade,
                                    enableActiveFill: true,
                                    pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(10),
                                      fieldHeight: 48,
                                      fieldWidth: 44,
                                      inactiveColor: AppColors.electricTeal
                                          .withOpacity(0.3),
                                      selectedColor: AppColors.electricTeal,
                                      activeColor: AppColors.electricTeal,
                                      activeFillColor: Colors.white,
                                      inactiveFillColor: Colors.white,
                                      selectedFillColor: Colors.white,
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _otp = value;
                                        _isOtpFilled = value.length == 4;
                                      });
                                    },
                                  ),
                                ],
                                const SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: _buildActionButton(order),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    } else {
                      final isPickup = widget.type.toLowerCase() == "pickup";

                      stopWidgets.addAll([
                        _infoCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _sectionTitle(
                                isPickup
                                    ? "Pickup Location"
                                    : "Delivery Location",
                                isPickup
                                    ? Icons.upload_rounded
                                    : Icons.download_rounded,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      isPickup
                                          ? "${order.pickup.address}, ${order.pickup.city}, ${order.pickup.state}"
                                          : "${order.delivery.address}, ${order.delivery.city}, ${order.delivery.state}",
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Icon(Icons.person, size: 18),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      isPickup
                                          ? "Name: ${order.pickup.contactName} | Contact: ${order.pickup.contactPhone}"
                                          : "Name: ${order.delivery.contactName} | Contact: ${order.delivery.contactPhone}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _infoCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _sectionTitle("Enter OTP", Icons.lock_outline),
                              const SizedBox(height: 10),
                              PinCodeTextField(
                                appContext: context,
                                length: 4,
                                keyboardType: TextInputType.number,
                                animationType: AnimationType.fade,
                                enableActiveFill: true,
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(10),
                                  fieldHeight: 48,
                                  fieldWidth: 44,
                                  inactiveColor: AppColors.electricTeal
                                      .withOpacity(0.3),
                                  selectedColor: AppColors.electricTeal,
                                  activeColor: AppColors.electricTeal,
                                  activeFillColor: Colors.white,
                                  inactiveFillColor: Colors.white,
                                  selectedFillColor: Colors.white,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _otp = value;
                                    _isOtpFilled = value.length == 4;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: CustomButton(
                            isChecked: _isOtpFilled || order.isMultiStop,
                            text: _isProcessing
                                ? "Processing..."
                                : _getActionButtonText(order),
                            backgroundColor: (_isOtpFilled || order.isMultiStop)
                                ? AppColors.electricTeal
                                : inactiveColor,
                            borderColor: AppColors.electricTeal,
                            textColor: Colors.white,
                            onPressed: (_isOtpFilled || order.isMultiStop)
                                ? () => _onActionButtonPressed(order)
                                : null,
                          ),
                        ),
                      ]);
                    }

                    return Container(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(22),
                        ),
                      ),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [_dragHandle(), ...stopWidgets],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionButton(OrderModel order) {
    bool enableButton = false;

    if (_isProcessing) {
      enableButton = false;
    } else if (order.isMultiStop) {
      final activeStop = getActiveStop(order.stops);

      if (activeStop != null && _driverLocation != null) {
        final stopLat = double.tryParse(activeStop.latitude) ?? 0;
        final stopLng = double.tryParse(activeStop.longitude) ?? 0;
        final distance = Geolocator.distanceBetween(
          _driverLocation!.latitude,
          _driverLocation!.longitude,
          stopLat,
          stopLng,
        );

        // Middle stops → no OTP, first/last → OTP required
        bool isFirstStop = activeStop.sequenceNumber == 1;
        bool isLastStop = activeStop.sequenceNumber == order.stops.length;

        if (activeStop.status == "pending" ||
            activeStop.status == "in_progress") {
          enableButton = true; // Arrive allowed
        } else if (activeStop.status == "arrived") {
          if (isFirstStop || isLastStop) {
            enableButton = _isOtpFilled; // OTP needed
          } else {
            enableButton = distance <= 100; // Middle stop → arrive complete
          }
        }
      }
    } else {
      // Single stop → always OTP required
      enableButton = _isOtpFilled;
    }

    return CustomButton(
      isChecked: enableButton,
      text: _isProcessing ? "Processing..." : _getActionButtonText(order),
      backgroundColor: enableButton
          ? AppColors.electricTeal
          : AppColors.mediumGray,
      borderColor: AppColors.electricTeal,
      textColor: Colors.white,
      onPressed: enableButton ? () => _onActionButtonPressed(order) : null,
    );
  }
}

Widget _dragHandle() {
  return Center(
    child: Container(
      width: 46,
      height: 5,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(6),
      ),
    ),
  );
}

Widget _sectionTitle(String title, IconData icon) {
  return Row(
    children: [
      Icon(icon, size: 18, color: AppColors.electricTeal),
      const SizedBox(width: 6),
      Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ],
  );
}

Widget _infoCard({required Widget child}) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: child,
  );
}
