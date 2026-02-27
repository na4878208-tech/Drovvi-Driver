import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/colors.dart';
import 'earning_model.dart';
import 'earning_controller.dart';
import 'package:intl/intl.dart';

class EarningsScreen extends ConsumerWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= SUMMARY CARD =================
            summaryAsync.when(
              data: (summary) => _summaryCard(summary),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text("Failed to load summary")),
            ),
            const SizedBox(height: 24),

            // ================= RECENT EARNINGS =================
            _sectionTitle("Recent Earnings"),
            earningsAsync.when(
              data: (list) => list.isEmpty
                  ? const Center(child: Text("No earnings yet"))
                  : Column(
                      children: list.map((e) => _earningCard(e)).toList(),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text("Failed to load earnings")),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1C1C1C),
        ),
      ),
    );
  }

  // ================= SUMMARY CARD =================
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
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          _summaryRow("Total Trips", summary.totalTrips.toString()),
          _summaryRow("Base Earnings", "\$${summary.baseEarnings.toStringAsFixed(2)}"),
          _summaryRow("Commission", "\$${summary.commissionEarnings.toStringAsFixed(2)}"),
          _summaryRow("Fuel Allowance", "\$${summary.fuelAllowance.toStringAsFixed(2)}"),
          _summaryRow("Total Earnings", "\$${summary.totalEarnings.toStringAsFixed(2)}",
              isBold: true),
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
          Text(label, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w500)),
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
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
        decoration: BoxDecoration(
          color: isPending ? Colors.orangeAccent : Colors.greenAccent.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          "$label: \$${amount.toStringAsFixed(2)}",
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  // ================= EARNING CARD =================
  Widget _earningCard(EarningModel earning) {
    final dateFormatted = DateFormat("MMM dd, yyyy hh:mm a").format(earning.earnedAt.toLocal());
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
          // Icon for order
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.lightGrayBackground,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.receipt_long, color: AppColors.electricTeal),
          ),
          const SizedBox(width: 16),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Order #${earning.orderNumber}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
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
                  style: const TextStyle(color: AppColors.mediumGray, fontSize: 12),
                ),
              ],
            ),
          ),
          // Status indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: earning.status == "paid" ? Colors.greenAccent.shade400 : Colors.orangeAccent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              earning.status.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
