import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logisticdriverapp/export.dart';
import 'package:logisticdriverapp/features/home/Profile/get_profile/profile_controller.dart';
import 'package:logisticdriverapp/features/home/Profile/get_profile/profile_model.dart';

class GetProfileScreen extends ConsumerStatefulWidget {
  const GetProfileScreen({super.key});

  @override
  ConsumerState<GetProfileScreen> createState() => _GetProfileScreenState();
}

class _GetProfileScreenState extends ConsumerState<GetProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);
    final Color blueColor = AppColors.electricTeal;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: AppColors.pureWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: blueColor,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(
              onPressed: () {
                context.go("/settings");
              },
              icon: const Icon(
                Icons.settings,
                color: AppColors.pureWhite,
                size: 28,
              ),
            ),
          ),
        ],
      ),
      body: profileState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: ${e.toString()}")),
        data: (profileResponse) {
          final user = profileResponse.data.user;
          final driver = profileResponse.data.driver;
          final vehicle = profileResponse.data.vehicle;
          final stats = profileResponse.data.stats;

          return Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(height: 150, color: blueColor),

                    Positioned(
                      top: screenHeight * 0.1,
                      left: 20,
                      right: 20,
                      bottom: 45,
                      child: _buildInfoCard(
                        user: user,
                        driver: driver,
                        vehicle: vehicle,
                        stats: stats,
                      ),
                    ),

                    Positioned(
                      top: 10,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          _buildProfileImage(context, blueColor),
                          const SizedBox(height: 15),
                          Text(
                            user.name,
                            style: const TextStyle(
                              color: AppColors.darkText,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            width: 300,
                            margin: const EdgeInsets.only(top: 8),
                            height: 1,
                            color: AppColors.electricTeal,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- Profile Image Widget ---
  Widget _buildProfileImage(context, Color primaryBlue) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        const CircleAvatar(radius: 60, backgroundColor: AppColors.subtleGray),
        Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            color: primaryBlue,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.pureWhite, width: 2),
          ),
          child: IconButton(
            onPressed: () => GoRouter.of(context).go("/edit-profile"),
            icon: const Icon(Icons.edit, color: AppColors.pureWhite),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required User user,
    required Driver driver,
    required Vehicle vehicle,
    required Stats stats,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(25, 110, 25, 40),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= STATS =================
            const Text(
              'Status',
              style: TextStyle(
                color: AppColors.electricTeal,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildStatsRow(stats),

            const SizedBox(height: 25),

            /// ================= USER INFO =================
            const Text(
              'User Information',
              style: TextStyle(
                color: AppColors.electricTeal,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            _buildDoubleInfoRow(
              label1: "Name",
              value1: user.name,
              label2: "Email",
              value2: user.email,
            ),
            const SizedBox(height: 5),

            _buildDoubleInfoRow(
              label1: "Phone",
              value1: user.phone,
              label2: "Role",
              value2: user.role,
            ),
            const SizedBox(height: 5),
            _buildInfoRow(
              label: "Account Status",
              value: user.status,
              showVerification: false,
            ),

            const SizedBox(height: 25),

            /// ================= DRIVER INFO =================
            const Text(
              'Driver Information',
              style: TextStyle(
                color: AppColors.electricTeal,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            _buildDoubleInfoRow(
              label1: "License Number",
              value1: driver.licenseNumber,
              label2: "Company",
              value2: driver.company.name,
            ),
            const SizedBox(height: 5),
            _buildDoubleInfoRow(
              label1: "License Expiry",
              value1: driver.licenseExpiry.split("T").first,
              label2: "Date of Birth",
              value2: driver.dateOfBirth.split("T").first,
            ),
            const SizedBox(height: 5),
            _buildDoubleInfoRow(
              label1: "Driver Status",
              // value1: driver.status,
              value1: driver.driverRating.toString(),

              label2: "Driver Rating",
              // value2: driver.rating,
              value2: driver.driverRating.toString(),
            ),
            const SizedBox(height: 25),

            /// ================= VEHICLE INFO =================
            const Text(
              'Vehicle Information',
              style: TextStyle(
                color: AppColors.electricTeal,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            _buildDoubleInfoRow(
              label1: "Registration Number",
              value1: vehicle.registrationNumber,
              label2: "Make",
              value2: vehicle.make,
            ),
            const SizedBox(height: 5),
            _buildDoubleInfoRow(
              label1: "Model",
              // value1: vehicle.model,
              value1: vehicle.vehicleType,
              label2: "Type",
              // value2: vehicle.type,
              value2: vehicle.vehicleType,
            ),
            const SizedBox(height: 5),
            _buildInfoRow(
              label: "Color",
              value: vehicle.color,
              showVerification: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(stats) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              stats.totalTrips.toString(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text("Trips", style: TextStyle(color: Colors.grey)),
          ],
        ),
        Column(
          children: [
            Text(
              stats.monthsActive.toStringAsFixed(1),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text("Months Active", style: TextStyle(color: Colors.grey)),
          ],
        ),
        Column(
          children: [
            Text(
              stats.rating.toString(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text("Rating", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  // --- Reusable Info Row Widget (Yeh pehle jaisa hi rahega) ---
  Widget _buildInfoRow({
    required String label,
    required String value,
    required bool showVerification,
    Color labelColor = AppColors.mediumGray,
    Color valueColor = AppColors.darkText,
  }) {
    // ... (same implementation as before)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: labelColor, fontSize: 14)),
        const SizedBox(height: 5),
        Row(
          children: [
            Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 10),
            if (showVerification)
              const Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 18,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Verified',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildDoubleInfoRow({
    required String label1,
    required String value1,
    required String label2,
    required String value2,
    bool showVerification1 = false,
    bool showVerification2 = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// LEFT SIDE
        Expanded(
          child: _buildInfoRow(
            label: label1,
            value: value1,
            showVerification: showVerification1,
          ),
        ),

        const SizedBox(width: 15),

        /// RIGHT SIDE
        Expanded(
          child: _buildInfoRow(
            label: label2,
            value: value2,
            showVerification: showVerification2,
          ),
        ),
      ],
    );
  }
}
