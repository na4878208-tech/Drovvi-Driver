// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../constants/colors.dart';
// import 'earning_model.dart';
// import 'earning_controller.dart';
// import 'package:intl/intl.dart';

// import 'package:shimmer/shimmer.dart';

// class EarningsShimmer extends StatelessWidget {
//   const EarningsShimmer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _summaryShimmer(),
//           const SizedBox(height: 24),
//           _sectionTitleShimmer(),
//           const SizedBox(height: 12),
//           ...List.generate(4, (index) => _earningCardShimmer()),
//         ],
//       ),
//     );
//   }

//   Widget _summaryShimmer() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey.shade300,
//       highlightColor: Colors.grey.shade100,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _box(height: 20, width: 120),
//             const SizedBox(height: 20),
//             ...List.generate(
//               5,
//               (index) => Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _box(height: 14, width: 100),
//                     _box(height: 14, width: 60),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 _box(height: 28, width: 100, radius: 12),
//                 const SizedBox(width: 8),
//                 _box(height: 28, width: 100, radius: 12),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _sectionTitleShimmer() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey.shade300,
//       highlightColor: Colors.grey.shade100,
//       child: _box(height: 22, width: 160),
//     );
//   }

//   Widget _earningCardShimmer() {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Shimmer.fromColors(
//         baseColor: Colors.grey.shade300,
//         highlightColor: Colors.grey.shade100,
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(18),
//           ),
//           child: Row(
//             children: [
//               _box(height: 48, width: 48, radius: 24),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _box(height: 14, width: 120),
//                     const SizedBox(height: 8),
//                     _box(height: 14, width: 80),
//                     const SizedBox(height: 8),
//                     _box(height: 12, width: 160),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 8),
//               _box(height: 24, width: 60, radius: 8),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _box({
//     required double height,
//     required double width,
//     double radius = 6,
//   }) {
//     return Container(
//       height: height,
//       width: width,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(radius),
//       ),
//     );
//   }
// }

// class EarningsScreen extends ConsumerWidget {
//   const EarningsScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final earningsAsync = ref.watch(earningsControllerProvider);
//     final summaryAsync = ref.watch(earningsSummaryControllerProvider);

//     return Scaffold(
//       backgroundColor: AppColors.lightGrayBackground,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Text(
//           "Earnings",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         backgroundColor: AppColors.electricTeal,
//         foregroundColor: AppColors.pureWhite,
//         elevation: 0,
//       ),

//       body: earningsAsync.isLoading || summaryAsync.isLoading
//           ? const EarningsShimmer()
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   summaryAsync.when(
//                     data: (summary) => _summaryCard(summary),
//                     loading: () => const SizedBox(),
//                     error: (e, st) => const Text("Failed to load summary"),
//                   ),
//                   const SizedBox(height: 24),
//                   _sectionTitle("Recent Earnings"),
//                   earningsAsync.when(
//                     data: (list) => list.isEmpty
//                         ? const Center(child: Text("No earnings yet"))
//                         : Column(
//                             children: list.map((e) => _earningCard(e)).toList(),
//                           ),
//                     loading: () => const SizedBox(),
//                     error: (e, st) => const Text("Failed to load earnings"),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _sectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//           color: Color(0xFF1C1C1C),
//         ),
//       ),
//     );
//   }

//   // ================= SUMMARY CARD =================
//   Widget _summaryCard(EarningSummary summary) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [AppColors.electricTeal, AppColors.electricTeal],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12.withOpacity(0.15),
//             blurRadius: 12,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "This Month",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 16),
//           _summaryRow("Total Trips", summary.totalTrips.toString()),
//           _summaryRow(
//             "Base Earnings",
//             "\$${summary.baseEarnings.toStringAsFixed(2)}",
//           ),
//           _summaryRow(
//             "Commission",
//             "\$${summary.commissionEarnings.toStringAsFixed(2)}",
//           ),
//           _summaryRow(
//             "Fuel Allowance",
//             "\$${summary.fuelAllowance.toStringAsFixed(2)}",
//           ),
//           _summaryRow(
//             "Total Earnings",
//             "\$${summary.totalEarnings.toStringAsFixed(2)}",
//             isBold: true,
//           ),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               _statusBadge("Paid", summary.paidAmount),
//               const SizedBox(width: 8),
//               _statusBadge("Pending", summary.pendingAmount, isPending: true),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _summaryRow(String label, String value, {bool isBold = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(
//               color: Colors.white70,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
//               color: Colors.white,
//               fontSize: isBold ? 16 : 14,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _statusBadge(String label, double amount, {bool isPending = false}) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 15),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
//         decoration: BoxDecoration(
//           color: isPending ? Colors.orangeAccent : Colors.greenAccent.shade400,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Text(
//           "$label: \$${amount.toStringAsFixed(2)}",
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }

//   // ================= EARNING CARD =================
//   Widget _earningCard(EarningModel earning) {
//     final dateFormatted = DateFormat(
//       "MMM dd, yyyy hh:mm a",
//     ).format(earning.earnedAt.toLocal());
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.pureWhite,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12.withOpacity(0.06),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           // Icon for order
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: AppColors.lightGrayBackground,
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.receipt_long,
//               color: AppColors.electricTeal,
//             ),
//           ),
//           const SizedBox(width: 16),
//           // Details
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Order #${earning.orderNumber}",
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   "Earnings: \$${earning.totalEarnings.toStringAsFixed(2)}",
//                   style: const TextStyle(
//                     color: AppColors.electricTeal,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 15,
//                   ),
//                 ),
//                 const SizedBox(height: 4),

