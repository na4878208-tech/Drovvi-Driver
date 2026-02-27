import 'package:flutter/material.dart';
import '../../../export.dart';
import 'order_detail_modal.dart';

class OrderTrackingScreen extends StatefulWidget {
  final OrderModel order;

  const OrderTrackingScreen({super.key, required this.order});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "assigned":
        return Colors.orange;
      case "picked":
      case "picked up":
        return Colors.blue;
      case "in transit":
        return Colors.purple;
      case "delivered":
        return Colors.green;
      case "cancelled":
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case "assigned":
        return Icons.assignment;
      case "picked":
      case "picked up":
        return Icons.inventory_2;
      case "in transit":
        return Icons.local_shipping;
      case "delivered":
        return Icons.check_circle;
      case "cancelled":
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final trackingList = widget.order.tracking;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tracking History",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.electricTeal,
        foregroundColor: AppColors.pureWhite,
        elevation: 0,
      ),
      body: trackingList.isEmpty
          ? const Center(
              child: Text(
                "No tracking history available",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: trackingList.length,
              itemBuilder: (context, index) {
                final map = trackingList[index] as Map<String, dynamic>;
                final status = map['status'] ?? 'Unknown';
                final time = map['time'] ?? '';
                final color = _getStatusColor(status);

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Timeline Line + Icon
                    Column(
                      children: [
                        Container(
                          width: 2,
                          height: 20,
                          color: index == 0
                              ? Colors.transparent
                              : Colors.grey.shade300,
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getStatusIcon(status),
                            color: color,
                            size: 20,
                          ),
                        ),
                        Container(
                          width: 2,
                          height: 60,
                          color: index == trackingList.length - 1
                              ? Colors.transparent
                              : Colors.grey.shade300,
                        ),
                      ],
                    ),

                    const SizedBox(width: 16),

                    /// Status Card
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              status,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              time,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
