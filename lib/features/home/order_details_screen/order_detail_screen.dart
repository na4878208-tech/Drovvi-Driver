import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logisticdriverapp/constants/bottom_show.dart';
import '../../../export.dart';
import '../Map/map_button_process/skip_stop/skip_stop_screen.dart';
import '../main_screens/home_screen/home_controller.dart';
import 'button_process/multi_stop_button/stop_arrived/stop_action_controller.dart';
import 'button_process/order_assigned/order_assigned_controller.dart';
import 'package:shimmer/shimmer.dart';
import 'drvier_location/tracking.dart';
import 'order_detail_controller.dart';
import 'order_detail_modal.dart';

class OrderDetailsScreen extends ConsumerStatefulWidget {
  final int orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  ConsumerState<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends ConsumerState<OrderDetailsScreen> {
  final ValueNotifier<bool> _isButtonProcessing = ValueNotifier(false);

  OrderStop? getActiveStop(List<OrderStop> stops) {
    for (final stop in stops) {
      if (stop.status == "pending" || stop.status == "arrived") {
        return stop;
      }
    }
    return null;
  }

  String formatDate(String date) {
    final parsed = DateTime.parse(date).toLocal();
    return "${parsed.day}/${parsed.month}/${parsed.year}  ${parsed.hour}:${parsed.minute}";
  }

  bool isDriverOffDuty() {
    final dashboardAsync = ref.read(dashboardControllerProvider);

    return dashboardAsync.maybeWhen(
      data: (data) => data?.driverInfo.status == "off_duty",
      orElse: () => false,
    );
  }

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

  bool _canSkipStop(OrderModel order, OrderStop stop) {
    final isFirst = _isFirstStop(order, stop);
    final isLast = _isLastStop(order, stop);

    final isAlreadyProcessed =
        stop.status.toLowerCase() == "completed" ||
        stop.status.toLowerCase() == "skipped" ||
        stop.status.toLowerCase() == "skip_approved";

    return !isFirst && !isLast && !isAlreadyProcessed;
  }

  void _openSkipStopBottomSheet(OrderModel order) {
    /// ✅ Only middle & valid stops
    final availableStops = order.stops
        .where((stop) => _canSkipStop(order, stop))
        .toList();

    final selectedStopNotifier = ValueNotifier<OrderStop?>(null);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.65,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          builder: (_, scrollController) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: Column(
                children: [
                  /// 🔹 Drag Handle
                  Container(
                    height: 5,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 15),

                  /// 🔹 Title Row
                  Row(
                    children: [
                      const Text(
                        "Select Stop to Skip",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Colors.red),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  /// 🔹 Stops List
                  if (availableStops.isEmpty)
                    const Expanded(
                      child: Center(
                        child: Text(
                          "No middle stops available to skip",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ValueListenableBuilder<OrderStop?>(
                        valueListenable: selectedStopNotifier,
                        builder: (context, selectedStop, _) {
                          return ListView.separated(
                            controller: scrollController,
                            itemCount: availableStops.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 6),
                            itemBuilder: (context, index) {
                              final stop = availableStops[index];
                              final isSelected = selectedStop?.id == stop.id;

                              return GestureDetector(
                                onTap: () {
                                  selectedStopNotifier.value = stop;
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.electricTeal.withOpacity(
                                            0.1,
                                          )
                                        : Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.electricTeal
                                          : Colors.grey.shade300,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      /// 🔹 Sequence Circle
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColors.electricTeal
                                              : Colors.grey.shade300,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "${stop.sequenceNumber}",
                                            style: TextStyle(
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 15),

                                      /// 🔹 Stop Info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              stop.stopType.toUpperCase(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: isSelected
                                                    ? AppColors.electricTeal
                                                    : Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              stop.address,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      if (isSelected)
                                        const Icon(
                                          Icons.check_circle,
                                          color: AppColors.electricTeal,
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: 20),

                  /// 🔹 Skip Button
                  ValueListenableBuilder<OrderStop?>(
                    valueListenable: selectedStopNotifier,
                    builder: (context, selectedStop, _) {
                      return CustomButton(
                        text: "Skip this Stop",
                        backgroundColor: selectedStop == null
                            ? AppColors.lightGrayBackground
                            : AppColors.electricTeal,
                        borderColor: AppColors.electricTeal,
                        textColor: selectedStop == null
                            ? AppColors.electricTeal
                            : Colors.white,
                        onPressed: selectedStop == null
                            ? null
                            : () {
                                Navigator.pop(context);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SkipStopScreen(
                                      orderId: order.id,
                                      stop: selectedStop,
                                    ),
                                  ),
                                );
                              },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      // ignore: unused_result
      ref.refresh(orderDetailsControllerProvider(widget.orderId));
    });
  }

  @override
  void dispose() {
    _isButtonProcessing.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderAsync = ref.watch(
      orderDetailsControllerProvider(widget.orderId),
    );

    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Order Details",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.electricTeal,
        foregroundColor: AppColors.pureWhite,
        elevation: 0,
      ),
      body: orderAsync.when(
        loading: () => _buildShimmer(),
        error: (e, st) => Center(child: Text(e.toString())),
        data: (order) => _buildBody(context, order),
      ),
    );
  }

  Widget _buildBody(BuildContext context, OrderModel order) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// STATUS BADGE
                Row(
                  children: [
                    Text(
                      order.orderNumber,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order.status),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        order.status.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _customerCard(order),
                const SizedBox(height: 16),
                if (!order.isMultiStop)
                  singleTimeline(context, order)
                else
                  multiStopTimeline(context, order.stops),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                _packageCard(order),
                const SizedBox(height: 16),
                _orderDetailsCard(order),
                const SizedBox(height: 16),
                _addOnsCard(order),
                const SizedBox(height: 16),
                _paymentCard(order),
                const SizedBox(height: 16),
                _trackingCard(context, order),
                const SizedBox(height: 16),
                _timestampsCard(order),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _actionButtons(context, ref, order),
                ),
                const SizedBox(height: 16),
                if (order.isMultiStop)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomButton(
                      text: "Skip Stop",
                      backgroundColor: AppColors.electricTeal,
                      borderColor: AppColors.electricTeal,
                      textColor: AppColors.lightGrayBackground,
                      onPressed: () {
                        _openSkipStopBottomSheet(order);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------------- STATUS COLOR ----------------
  Color _getStatusColor(String status) {
    switch (status) {
      case "pending":
        return Colors.orange;
      case "confirmed":
        return Colors.blue;
      case "assigned":
        return Colors.indigo;
      case "picked_up":
        return Colors.purple;
      case "in_transit":
        return Colors.green;
      case "delivered":
        return Colors.teal;
      case "completed":
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  // ---------------- CUSTOMER CARD ----------------
  Widget _customerCard(OrderModel order) {
    return Card(
      color: AppColors.pureWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.lightBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.electricTeal,
              child: Icon(Icons.person, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.customer.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.phone_outlined,
                      size: 18,
                      color: AppColors.electricTeal,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      order.customer.phone,
                      style: const TextStyle(color: AppColors.electricTeal),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- LOCATION CARD ----------------

  Widget _timelineColumn({
    required Color pickupColor,
    required Color deliveryColor,
  }) {
    return SizedBox(
      width: 40, // thoda wider for style
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Gradient Vertical Line
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      pickupColor.withOpacity(0.3),
                      deliveryColor.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // PICKUP DOT
          Positioned(
            top: 50,
            child: _dot(pickupColor, size: 20, glow: true, icon: Icons.upload),
          ),

          // DELIVERY DOT
          Positioned(
            bottom: 40,
            child: _dot(
              deliveryColor,
              size: 20,
              glow: true,
              icon: Icons.download,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(
    Color color, {
    double size = 14,
    bool glow = false,
    IconData? icon,
  }) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: glow
            ? LinearGradient(
                colors: [color.withOpacity(0.8), color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: glow ? null : color,
        boxShadow: glow
            ? [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: icon != null
          ? Center(
              child: Icon(icon, color: Colors.white, size: size / 2),
            )
          : null,
    );
  }

  Widget _timelineCard({
    required String title,
    required String address,
    required String cityState,
    required String phone,
    required String name,
    required Color color,
    required IconData icon,
    String? arrivedAt,
    String? completedAt,
    String? stopType,
    String? status,
  }) {
    Color statusColor = Colors.grey;

    if (status != null) {
      switch (status.toLowerCase()) {
        case "arrived":
          statusColor = Colors.green;
          break;
        case "pending":
          statusColor = Colors.orange;
          break;
        case "completed":
          statusColor = Colors.blue;
          break;
        default:
          statusColor = Colors.grey;
      }
    }

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(color: color.withOpacity(0.4), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 TITLE + ICON ROW
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),

                /// 🔹 STATUS BADGE
                if (status != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 4),

            Row(
              children: [
                Icon(Icons.phone, size: 14),
                SizedBox(width: 5),
                Text(
                  name,
                  style: const TextStyle(fontSize: 13, color: Colors.black),
                ),
              ],
            ),

            Row(
              children: [
                SizedBox(width: 17),
                Expanded(
                  child: Text(
                    phone,
                    maxLines: 2, // jitni lines chahen
                    overflow: TextOverflow.ellipsis, // 👈 dots laga dega
                    softWrap: true,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Icon(Icons.location_on, size: 14),
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    address,
                    maxLines: 2, // jitni lines chahen
                    overflow: TextOverflow.ellipsis, // 👈 dots laga dega
                    softWrap: true,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                SizedBox(width: 17),
                Expanded(
                  child: Text(
                    cityState,
                    maxLines: 2, // jitni lines chahen
                    overflow: TextOverflow.ellipsis, // 👈 dots laga dega
                    softWrap: true,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            if (arrivedAt != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 12,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "${formatDate(arrivedAt)}",
                      style: const TextStyle(fontSize: 11, color: Colors.green),
                    ),
                  ],
                ),
              ),

            SizedBox(width: 10),
            if (completedAt != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 14,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "${formatDate(completedAt)}",
                      style: const TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget singleTimeline(BuildContext context, OrderModel order) {
    return Card(
      color: AppColors.pureWhite,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.only(right: 16, top: 16, bottom: 16),

        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.electricTeal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.alt_route,
                      size: 18,
                      color: AppColors.electricTeal,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Delivery Details",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // LEFT TIMELINE
                  _timelineColumn(
                    pickupColor: AppColors.electricTeal,
                    deliveryColor: AppColors.limeGreen,
                  ),

                  // RIGHT CARDS
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _timelineCard(
                          title: "Pickup",
                          address: order.pickup.address,
                          cityState:
                              "${order.pickup.city}, ${order.pickup.state}",
                          name: "${order.pickup.contactName} ",
                          phone: "${order.pickup.contactPhone}",
                          color: AppColors.electricTeal,
                          icon: Icons.upload,
                        ),

                        const SizedBox(height: 32),

                        _timelineCard(
                          title: "Delivery",
                          address: order.delivery.address,
                          cityState:
                              "${order.delivery.city}, ${order.delivery.state}",
                          name: "${order.pickup.contactName}",
                          phone: "${order.pickup.contactPhone}",
                          color: AppColors.limeGreen,
                          icon: Icons.download,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- MULTI-STOP TIMELINE ----------------
  Widget multiStopTimeline(BuildContext context, List<OrderStop> stops) {
    if (stops.isEmpty) return const SizedBox();

    final ValueNotifier<bool> showAllNotifier = ValueNotifier(false);

    return ValueListenableBuilder<bool>(
      valueListenable: showAllNotifier,
      builder: (context, showAll, _) {
        final displayedStops = showAll ? stops : stops.take(2).toList();

        return Card(
          color: AppColors.pureWhite,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 16, top: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.electricTeal.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.alt_route,
                              size: 18,
                              color: AppColors.electricTeal,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Multi-Stop Route",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      /// 🔹 TOTAL STOPS BADGE
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.limeGreen.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "${stops.length} Stops",
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // LEFT TIMELINE
                      SizedBox(
                        width: 40,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // SINGLE VERTICAL LINE
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: 4,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        AppColors.electricTeal.withOpacity(0.3),
                                        AppColors.limeGreen.withOpacity(0.3),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // DOTS
                            ...List.generate(displayedStops.length, (index) {
                              final stop = displayedStops[index];

                              Color color;
                              IconData icon;
                              switch (stop.stopType) {
                                case 'pickup':
                                  color = AppColors.electricTeal;
                                  icon = Icons.upload;
                                  break;
                                case 'drop_off':
                                  color = Colors.red;
                                  icon = Icons.download;
                                  break;
                                default:
                                  color = Colors.orange;
                                  icon = Icons.location_on;
                              }

                              double topOffset = 50 + index * 135.0;

                              return Positioned(
                                top: topOffset,
                                child: _dot(
                                  color,
                                  size: 20,
                                  glow: true,
                                  icon: icon,
                                ),
                              );
                            }),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      // RIGHT: CARDS
                      Expanded(
                        child: Column(
                          children: List.generate(displayedStops.length, (
                            index,
                          ) {
                            final stop = displayedStops[index];

                            Color color;
                            IconData icon;
                            switch (stop.stopType) {
                              case 'pickup':
                                color = AppColors.electricTeal;
                                icon = Icons.upload;
                                break;
                              case 'drop_off':
                                color = Colors.red;
                                icon = Icons.download;
                                break;
                              default:
                                color = Colors.orange;
                                icon = Icons.location_on;
                            }

                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: index == displayedStops.length - 1
                                    ? 0
                                    : 24,
                              ),
                              child: // Multi-stop
                              _timelineCard(
                                title: stop.stopType,
                                address: stop.address,
                                cityState: "${stop.city}, ${stop.state}",
                                name: "${stop.contactName}",
                                phone: "${stop.contactPhone}",
                                arrivedAt: stop.arrivalTime, // 👈 NEW
                                completedAt: stop.departureTime,
                                color: color,
                                icon: icon,
                                stopType: stop.stopType,
                                status: stop.status,
                                // onTap: () {
                                //   context.push(
                                //     "/map",
                                //     extra: {
                                //       "order": stop, // pass the order object
                                //       "type": stop
                                //           .stopType, // pass stop type like "pickup"/"delivery"
                                //     },
                                //   );
                                // },
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),

                // SHOW MORE / SHOW LESS BUTTON
                if (stops.length > 2)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        showAllNotifier.value = !showAllNotifier.value;
                      },
                      child: Text(showAll ? "Show Less" : "Show More"),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------- Order Items ----------------

  IconData _getProductIcon(String name) {
    final lowerName = name.toLowerCase();

    if (lowerName.contains("phone") || lowerName.contains("mobile")) {
      return Icons.phone_android;
    } else if (lowerName.contains("laptop")) {
      return Icons.laptop;
    } else if (lowerName.contains("tv")) {
      return Icons.tv;
    } else if (lowerName.contains("clothes")) {
      return Icons.checkroom;
    } else if (lowerName.contains("food")) {
      return Icons.fastfood;
    } else if (lowerName.contains("document")) {
      return Icons.description;
    } else if (lowerName.contains("medicine")) {
      return Icons.medical_services;
    } else {
      return Icons.inventory_2_outlined; // default
    }
  }

  Widget _packageCard(OrderModel order) {
    if (order.items.isEmpty) return const SizedBox();

    final item = order.items.first;

    return Card(
      elevation: 2,
      color: AppColors.pureWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.lightBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Order Items",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _detailRow(
              _getProductIcon(item.productName),
              "Product Name",
              item.productName,
            ),

            const SizedBox(height: 8),

            _detailRow(
              Icons.description_outlined,
              "Description",
              item.description,
            ),

            const SizedBox(height: 8),

            _detailRow(Icons.numbers, "Quantity", "${item.quantity}"),

            const SizedBox(height: 8),

            _detailRow(
              Icons.monitor_weight_outlined,
              "Weight",
              "${item.weightKg} kg",
            ),

            const SizedBox(height: 8),

            _detailRow(
              Icons.currency_exchange, // 🔥 Better money icon
              "Value",
              "R ${item.declaredValue}", // 🔥 Rand format
            ),
          ],
        ),
      ),
    );
  }

  Widget _orderDetailsCard(OrderModel order) {
    final pkg = order.packageInfo;
    final d = order.orderDetails;

    return Card(
      color: AppColors.pureWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.lightBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Product & Packaging Details",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _detailRow(
              Icons.miscellaneous_services_outlined,
              "Service Type",
              d.serviceType,
            ),

            const SizedBox(height: 10),

            _detailRow(
              Icons.local_shipping_outlined,
              "Vehicle Type",
              d.vehicleType,
            ),

            const SizedBox(height: 10),

            _detailRow(Icons.priority_high_outlined, "Priority", d.priority),

            const SizedBox(height: 10),

            _detailRow(Icons.route_outlined, "Distance", "${d.distanceKm} km"),

            const SizedBox(height: 10),

            _detailRow(
              Icons.inventory_2_outlined,
              "Total Items",
              "${pkg.totalItems}",
            ),

            const SizedBox(height: 10),

            _detailRow(
              Icons.scale_outlined,
              "Total Weight",
              "${pkg.totalWeight}",
            ),

            const SizedBox(height: 10),

            _detailRow(
              Icons.payments_outlined,
              "Total Value",
              "${pkg.totalValue}",
            ),

            const SizedBox(height: 10),

            if (pkg.description.isNotEmpty)
              _detailRow(
                Icons.description_outlined,
                "Description",
                pkg.description,
              ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.electricTeal),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.darkText,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ---------------- ADD-ONS CARD ----------------
  Widget _addOnsCard(OrderModel order) {
    if (order.addOns.selected.isEmpty) {
      return SizedBox(
        width: double.infinity,
        child: Card(
          color: AppColors.pureWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppColors.lightBorder),
          ),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "No add-ons Available",
              style: TextStyle(color: AppColors.darkText, fontSize: 12),
            ),
          ),
        ),
      );
    }

    final ValueNotifier<bool> showAllNotifier = ValueNotifier(false);

    return ValueListenableBuilder<bool>(
      valueListenable: showAllNotifier,
      builder: (context, showAll, _) {
        final allAddOns = order.addOns.selected;
        final visibleAddOns = showAll ? allAddOns : allAddOns.take(3).toList();

        return SizedBox(
          width: double.infinity,
          child: Card(
            color: AppColors.pureWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: AppColors.lightBorder),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Add-Ons",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      if (allAddOns.length > 3)
                        TextButton(
                          onPressed: () =>
                              showAllNotifier.value = !showAllNotifier.value,
                          child: Text(showAll ? "Show Less" : "Show More"),
                        ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// LIST
                  ...visibleAddOns.map(
                    (a) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.lightGrayBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment
                              .center, // <-- center the icon vertically
                          children: [
                            /// ICON
                            Text(a.icon, style: const TextStyle(fontSize: 18)),

                            const SizedBox(width: 12),

                            /// TEXT
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    a.name,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    a.driverAction,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.darkText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// HIDDEN COUNT INDICATOR
                  if (!showAll && allAddOns.length > 3)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        "+${allAddOns.length - 3} more add-ons",
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.electricTeal,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ---------------- PAYMENT CARD ----------------
  Widget _paymentCard(OrderModel order) {
    return Card(
      color: AppColors.pureWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.lightBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Payment Details",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _paymentRow("Estimated Cost", order.payment.estimatedCost),
            _paymentRow("Service Fee", order.payment.serviceFee),
            _paymentRow("Add-Ons", order.payment.addOnsCost),
            _paymentRow("Tax", order.payment.taxAmount),
            _paymentRow("Status", order.payment.paymentStatus),
            const Divider(height: 20),
            _paymentRow(
              "Driver Earning",
              order.payment.driverEarning.toStringAsFixed(2),
              bold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentRow(String title, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: bold ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- TRACKING CARD ----------------
  Widget _trackingCard(BuildContext context, OrderModel order) {
    return Card(
      color: AppColors.pureWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.lightBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// LEFT SIDE TITLE
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.electricTeal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.timeline,
                    color: AppColors.electricTeal,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Tracking History",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            /// RIGHT SIDE BUTTON
            ElevatedButton(
              onPressed: () {
                context.push("/order-tracking", extra: order);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.electricTeal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
              ),
              child: const Text("View", style: TextStyle(fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- TIMESTAMPS CARD ----------------
  Widget _timestampsCard(OrderModel order) {
    final ts = order.timestamps;
    return Card(
      color: AppColors.pureWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.lightBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Order Timestamps",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (ts.createdAt.isNotEmpty)
              _detailRow(Icons.add, "Created At", ts.createdAt),
            if (ts.assignedAt != null)
              _detailRow(Icons.assignment, "Assigned At", ts.assignedAt!),
            if (ts.pickedUpAt != null)
              _detailRow(Icons.local_shipping, "Picked Up At", ts.pickedUpAt!),
            if (ts.completedAt != null)
              _detailRow(Icons.check_circle, "Completed At", ts.completedAt!),
          ],
        ),
      ),
    );
  }

  // ---------------- ACTION BUTTONS ----------------
  Widget _actionButtons(BuildContext context, WidgetRef ref, OrderModel order) {
    final status = order.status.toLowerCase().replaceAll(" ", "_");

    // 🔥 MULTI STOP FLOW
    if (order.isMultiStop &&
        (status == "assigned" ||
            status == "in_transit" ||
            status == "picked_up" ||
            status == "delivered")) {
      if (isDriverOffDuty()) {
        return mainButton("Start Stop", () async {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text("You are currently off duty")),
          // );

          AppSnackBar.showError(context, "You are currently off duty");
        });
      }

      final activeStop = getActiveStop(order.stops);

      if (activeStop == null) {
        return const SizedBox.shrink();
      }

      final bool isArrived = activeStop.status == "arrived";

      final buttonText = isArrived
          ? "Continue Stop ${activeStop.sequenceNumber}"
          : "Start Stop ${activeStop.sequenceNumber}";

      return mainButton(buttonText, () async {
        try {
          /// 🟢 0️⃣ Start Live Location
          ref.read(driverLocationTrackerProvider).start();

          /// 🟢 1️⃣ If order still assigned → first START ORDER
          if (status == "assigned") {
            await ref
                .read(startOrderControllerProvider.notifier)
                .startOrder(order.id);
          }

          /// 🟢 2️⃣ If stop not arrived → mark arrived
          if (!isArrived) {
            await ref
                .read(stopActionControllerProvider.notifier)
                .arrivedStop(orderId: order.id, stopId: activeStop.id);
          }

          /// 🔄 Refresh order details
          if (!mounted) return;
          // ignore: unused_result
          await ref.refresh(orderDetailsControllerProvider(order.id));

          /// 🗺️ Navigate to map
          context.push(
            "/map",
            extra: {
              "order": order,
              "stop": activeStop,
              "type": activeStop.stopType,
            },
          );
        } catch (e) {
          // ScaffoldMessenger.of(
          //   context,
          // ).showSnackBar(SnackBar(content: Text(e.toString())));

          AppSnackBar.showError(context, e.toString());
        }
      });
    }
    switch (status) {
      // case "confirmed":
      //   return Row(
      //     children: [
      //       Expanded(
      //         child: OutlinedButton(
      //           onPressed: () async {
      //             await ref
      //                 .read(orderActionControllerProvider.notifier)
      //                 .rejectOrder(order.id);

      //             ScaffoldMessenger.of(context).showSnackBar(
      //               const SnackBar(content: Text("Order rejected")),
      //             );

      //             context.pop(); // optional
      //           },
      //           style: OutlinedButton.styleFrom(
      //             foregroundColor: AppColors.electricTeal,
      //             side: const BorderSide(color: AppColors.electricTeal),
      //             padding: const EdgeInsets.symmetric(vertical: 16),
      //           ),
      //           child: const Text("Reject Order"),
      //         ),
      //       ),
      //       const SizedBox(width: 12),
      //       Expanded(
      //         child: mainButton("Accept Order", () async {
      //           // Server ka message return hoga controller se
      //           final msg = await ref
      //               .read(orderActionControllerProvider.notifier)
      //               .acceptOrder(order.id);

      //           // ✅ SnackBar me sirf API response message show karo
      //           ScaffoldMessenger.of(
      //             context,
      //           ).showSnackBar(SnackBar(content: Text(msg)));
      //         }),
      //       ),
      //     ],
      //   );
      case "assigned":

        /// 🔴 OFF DUTY CHECK
        if (isDriverOffDuty()) {
          return mainButton("Start To Picked_Up", () async {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(content: Text("You are currently off duty")),
            // );

            AppSnackBar.showError(context, "You are currently off duty");
          });
        }

        return mainButton("Start To Picked_Up", () async {
          try {
            ref.read(driverLocationTrackerProvider).start();

            final res = await ref
                .read(startOrderControllerProvider.notifier)
                .startOrder(order.id);

            // ScaffoldMessenger.of(
            //   context,
            // ).showSnackBar(SnackBar(content: Text(res.message)));
            AppSnackBar.showSuccess(context, res.message);

            context.push("/map", extra: {"order": order, "type": "pickup"});
          } catch (e) {
            AppSnackBar.showError(context, e.toString());
          }
        });

      case "in_transit":
        return mainButton(
          "Continue Pickup",
          () => context.push("/map", extra: {"order": order, "type": "pickup"}),
        );

      case "picked_up":
        return mainButton(
          "Continue Delivery",
          () =>
              context.push("/map", extra: {"order": order, "type": "delivery"}),
        );
      case "delivered":
      case "completed":
      default:
        return const SizedBox();
    }
  }

  Widget mainButton(String text, Future<void> Function() onTap) {
    return SizedBox(
      width: double.infinity,
      child: ValueListenableBuilder<bool>(
        valueListenable: _isButtonProcessing,
        builder: (context, isProcessing, _) {
          return ElevatedButton(
            onPressed: isProcessing
                ? null
                : () async {
                    _isButtonProcessing.value = true;
                    try {
                      await onTap(); // ✅ IMPORTANT
                    } finally {
                      _isButtonProcessing.value = false;
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.electricTeal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: isProcessing
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(text, style: const TextStyle(fontSize: 16)),
          );
        },
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 ORDER HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _shimmerBox(width: 140, height: 22, radius: 8),
                _shimmerBox(width: 90, height: 28, radius: 20),
              ],
            ),
            const SizedBox(height: 20),

            /// 🔹 CUSTOMER CARD
            _shimmerCard(
              child: Row(
                children: [
                  _shimmerCircle(56),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _shimmerBox(width: 140, height: 16),
                      const SizedBox(height: 8),
                      _shimmerBox(width: 110, height: 14),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 TIMELINE CARD
            _shimmerCard(height: 220),

            const SizedBox(height: 20),

            /// 🔹 PACKAGE CARD
            _shimmerCard(height: 180),

            const SizedBox(height: 20),

            /// 🔹 PAYMENT CARD
            _shimmerCard(height: 150),

            const SizedBox(height: 30),

            /// 🔹 ACTION BUTTON
            _shimmerBox(width: double.infinity, height: 55, radius: 30),
          ],
        ),
      ),
    );
  }

  Widget _shimmerBox({
    double width = double.infinity,
    required double height,
    double radius = 10,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  Widget _shimmerCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _shimmerCard({Widget? child, double? height}) {
    return Container(
      width: double.infinity,
      height: height,
      padding: height == null ? const EdgeInsets.all(16) : null,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
