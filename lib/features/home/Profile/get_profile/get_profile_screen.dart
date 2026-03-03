import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logisticdriverapp/export.dart';
import 'package:logisticdriverapp/features/home/Profile/get_profile/profile_controller.dart';

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
  // @override
  // Widget build(BuildContext context) {
  //   final profileState = ref.watch(profileControllerProvider);
  //   final Color blueColor = AppColors.electricTeal;
  //   // Screen height ka hisaab lagana zaroori hai is layout ke liye
  //   double screenHeight = MediaQuery.of(context).size.height;

  //   return Scaffold(
  //     backgroundColor: AppColors.lightGrayBackground,
  //     appBar: AppBar(
  //       automaticallyImplyLeading: false,
  //       title: const Text(
  //         'Profile',
  //         style: TextStyle(
  //           color: AppColors.pureWhite,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       centerTitle: true,
  //       backgroundColor: blueColor,
  //       elevation: 0,
  //       actions: [
  //         Padding(
  //           padding: EdgeInsets.only(right: 15.0),
  //           child: IconButton(
  //             onPressed: () {
  //               context.go("/settings");
  //             },
  //             icon: Icon(Icons.settings, color: AppColors.pureWhite, size: 28),
  //           ),
  //         ),
  //       ],
  //     ),

  //     body: Column(
  //       children: [
  //         Expanded(
  //           child: Stack(
  //             children: [
  //               Container(height: 150, color: blueColor),

  //               Positioned(
  //                 top: screenHeight * 0.1,
  //                 left: 20,
  //                 right: 20,
  //                 bottom: 45,
  //                 child: _buildInfoCard(),
  //               ),

  //               Positioned(
  //                 top: 10,
  //                 left: 0,
  //                 right: 0,
  //                 child: Builder(
  //                   builder: (navContext) => Column(
  //                     children: [
  //                       _buildProfileImage(navContext, AppColors.electricTeal),
  //                       const SizedBox(height: 15),
  //                       const Text(
  //                         'John Doe',
  //                         style: TextStyle(
  //                           color: AppColors.darkText,
  //                           fontSize: 24,
  //                           fontWeight: FontWeight.w600,
  //                         ),
  //                       ),
  //                       Container(
  //                         width: 300,
  //                         margin: const EdgeInsets.only(top: 8),
  //                         height: 1,
  //                         color: AppColors.electricTeal,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
    required user,
    required driver,
    required vehicle,
    required stats,
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
              'Stats',
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

            _buildInfoRow(
              label: "Name",
              value: user.name,
              showVerification: false,
            ),
            _buildInfoRow(
              label: "Email",
              value: user.email,
              showVerification: false,
            ),
            _buildInfoRow(
              label: "Phone",
              value: user.phone,
              showVerification: true,
            ),
            _buildInfoRow(
              label: "Role",
              value: user.role,
              showVerification: false,
            ),
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

            _buildInfoRow(
              label: "License Number",
              value: driver.licenseNumber,
              showVerification: false,
            ),
            _buildInfoRow(
              label: "License Type",
              value: driver.licenseType ?? "-",
              showVerification: false,
            ),
            _buildInfoRow(
              label: "License Expiry",
              value: driver.licenseExpiry.split("T").first,
              showVerification: false,
            ),
            _buildInfoRow(
              label: "Date of Birth",
              value: driver.dateOfBirth.split("T").first,
              showVerification: false,
            ),
            _buildInfoRow(
              label: "Driver Status",
              value: driver.status,
              showVerification: false,
            ),
            _buildInfoRow(
              label: "Driver Rating",
              value: driver.rating,
              showVerification: false,
            ),
            _buildInfoRow(
              label: "Total Trips",
              value: driver.totalTrips.toString(),
              showVerification: false,
            ),
            _buildInfoRow(
              label: "Company",
              value: driver.company.name,
              showVerification: false,
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

            _buildInfoRow(
              label: "Registration Number",
              value: vehicle.registrationNumber,
              showVerification: false,
            ),
            _buildInfoRow(
              label: "Make",
              value: vehicle.make,
              showVerification: false,
            ),
            _buildInfoRow(
              label: "Model",
              value: vehicle.model,
              showVerification: false,
            ),
            _buildInfoRow(
              label: "Type",
              value: vehicle.type,
              showVerification: false,
            ),
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

  // Widget _buildStatsRow() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Column(
  //         children: const [
  //           Text(
  //             "450",
  //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //           ),
  //           SizedBox(height: 2),
  //           Text("Trips", style: TextStyle(color: Colors.grey)),
  //         ],
  //       ),
  //       Column(
  //         children: const [
  //           Text(
  //             "12",
  //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //           ),
  //           SizedBox(height: 4),
  //           Text("Months", style: TextStyle(color: Colors.grey)),
  //         ],
  //       ),
  //     ],
  //   );
  // }

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
              stats.rating,
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
                fontSize: 17,
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
}