//                 Text(
//                   "Earned at: $dateFormatted",
//                   style: const TextStyle(
//                     color: AppColors.mediumGray,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Status indicator
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             decoration: BoxDecoration(
//               color: earning.status == "paid"
//                   ? Colors.greenAccent.shade400
//                   : Colors.orangeAccent,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Text(
//               earning.status.toUpperCase(),
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//                 fontSize: 12,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/colors.dart';
import 'earning_model.dart';
import 'earning_controller.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

// ---------------- SHIMMER WIDGET ----------------
class EarningsShimmer extends StatelessWidget {
  const EarningsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _summaryShimmer(),
          const SizedBox(height: 24),
          _sectionTitleShimmer(),
          const SizedBox(height: 12),
          ...List.generate(4, (index) => _earningCardShimmer()),
        ],
      ),
    );
  }

  Widget _summaryShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _box(height: 20, width: 120),
            const SizedBox(height: 20),
            ...List.generate(
              5,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _box(height: 14, width: 100),
                    _box(height: 14, width: 60),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _box(height: 28, width: 100, radius: 12),
                const SizedBox(width: 8),
                _box(height: 28, width: 100, radius: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitleShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: _box(height: 22, width: 160),
    );
  }

  Widget _earningCardShimmer() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              _box(height: 48, width: 48, radius: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _box(height: 14, width: 120),
                    const SizedBox(height: 8),
                    _box(height: 14, width: 80),
                    const SizedBox(height: 8),
                    _box(height: 12, width: 160),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _box(height: 24, width: 60, radius: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _box({
    required double height,
    required double width,
    double radius = 6,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

// ---------------- EARNINGS SCREEN ----------------
class EarningsScreen extends ConsumerStatefulWidget {
  const EarningsScreen({super.key});

  @override
  ConsumerState<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends ConsumerState<EarningsScreen> {
  String selectedPeriod = "week";
  int limit = 10;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  void _fetchData() {
    ref
        .read(earningsControllerProvider.notifier)
        .fetchEarnings(period: selectedPeriod);
    ref
        .read(earningsSummaryControllerProvider.notifier)
        .fetchSummary(period: selectedPeriod);
  }

  void _loadMore() {
    setState(() {
      limit += 10;
    });
  }

  void _onFilterChanged(String period) {
    setState(() {
      selectedPeriod = period;
    });
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final earningsAsync = ref.watch(earningsControllerProvider);
    final summaryAsync = ref.watch(earningsSummaryControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Earnings",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.electricTeal,
        foregroundColor: AppColors.pureWhite,
        elevation: 0,
      ),
      body: summaryAsync.isLoading && earningsAsync.isLoading
          ? const EarningsShimmer()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  summaryAsync.when(
                    data: (summary) => _summaryCard(summary),
                    loading: () => const SizedBox(),
                    error: (e, st) => const Text("Failed to load summary"),
                  ),
                  const SizedBox(height: 24),
                  _sectionTitleWithFilter(),
                  const SizedBox(height: 12),
                  earningsAsync.when(
                    data: (list) {
                      if (list.isEmpty)
                        return const Center(child: Text("No earnings yet"));
                      final visibleList = list.take(limit).toList();
                      return Column(
                        children: [
                          ...visibleList.map((e) => _earningCard(e)).toList(),
                          if (list.length > limit)
                            TextButton(
                              onPressed: _loadMore,
                              child: const Text("Show More"),
                            ),
                        ],
                      );
                    },
                    loading: () => const SizedBox(),
                    error: (e, st) => const Text("Failed to load earnings"),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _sectionTitleWithFilter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Recent Earnings",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1C1C1C),
          ),
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedPeriod,
            icon: const Icon(Icons.arrow_drop_down),
            items: const [
              DropdownMenuItem(value: "today", child: Text("Today")),
              DropdownMenuItem(value: "week", child: Text("Week")),
              DropdownMenuItem(value: "month", child: Text("Month")),
              DropdownMenuItem(value: "all", child: Text("All")),
            ],
            onChanged: (value) {
              if (value != null) {
                _onFilterChanged(value);
              }
            },
          ),
        ),
      ],
    );
  }

  // ---------------- SUMMARY CARD ----------------
  Widget _summaryCard(EarningSummary summary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.electricTeal, AppColors.electricTeal],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "This Month",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _summaryRow("Total Trips", summary.totalTrips.toString()),
          _summaryRow(
            "Base Earnings",
            "\$${summary.baseEarnings.toStringAsFixed(2)}",
          ),
          _summaryRow(
            "Commission",
            "\$${summary.commissionEarnings.toStringAsFixed(2)}",
          ),
          _summaryRow(
            "Fuel Allowance",
            "\$${summary.fuelAllowance.toStringAsFixed(2)}",
          ),
          _summaryRow(
            "Total Earnings",
            "\$${summary.totalEarnings.toStringAsFixed(2)}",
            isBold: true,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _statusBadge("Paid", summary.paidAmount),
              const SizedBox(width: 8),
              _statusBadge("Pending", summary.pendingAmount, isPending: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: Colors.white,
              fontSize: isBold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String label, double amount, {bool isPending = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
          color: isPending ? Colors.orangeAccent : Colors.greenAccent.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          "$label: \$${amount.toStringAsFixed(2)}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // ---------------- EARNING CARD ----------------
  Widget _earningCard(EarningModel earning) {
    final dateFormatted = DateFormat(
      "MMM dd, yyyy hh:mm a",
    ).format(earning.earnedAt.toLocal());
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.lightGrayBackground,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long,
              color: AppColors.electricTeal,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Order #${earning.orderNumber}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "Earnings: \$${earning.totalEarnings.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: AppColors.electricTeal,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Earned at: $dateFormatted",
                  style: const TextStyle(
                    color: AppColors.mediumGray,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: earning.status == "paid"
                  ? Colors.greenAccent.shade400
                  : Colors.orangeAccent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              earning.status.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
