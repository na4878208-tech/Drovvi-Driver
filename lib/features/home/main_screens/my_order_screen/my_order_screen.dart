import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:logisticdriverapp/constants/bottom_show.dart';

import 'my_order_controller.dart';
import 'my_order_modal.dart';
import '../../../../export.dart'; 
import 'package:shimmer/shimmer.dart';

class MyOrdersShimmer extends StatelessWidget {
  const MyOrdersShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // _filterShimmer(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: 5,
            itemBuilder: (_, __) => _orderCardShimmer(),
          ),
        ),
      ],
    );
  }

  // Widget _filterShimmer() {
  //   return SizedBox(
  //     height: 60,
  //     child: ListView.separated(
  //       padding: const EdgeInsets.all(12),
  //       scrollDirection: Axis.horizontal,
  //       itemBuilder: (_, __) => Shimmer.fromColors(
  //         baseColor: Colors.grey.shade300,
  //         highlightColor: Colors.grey.shade100,
  //         child: Container(
  //           width: 80,
  //           height: 36,
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(20),
  //           ),
  //         ),
  //       ),
  //       separatorBuilder: (_, __) => const SizedBox(width: 8),
  //       itemCount: 6,
  //     ),
  //   );
  // }

  Widget _orderCardShimmer() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _box(width: 120, height: 16),
                  _box(width: 70, height: 20, radius: 20),
                ],
              ),

              const SizedBox(height: 12),

              /// Customer & Product
              Row(
                children: [
                  _circle(26),
                  const SizedBox(width: 6),
                  _box(width: 100, height: 14),
                  const Spacer(),
                  _circle(26),
                  const SizedBox(width: 6),
                  _box(width: 80, height: 14),
                ],
              ),

              const SizedBox(height: 10),

              /// Meta Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  4,
                  (index) => _box(width: 60, height: 12),
                ),
              ),

              const SizedBox(height: 16),

              /// Price & Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _box(width: 80, height: 18),
                  _box(width: 110, height: 12),
                ],
              ),

              const SizedBox(height: 14),

              /// Button
              _box(width: double.infinity, height: 44, radius: 14),
            ],
          ),
        ),
      ),
    );
  }

  Widget _box({
    required double width,
    required double height,
    double radius = 6,
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

  Widget _circle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

class MyOrdersScreen extends ConsumerStatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  ConsumerState<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends ConsumerState<MyOrdersScreen> {
  late final ScrollController _scrollController;

  final List<String> _statusFilters = [
    'All',
    'Assigned',
    'In_Transit',
    'Picked_up',
    'Completed',
    'Cancelled',
  ];
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(myOrdersControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: orderState.when(
              data: (orders) {
                final filteredOrders = _filterOrders(orders);
                if (filteredOrders.isEmpty) return _buildEmptyState();
                return RefreshIndicator(
                  onRefresh: () async {
                    await ref
                        .read(myOrdersControllerProvider.notifier)
                        .fetchMyOrders();
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return _buildOrderCard(order);
                    },
                  ),
                );
              },
              // loading: () => _buildLoadingState(),
              loading: () => const MyOrdersShimmer(),
              error: (err, st) => _buildErrorState(err.toString()),
            ),
          ),
        ],
      ),
    );
  }

  // ================= Filter Chips =================
  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: _statusFilters.map((filter) {
          bool isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: CustomText(
                txt: filter,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppColors.pureWhite
                    : AppColors.electricTeal,
              ),
              selected: isSelected,
              selectedColor: AppColors.electricTeal,
              backgroundColor: AppColors.lightGrayBackground,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: AppColors.electricTeal),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }

  // ================= Loading State =================
  // Widget _buildLoadingState() {
  //   return ListView.builder(
  //     padding: const EdgeInsets.all(12),
  //     itemCount: 5,
  //     itemBuilder: (_, __) => Container(
  //       margin: const EdgeInsets.only(bottom: 12),
  //       padding: const EdgeInsets.all(16),
  //       decoration: BoxDecoration(
  //         color: AppColors.pureWhite,
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       child: Column(
  //         children: [
  //           Row(
  //             children: [
  //               Container(
  //                 width: 60,
  //                 height: 20,
  //                 color: AppColors.mediumGray.withOpacity(0.2),
  //               ),
  //               const Spacer(),
  //               Container(
  //                 width: 80,
  //                 height: 20,
  //                 color: AppColors.mediumGray.withOpacity(0.2),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 12),
  //           Row(
  //             children: [
  //               Container(
  //                 width: 100,
  //                 height: 16,
  //                 color: AppColors.mediumGray.withOpacity(0.2),
  //               ),
  //               const Spacer(),
  //               Container(
  //                 width: 60,
  //                 height: 16,
  //                 color: AppColors.mediumGray.withOpacity(0.2),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // ================= Error State =================
  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: AppColors.mediumGray),
          const SizedBox(height: 16),
          CustomText(
            txt: "Oops! Something went wrong",
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 8),
          CustomText(
            txt: error,
            fontSize: 14,
            color: AppColors.mediumGray,
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ================= Empty State =================
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 80,
            color: AppColors.mediumGray.withOpacity(0.5),
          ),
          const SizedBox(height: 20),
          CustomText(
            txt: "No orders found",
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 8),
          CustomText(
            txt: _selectedFilter == 'All'
                ? "You haven't placed any orders yet"
                : "No ${_selectedFilter.toLowerCase()} orders",
            fontSize: 14,
            color: AppColors.mediumGray,
          ),
        ],
      ),
    );
  }

  // ================= Order Card =================
  Widget _buildOrderCard(OrderModel order) {
    final formattedDate = DateFormat(
      'dd MMM yyyy • hh:mm a',
    ).format(order.createdAt);
    final statusColor = _getStatusColor(order.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ───────── HEADER ─────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.orderNumber,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              _statusChip(order.status, statusColor),
            ],
          ),

          const SizedBox(height: 10),

          /// ───────── CUSTOMER & PRODUCT ─────────
          Row(
            children: [
              _iconBadge(Icons.person),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  order.customerName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _iconBadge(Icons.shopping_bag),
              const SizedBox(width: 6),
              Text(
                order.items.isNotEmpty ? order.items.first.productName : '-',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// ───────── META INFO ─────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _miniInfo(Icons.layers, "${order.totalItems} items"),
              _miniInfo(Icons.monitor_weight, "${order.totalWeight} Kg"),
              _miniInfo(Icons.local_shipping, order.serviceType),
              _miniInfo(Icons.location_on, "Stop ${order.stopsCount}"),
            ],
          ),

          const SizedBox(height: 14),

          /// ───────── ROUTE CARD ─────────
          // Container(
          //   padding: const EdgeInsets.symmetric(vertical: 12),
          //   decoration: BoxDecoration(
          //     color: AppColors.electricTeal.withOpacity(0.06),
          //     borderRadius: BorderRadius.circular(14),
          //   ),
          //   child: Center(
          //     child: order.isMultiStop
          //         ? _multiStopTimeline(order.stops)
          //         : _singleTimeline(order),
          //   ),
          // ),

          // const SizedBox(height: 14),

          /// ───────── PRICE & DATE ─────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "R ${order.finalCost}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.electricTeal,
                ),
              ),
              Text(
                formattedDate,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// ───────── CTA BUTTON ─────────
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.electricTeal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                final id = order.id;

                if (id == 0) {
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(content: Text("Invalid order ID")),
                  // );

                  AppSnackBar.showError(context, "Invalid order ID");
                  return;
                }

                context.push('/order-details', extra: id);
              },
              child: const Text(
                "View Details",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= Info Row =================
  Widget _iconBadge(IconData icon) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: AppColors.electricTeal.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 14, color: AppColors.electricTeal),
    );
  }

  Widget _miniInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.electricTeal),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  // ================= Status Chip =================
  Widget _statusChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  // ================= Filter Helper =================
  List<OrderModel> _filterOrders(List<OrderModel> orders) {
    if (_selectedFilter == 'All') return orders;
    return orders
        .where(
          (order) =>
              order.status.toLowerCase() == _selectedFilter.toLowerCase(),
        )
        .toList();
  }

  // ================= Status Color =================
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'active':
        return Colors.orange;
      case 'pending':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return AppColors.mediumGray;
    }
  }
}
