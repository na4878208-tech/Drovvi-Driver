import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:logisticdriverapp/common_widgets/appbar_widget.dart';
import 'package:logisticdriverapp/constants/bottom_show.dart';
import 'package:logisticdriverapp/constants/colors.dart';
import 'package:logisticdriverapp/features/home/main_screens/my_order_screen/my_order_screen.dart';

import '../../../../common_widgets/custom_button.dart';
import '../my_order_screen/my_order_controller.dart';
import '../my_order_screen/my_order_modal.dart';
import 'home_controller.dart';
import 'home_modal.dart';
import 'package:shimmer/shimmer.dart';

class CurrentScreenShimmer extends StatelessWidget {
  const CurrentScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      body: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _driverHeader(),
              const SizedBox(height: 20),
              _infoCard(),
              const SizedBox(height: 16),
              _infoCard(),
              const SizedBox(height: 16),
              _infoCard(),
              const SizedBox(height: 20),
              _statsSection(),
              const SizedBox(height: 20),
              _ordersSection(),
            ],
          ),
        ),
      ),
    );
  }

  // ================= DRIVER HEADER =================
  Widget _driverHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
      ),
      child: Row(
        children: [
          _circle(56),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _box(width: 160, height: 16),
                const SizedBox(height: 8),
                _box(width: 120, height: 12),
              ],
            ),
          ),
          _box(width: 40, height: 20, radius: 20),
        ],
      ),
    );
  }

  // ================= INFO CARD (Company/Depot/Vehicle) =================
  Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _box(width: 120, height: 18),
          const SizedBox(height: 16),
          ...List.generate(
            4,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  _circle(30),
                  const SizedBox(width: 12),
                  Expanded(child: _box(height: 14)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= STATS SECTION =================
  Widget _statsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _box(width: 140, height: 18),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(child: _statCard()),
            const SizedBox(width: 12),
            Expanded(child: _statCard()),
          ],
        ),
        const SizedBox(height: 16),
        _box(width: 140, height: 18),
        const SizedBox(height: 14),
        _statCard(),
        const SizedBox(height: 16),
        _box(width: 120, height: 18),
        const SizedBox(height: 14),
        _statCard(),
      ],
    );
  }

  Widget _statCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
      ),
      child: Row(
        children: [
          _circle(40),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _box(width: 80, height: 16),
              const SizedBox(height: 6),
              _box(width: 100, height: 12),
            ],
          ),
        ],
      ),
    );
  }

  // ================= ORDERS SECTION =================
  Widget _ordersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _box(width: 160, height: 18),
        const SizedBox(height: 14),
        ...List.generate(2, (index) => _orderCard()),
      ],
    );
  }

  Widget _orderCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _box(width: 120, height: 16),
                _box(width: 70, height: 20, radius: 12),
              ],
            ),
            const SizedBox(height: 10),
            _box(height: 12),
            const SizedBox(height: 8),
            _box(height: 12),
            const SizedBox(height: 12),
            Row(
              children: [
                _box(width: 80, height: 24, radius: 12),
                const SizedBox(width: 8),
                _box(width: 80, height: 24, radius: 12),
              ],
            ),
            const SizedBox(height: 14),
            _box(width: double.infinity, height: 44, radius: 14),
          ],
        ),
      ),
    );
  }

  // ================= COMMON BOX =================
  Widget _box({
    double width = double.infinity,
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

class CurrentScreen extends ConsumerStatefulWidget {
  final int initialTab;
  const CurrentScreen({super.key, this.initialTab = 0});

  @override
  ConsumerState<CurrentScreen> createState() => _CurrentScreenState();
}

class _CurrentScreenState extends ConsumerState<CurrentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int segmentValue = 0;
  bool isOnline = true;
  int selectedOrderTab = 0; // 0 = active, 1 = available, 2 = recent
  final TextEditingController controller = TextEditingController();

  final List<String> orderTabs = [
    "Active Orders",
    "Available Orders",
    "Recent Orders",
  ];

  String formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString).toLocal();
      return DateFormat("dd MMM yyyy • hh:mm a").format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  String numToString(dynamic value) {
    if (value == null) return "0";

    if (value is num) return value.toString();

    if (value is String) return num.tryParse(value)?.toString() ?? "0";

    return "0";
  }

  bool hasActiveRunningOrder(List<OrderModel> orders) {
    return orders.any((order) {
      final status = order.status.toLowerCase();
      return status == "in_transit" || status == "picked_up";
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabController.animateTo(widget.initialTab);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardControllerProvider);

    return dashboardState.when(
      data: (dashboard) => _buildDashboardUI(dashboard!),
      loading: () => const CurrentScreenShimmer(),
      // loading: () =>
      //     const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, st) =>
          Scaffold(body: Center(child: Text("Error: ${err.toString()}"))),
    );
  }

  Widget _buildDashboardUI(DashboardModel dashboard) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.13),
        child: BuyerAppBarWidget(
          controller: controller,
          segmentControlValue: segmentValue,
          segmentCallback: (clickedIndex) {
            setState(() {
              segmentValue = clickedIndex;
              _tabController.animateTo(
                clickedIndex,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            });
          },
          tabController: _tabController,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildTripsList(dashboard), const MyOrdersScreen()],
      ),
    );
  }

  Widget _buildTripsList(DashboardModel dashboard) {
    return RepaintBoundary(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDriverHeaderCard(),
            const SizedBox(height: 20),
            _buildCompanyCard(dashboard.driverInfo.company),
            const SizedBox(height: 16),

            _buildDepotCard(dashboard.driverInfo.depot),
            const SizedBox(height: 16),

            _buildVehicleCard(dashboard.driverInfo.vehicle),
            const SizedBox(height: 20),
            _buildStats(dashboard.stats),
            const SizedBox(height: 20),
            _buildOrderTabDropdown(),
            const SizedBox(height: 12),

            if (selectedOrderTab == 0 && dashboard.activeOrder != null)
              _buildTripCard(dashboard.activeOrder!),

            if (selectedOrderTab == 1) _buildOrderList(dashboard.pendingOrders),

            if (selectedOrderTab == 2)
              _buildRecentOrderList(dashboard.recentOrders),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverHeaderCard() {
    return Consumer(
      builder: (context, ref, _) {
        final dashboardAsync = ref.watch(dashboardControllerProvider);

        return dashboardAsync.when(
          data: (dashboard) {
            final driver = dashboard?.driverInfo;
            if (driver == null) return const SizedBox();

            return Container(
              padding: const EdgeInsets.only(top: 14, left: 6, bottom: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.electricTeal.withOpacity(0.95),
                    AppColors.electricTeal,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.darkText.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _profileWithStatusDot(driver.status),
                  // ✅ reactive dot
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello, ${driver.name} (${driver.status})",
                          style: const TextStyle(
                            color: AppColors.pureWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            _infoBubble(
                              icon: Icons.star,
                              label: driver.rating.toString(),
                              isWhite: true,
                            ),
                            _infoBubble(
                              icon: Icons.badge,
                              label: driver.licenseNumber,
                              isWhite: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _onlineToggleCompact(), // ✅ reactive Switch
                ],
              ),
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (_, __) => const SizedBox(),
        );
      },
    );
  }

  Widget _onlineToggleCompact() {
    return Consumer(
      builder: (context, ref, _) {
        final controller = ref.read(dashboardControllerProvider.notifier);
        final dashboardAsync = ref.watch(dashboardControllerProvider);

        return dashboardAsync.when(
          data: (dashboard) {
            final driver = dashboard?.driverInfo;
            if (driver == null) return const SizedBox();

            final isOnline = driver.status == "available";
            final isOnTrip = driver.status == "on_trip";
            final isSuspended = driver.status == "suspended";

            return Row(
              children: [
                Switch(
                  value: isOnline,
                  activeColor: AppColors.electricTeal,
                  activeTrackColor: AppColors.lightGrayBackground,
                  inactiveTrackColor: AppColors.lightGrayBackground,
                  inactiveThumbColor: AppColors.electricTeal,
                  onChanged:
                      (isOnTrip || isSuspended || controller.isUpdatingStatus)
                      ? null
                      : (value) async {
                          // 🔴 OFF DUTY karne ki attempt ho rahi hai?
                          if (!value) {
                            final ordersAsync = ref.read(
                              myOrdersControllerProvider,
                            );

                            final hasActiveOrder = ordersAsync.maybeWhen(
                              data: (orders) => hasActiveRunningOrder(orders),
                              orElse: () => false,
                            );

                            if (hasActiveOrder) {
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(
                              //     content: Text("Complete your order first"),
                              //     backgroundColor: Colors.red,
                              //   ),
                              // );

                              AppSnackBar.showSuccess(
                                context,
                                "Complete your order first",
                              );

                              return; // ❌ STOP
                            }
                          }

                          try {
                            await controller.toggleAvailability(value);
                          } catch (e) {
                            AppSnackBar.showError(context, e.toString());
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   SnackBar(
                            //     content: Text(e.toString()),
                            //     backgroundColor: Colors.red,
                            //   ),
                            // );
                          }
                        },
                ),
                const SizedBox(width: 3),
              ],
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (_, __) => const SizedBox(),
        );
      },
    );
  }

  Widget _profileWithStatusDot(String status) {
    Color color;

    switch (status) {
      case "available":
        color = Colors.green;
        break;
      case "on_trip":
        color = Colors.orange;
        break;
      default:
        color = Colors.red;
    }

    return Stack(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.pureWhite,
          child: const CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
          ),
        ),
        Positioned(
          bottom: 2,
          right: 2,
          child: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.pureWhite, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoBubble({
    required IconData icon,
    required String label,
    bool isWhite = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isWhite ? AppColors.pureWhite.withOpacity(0.12) : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: isWhite ? AppColors.pureWhite : null),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              color: isWhite ? AppColors.pureWhite : null,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCardWithIcon(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [AppColors.pureWhite, AppColors.pureWhite],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppColors.electricTeal.withOpacity(0.25),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Icon in circular accent background
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.electricTeal.withOpacity(0.2),
                  AppColors.electricTeal.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(icon, color: AppColors.electricTeal, size: 24),
          ),
          const SizedBox(width: 16),
          // Text values
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.electricTeal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.darkText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(Stats stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Today’s Stats",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _buildStatCardWithIcon(
                numToString(stats.today.orders),
                "Trips",
                Icons.directions_car,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCardWithIcon(
                "\R${stats.today.earnings.toString()}",
                "Earned",
                Icons.currency_exchange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          "Weekly Earning",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _buildStatCardWithIcon(
                "\R${numToString(stats.week.earnings)}",
                "Week",
                Icons.calendar_today,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          "Total Trips",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _buildStatCardWithIcon(
                stats.total.completedOrders.toString(),
                "Completed",
                Icons.check_circle,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderTabDropdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          orderTabs[selectedOrderTab],
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            icon: const Icon(Icons.menu),
            items: const [
              DropdownMenuItem(value: 0, child: Text("Active Orders")),
              DropdownMenuItem(value: 1, child: Text("Available Orders")),
              DropdownMenuItem(value: 2, child: Text("Recent Orders")),
            ],
            onChanged: (value) {
              setState(() {
                selectedOrderTab = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _attractiveCard({
    required String title,
    required List<Map<String, dynamic>>
    rows, // [{icon: IconData, text: String, bold: bool}]
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.white, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppColors.electricTeal.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with decorative accent
          Row(
            children: [
              Container(
                width: 6,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.electricTeal,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.electricTeal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Rows with icons
          ...rows.map(
            (r) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.electricTeal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      r['icon'],
                      size: 20,
                      color: AppColors.electricTeal,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      r['text'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: r['bold'] == true
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: AppColors.darkText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ...........Company Card.......
  Widget _buildCompanyCard(Company? company) {
    if (company == null) {
      return _attractiveCard(
        title: "Company",
        rows: [
          {
            'icon': Icons.business,
            'text': "No company assigned",
            'bold': false,
          },
        ],
      );
    }

    List<Map<String, dynamic>> rows = [
      {'icon': Icons.apartment, 'text': company.name, 'bold': true},
    ];

    if (company.tradingName != null) {
      rows.add({
        'icon': Icons.business,
        'text': company.tradingName!,
        'bold': false,
      });
    }

    rows.addAll([
      {'icon': Icons.phone, 'text': company.phone, 'bold': false},
      {'icon': Icons.email, 'text': company.email, 'bold': false},
      {'icon': Icons.category, 'text': "Type: ${company.type}", 'bold': false},
    ]);

    if (company.registrationNumber != null) {
      rows.add({
        'icon': Icons.confirmation_number,
        'text': "Reg: ${company.registrationNumber}",
        'bold': false,
      });
    }

    return _attractiveCard(title: "Company", rows: rows);
  }

  //.........Depots Card........
  Widget _buildDepotCard(Depot? depot) {
    if (depot == null) {
      return _attractiveCard(
        title: "Depot",
        rows: [
          {
            'icon': Icons.location_city,
            'text': "No depot assigned",
            'bold': false,
          },
        ],
      );
    }

    return _attractiveCard(
      title: "Depot",
      rows: [
        {'icon': Icons.location_city, 'text': depot.name, 'bold': true},
        {'icon': Icons.code, 'text': "Code: ${depot.code}", 'bold': false},
        {'icon': Icons.location_on, 'text': depot.address, 'bold': false},
        {
          'icon': Icons.map,
          'text': "${depot.city}, ${depot.state}",
          'bold': false,
        },
        {'icon': Icons.person, 'text': depot.contactPerson, 'bold': false},
        {'icon': Icons.phone, 'text': depot.contactPhone, 'bold': false},
      ],
    );
  }

  //.................Vehical Card......
  Widget _buildVehicleCard(Vehicle? vehicle) {
    if (vehicle == null) {
      return _attractiveCard(
        title: "Vehicle",
        rows: [
          {
            'icon': Icons.local_shipping,
            'text': "No vehicle assigned",
            'bold': false,
          },
        ],
      );
    }

    return _attractiveCard(
      title: "Vehicle",
      rows: [
        {
          'icon': Icons.local_shipping,
          'text': vehicle.vehicleType,
          'bold': true,
        },
        {
          'icon': Icons.confirmation_number,
          'text': "Registration: ${vehicle.registrationNumber}",
          'bold': false,
        },
        {
          'icon': Icons.branding_watermark,
          'text': "${vehicle.make} ${vehicle.model}",
          'bold': false,
        },
        {
          'icon': Icons.scale,
          'text': "Capacity: ${vehicle.capacityWeight} kg",
          'bold': false,
        },
        {
          'icon': Icons.fitness_center,
          'text': "Max Tons: ${vehicle.maxWeightTons}",
          'bold': false,
        },
      ],
    );
  }

  // ........... Available Orders.........
  Widget _buildOrderList(List<Order> listToShow) {
    final limitedList = listToShow.take(3).toList();

    if (limitedList.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 20),
        child: Text(
          "No orders available",
          style: TextStyle(color: AppColors.mediumGray),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: limitedList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final trip = limitedList[index];
        return _buildTripCard(trip);
      },
    );
  }

  // ............. Recent Orders.............
  Widget _buildRecentOrderList(List<RecentOrder> orders) {
    if (orders.isEmpty) {
      return const Text(
        "No recent orders",
        style: TextStyle(color: AppColors.mediumGray),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orders.length.clamp(0, 3),
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final r = orders[index];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: _cardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${r.orderNumber}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.electricTeal,
                ),
              ),
              const SizedBox(height: 6),
              _iconText(Icons.qr_code, "Tracking: ${r.trackingCode}"),
              const SizedBox(height: 6),
              _iconText(Icons.location_on, "Delivery: ${r.deliveryAddress}"),
              const SizedBox(height: 6),
              _iconText(
                Icons.currency_exchange,
                "Earning: ${r.earning.toString()} R",
              ),
              const SizedBox(height: 6),
              if (r.completedAt != null)
                _iconText(
                  Icons.check_circle,
                  "Completed: ${formatDate(r.completedAt!)}",
                ),
            ],
          ),
        );
      },
    );
  }

  // main cards
  Widget _buildTripCard(Order trip) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [AppColors.pureWhite, AppColors.pureWhite],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppColors.electricTeal.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Order Number + Earnings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                trip.orderNumber,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.electricTeal,
                ),
              ),
              _earningChip(trip.finalCost),
            ],
          ),
          const SizedBox(height: 8),
          // Tracking + Payment
          _iconText(Icons.qr_code, "Tracking: ${trip.trackingCode}"),
          _iconText(Icons.payment, "Payment: ${trip.paymentStatus}"),
          const SizedBox(height: 10),
          // Customer info
          _iconText(
            Icons.person,
            "${trip.customerName} (${trip.customerPhone})",
            bold: true,
          ),
          const SizedBox(height: 10),
          // Stops / Addresses
          if (trip.stops.isEmpty) ...[
            _iconText(Icons.upload, "Pickup: ${trip.pickupAddress}"),
            _iconText(Icons.download, "Drop: ${trip.deliveryAddress}"),
          ],
          ...trip.stops.map(
            (s) => _iconText(
              s.stopType == "pickup"
                  ? Icons.local_shipping_outlined
                  : Icons.location_on_outlined,
              "${s.sequenceNumber}. ${s.address} (${s.status})",
            ),
          ),
          const SizedBox(height: 12),
          // Badges row: weight, distance, stops
          Row(
            children: [
              _attractiveBadge("Weight: ${trip.totalWeight} kg"),
              const SizedBox(width: 8),
              _attractiveBadge("Distance: ${trip.distanceKm} km"),
              const SizedBox(width: 8),
              if (trip.isMultiStop)
                _attractiveBadge("${trip.stopsCount} Stops"),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          // View Details Button
          Center(
            child: CustomButton(
              text: "View Details",
              backgroundColor: AppColors.electricTeal,
              borderColor: AppColors.electricTeal,
              textColor: AppColors.lightGrayBackground,
              onPressed: () => context.push('/order-details', extra: trip.id),
            ),
          ),
        ],
      ),
    );
  }

  // Attractive badge design
  Widget _attractiveBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            AppColors.electricTeal.withOpacity(0.15),
            AppColors.electricTeal.withOpacity(0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppColors.electricTeal.withOpacity(0.2),
          width: 1.2,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: AppColors.electricTeal,
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: AppColors.pureWhite,
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: AppColors.lightBorder),
  );

  Widget _earningChip(num amount) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: AppColors.electricTeal.withOpacity(0.12),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      "\R${amount.toStringAsFixed(2)}",
      style: const TextStyle(
        color: AppColors.electricTeal,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  Widget _iconText(
    IconData icon,
    String text, {
    bool bold = false,
    bool small = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: small ? 14 : 18, color: AppColors.electricTeal),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: small ? 12 : 13,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
