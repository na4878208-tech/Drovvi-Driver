import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../constants/local_storage.dart';
import '../../../../../export.dart';
import '../../../order_details_screen/order_detail_modal.dart';
import 'skip_stop_controller.dart';
import 'skip_stop_model.dart';

class SkipStopScreen extends ConsumerStatefulWidget {
  final int orderId;
  final OrderStop stop;

  const SkipStopScreen({super.key, required this.orderId, required this.stop});

  @override
  ConsumerState<SkipStopScreen> createState() => _SkipStopScreenState();
}

class _SkipStopScreenState extends ConsumerState<SkipStopScreen> {
  final TextEditingController reasonCtrl = TextEditingController();
  final FocusNode reasonFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    reasonCtrl.addListener(() => setState(() {}));

    // ✅ Schedule async fetch after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchSkipStatus();
    });
  }

  Future<void> _fetchSkipStatus() async {
    try {
      final token = await LocalStorage.getToken();

      if (token == null || token.isEmpty) {
        // Token missing, handle login or error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Authorization token not found")),
        );
        return;
      }

      await ref
          .read(skipStopControllerProvider.notifier)
          .fetchSkipStatus(orderId: widget.orderId, stopId: widget.stop.id);
    } catch (e) {
      debugPrint("Error fetching skip status: $e");
    }
  }

  @override
  void dispose() {
    reasonCtrl.dispose();
    reasonFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(skipStopControllerProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "Skip Stop Request",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.electricTeal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (res) {
          if (res.data != null) {
            return _statusCard(res.data!);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔹 Stop Info Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.grey.shade50],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.electricTeal.withOpacity(0.15),
                        blurRadius: 2,
                        spreadRadius: 2,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00BFA6), Color(0xFF00D9C0)],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            "${widget.stop.sequenceNumber}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.stop.stopType.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.stop.address,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                const Text(
                  "Reason for Skipping",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),

                const SizedBox(height: 10),

                /// 🔹 Reason Field
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.08),
                        blurRadius: 15,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: reasonCtrl,
                    focusNode: reasonFocus,
                    maxLines: 4,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Minimum 10 characters required...",
                      prefixIcon: const Icon(Icons.edit_note),
                      prefixIconColor: AppColors.electricTeal,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomButton(
                    text: "Skip this Stop",
                    backgroundColor: reasonCtrl.text.trim().length < 10
                        ? AppColors.lightGrayBackground
                        : AppColors.electricTeal,
                    borderColor: AppColors.electricTeal,
                    textColor: reasonCtrl.text.trim().length < 10
                        ? AppColors.electricTeal
                        : Colors.white,
                    onPressed: reasonCtrl.text.trim().length < 10
                        ? null
                        : () {
                            ref
                                .read(skipStopControllerProvider.notifier)
                                .requestSkip(
                                  orderId: widget.orderId,
                                  stopId: widget.stop.id,
                                  reason: reasonCtrl.text.trim(),
                                );
                          },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statusCard(SkipStopData data) {
    late List<Color> gradientColors;
    late IconData icon;

    switch (data.status.toLowerCase()) {
      case "approved":
        gradientColors = [const Color(0xFF00C853), const Color(0xFF69F0AE)];
        icon = Icons.check_rounded;
        break;
      case "rejected":
        gradientColors = [const Color(0xFFD50000), const Color(0xFFFF5252)];
        icon = Icons.close_rounded;
        break;
      default:
        gradientColors = [const Color(0xFFFFA000), const Color(0xFFFFD54F)];
        icon = Icons.hourglass_top_rounded;
    }

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// 🔹 Icon Circle
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: gradientColors),
                boxShadow: [
                  BoxShadow(
                    color: gradientColors.first.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 45),
            ),

            const SizedBox(height: 25),

            /// 🔹 Status Text
            Text(
              data.status.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                letterSpacing: 1.2,
                color: gradientColors.first,
              ),
            ),

            const SizedBox(height: 30),

            /// 🔹 Info Container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.lightGrayBackground,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _modernInfoTile("Reason", data.reason),
                  if (data.adminNotes != null && data.adminNotes!.isNotEmpty)
                    _modernInfoTile("Admin Notes", data.adminNotes!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _modernInfoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
