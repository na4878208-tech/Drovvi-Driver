import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logisticdriverapp/export.dart';
import '../features/home/main_screens/home_screen/home_modal.dart';
import '../features/home/main_screens/home_screen/home_controller.dart';

class BuyerAppBarWidget extends ConsumerWidget implements PreferredSizeWidget {
  final DriverInfo? driver; // optional driver
  final TextEditingController controller;
  final int segmentControlValue;
  final TabController tabController;
  final void Function(int) segmentCallback;

  const BuyerAppBarWidget({
    super.key,
    this.driver,
    required this.controller,
    required this.segmentControlValue,
    required this.segmentCallback,
    required this.tabController,
  });

  @override
  Size get preferredSize => const Size.fromHeight(160);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use the driver passed in OR get from dashboard state
    final dashboardState = ref.watch(dashboardControllerProvider);
    DriverInfo? currentDriver = driver;

    dashboardState.whenData((data) {
      currentDriver ??= data?.driverInfo;
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: AppBar(
        backgroundColor: AppColors.electricTeal,
        toolbarHeight: preferredSize.height,
        elevation: 0,
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Greeting + Notification
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  txt: "Hello, ${currentDriver?.name ?? 'Driver'}",
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                IconButton(
                  onPressed: () {
                    context.push("/notifications");
                  },
                  icon: const Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // TabBar
            SizedBox(
              height: 50,
              child: TabBar(
                controller: tabController,
                indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(width: 4.0, color: Colors.white),
                  insets: EdgeInsets.symmetric(horizontal: 16.0),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(text: "Home"),
                  Tab(text: "My Orders"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
