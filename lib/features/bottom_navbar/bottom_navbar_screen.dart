import 'package:flutter/material.dart';
import 'package:logisticdriverapp/constants/colors.dart';
import 'package:logisticdriverapp/features/home/Earning/earning_screen.dart';
import 'package:logisticdriverapp/features/home/main_screens/home_screen/home_screen.dart';
import 'package:logisticdriverapp/features/home/Profile/get_profile/get_profile_screen.dart';
import 'package:logisticdriverapp/features/home/order_details_screen/order_detail_screen.dart';

class TripsBottomNavBarScreen extends StatefulWidget {
  final int initialIndex;
  final int? orderId; // Optional order ID

  const TripsBottomNavBarScreen({
    super.key,
    this.initialIndex = 0,
    this.orderId,
  });

  @override
  State<TripsBottomNavBarScreen> createState() =>
      _TripsBottomNavBarScreenState();
}

class _TripsBottomNavBarScreenState extends State<TripsBottomNavBarScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  /// Screens list
  List<Widget> getScreens() {
    return [
      const CurrentScreen(),
      // Pass orderId safely; if null, show a placeholder or message
      widget.orderId != null
          ? OrderDetailsScreen(orderId: widget.orderId!)
          : const Center(
              child: Text("No order selected", style: TextStyle(fontSize: 16)),
            ),
      const EarningsScreen(),
      const GetProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getScreens()[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 8,
        currentIndex: _selectedIndex,
        backgroundColor: AppColors.pureWhite,
        selectedItemColor: AppColors.electricTeal,
        unselectedItemColor: AppColors.mediumGray,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: "Order Details",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on_outlined),
            label: "Earning",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
