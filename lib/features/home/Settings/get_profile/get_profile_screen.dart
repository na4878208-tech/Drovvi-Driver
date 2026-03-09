import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logisticdriverapp/export.dart';
import 'package:logisticdriverapp/features/home/Settings/get_profile/profile_controller.dart';
import 'package:logisticdriverapp/features/home/Settings/get_profile/profile_model.dart';
import 'package:shimmer/shimmer.dart';

class GetProfileScreen extends ConsumerStatefulWidget {
  const GetProfileScreen({super.key});

  @override
  ConsumerState<GetProfileScreen> createState() => _GetProfileScreenState();
}

class _GetProfileScreenState extends ConsumerState<GetProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Initial load
    ref.read(profileControllerProvider.notifier).fetchProfile();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh every time the screen appears
    // ignore: unused_result
    ref.refresh(profileControllerProvider);
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      body: profileState.when(
        loading: () => const ProfileShimmer(), // shimmer loader
        error: (e, _) => Center(child: Text(e.toString())),
        data: (profileResponse) {
          final user = profileResponse.data.user;
          final driver = profileResponse.data.driver;
          final vehicle = profileResponse.data.vehicle;
          final stats = profileResponse.data.stats;
          final earnings = profileResponse.data.earnings;
          final bank = profileResponse.data.bankAccount;
          final depot = profileResponse.data.driver.depot;
          final company = profileResponse.data.driver.company;
          final missingDocs = driver.missingDocuments;

          return RefreshIndicator(
            onRefresh: () async {
              // ignore: unused_result
              ref.refresh(profileControllerProvider);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _profileHeader(context, user),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        missingDocumentsBanner(
                          missingDocs: missingDocs,
                          context: context,
                        ),
                        const SizedBox(height: 10),
                        _statsCard(stats),
                        const SizedBox(height: 20),
                        _infoCard(
                          title: "Driver Information",
                          children: [
                            _doubleInfo(
                              "License Number",
                              driver.licenseNumber,
                              "License Type",
                              driver.licenseType ?? "-",
                            ),
                            _doubleInfo(
                              "License Expiry",
                              driver.licenseExpiry.split("T").first,
                              "PRDP Number",
                              driver.prdpNumber,
                            ),
                            _doubleInfo(
                              "PRDP Expiry",
                              driver.prdpExpiry.split("T").first,
                              "Driver Rating",
                              driver.driverRating.toString(),
                            ),
                            _doubleInfo(
                              "Total Trips",
                              driver.totalTrips.toString(),
                              "Completed Trips",
                              driver.completedTrips.toString(),
                            ),
                            _doubleInfo(
                              "Cancelled Trips",
                              driver.cancelledTrips.toString(),
                              "On Time %",
                              driver.onTimePercentage.toString(),
                            ),
                            _doubleInfo(
                              "Emergency Contact",
                              driver.emergencyContactName,
                              "Emergency Phone",
                              driver.emergencyContactPhone,
                            ),
                            _doubleInfo(
                              "Company",
                              company.name,
                              "Depot",
                              depot.name,
                            ),
                            _singleInfo("Driver Status", driver.status),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _infoCard(
                          title: "Vehicle Information",
                          children: [
                            _doubleInfo(
                              "Registration",
                              vehicle.registrationNumber,
                              "Make",
                              vehicle.make,
                            ),
                            _doubleInfo(
                              "Model",
                              vehicle.model,
                              "Year",
                              vehicle.year.toString(),
                            ),
                            _doubleInfo(
                              "Vehicle Type",
                              vehicle.vehicleType,
                              "Max Weight",
                              vehicle.maxWeightTons,
                            ),
                            _singleInfo("Color", vehicle.color),
                            _singleInfo("Vehicle Status", vehicle.status),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _infoCard(
                          title: "Earnings",
                          children: [
                            _doubleInfo(
                              "Total Earnings",
                              "${earnings.currency} ${earnings.totalEarnings}",
                              "Pending",
                              earnings.pendingEarnings.toString(),
                            ),
                            _doubleInfo(
                              "Approved",
                              earnings.approvedEarnings.toString(),
                              "Paid",
                              earnings.paidEarnings.toString(),
                            ),
                            _doubleInfo(
                              "This Month",
                              earnings.thisMonthEarnings.toString(),
                              "Avg / Delivery",
                              earnings.averagePerDelivery.toString(),
                            ),
                          ],
                        ),
                        if (bank != null) ...[
                          const SizedBox(height: 20),
                          _infoCard(
                            title: "Bank Account",
                            children: [
                              _singleInfo("Bank Name", bank.bankName),
                              _singleInfo("Account Number", bank.accountNumber),
                            ],
                          ),
                        ],
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// PROFILE HEADER
  Widget _profileHeader(BuildContext context, User user) {
    return Container(
      width: double.infinity,
      height: 350,
      decoration: const BoxDecoration(
        color: AppColors.electricTeal,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.go("/setting"),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const Spacer(),
                  const Text(
                    "Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => context.go("/edit-profile"),
                    icon: const Icon(Icons.edit, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            CircleAvatar(
              radius: 42,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image.asset(
                  "assets/download.png",
                  width: 76,
                  height: 76,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              user.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user.phone,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            Text(
              user.email,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: _profileStat(user.role, "Role")),
                Container(height: 40, width: 1.5, color: Colors.white),
                Expanded(child: _profileStat(user.status, "Status")),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileStat(String value, String title) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 2),
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  /// STATS CARD
  Widget _statsCard(Stats stats) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _statItem(stats.totalTrips.toString(), "Trips"),
          _statItem(stats.rating.toStringAsFixed(1), "Rating"),
          _statItem(
            "${stats.completionRate.toStringAsFixed(1)}%",
            "Completion",
          ),
        ],
      ),
    );
  }

  Widget _statItem(String value, String title) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _infoCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              color: AppColors.electricTeal,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _singleInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.mediumGray, fontSize: 13),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _doubleInfo(
    String label1,
    String value1,
    String label2,
    String value2,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Expanded(child: _singleInfo(label1, value1)),
          const SizedBox(width: 12),
          Expanded(child: _singleInfo(label2, value2)),
        ],
      ),
    );
  }
}

/// SHIMMER LOADER
/// SHIMMER LOADER MATCHING UI
class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          children: [
            // Top Header
            Container(
              height: 350,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white, // shimmer will override
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const CircleAvatar(radius: 42, backgroundColor: Colors.grey),
                  const SizedBox(height: 12),
                  Container(height: 16, width: 120, color: Colors.grey),
                  const SizedBox(height: 6),
                  Container(height: 14, width: 80, color: Colors.grey),
                  const SizedBox(height: 6),
                  Container(height: 14, width: 150, color: Colors.grey),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(height: 16, width: 60, color: Colors.grey),
                      const SizedBox(width: 12),
                      Container(height: 16, width: 60, color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Missing Documents Banner
            Container(
              width: double.infinity,
              height: 80,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            const SizedBox(height: 16),

            // Stats Card
            Container(
              width: double.infinity,
              height: 80,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(16),
              ),
            ),

            const SizedBox(height: 16),

            // Driver Info Card
            Container(
              width: double.infinity,
              height: 200,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(18),
              ),
            ),

            const SizedBox(height: 16),

            // Vehicle Info Card
            Container(
              width: double.infinity,
              height: 160,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(18),
              ),
            ),

            const SizedBox(height: 16),

            // Earnings Card
            Container(
              width: double.infinity,
              height: 120,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(18),
              ),
            ),

            const SizedBox(height: 16),

            // Bank Card
            Container(
              width: double.infinity,
              height: 80,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(18),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

String formatDocumentName(String doc) {
  switch (doc) {
    case "id":
      return "South African ID";

    case "prdp":
      return "Professional Driving Permit (PrDP)";

    case "license":
      return "Driver's License";
    default:
      return doc.replaceAll("_", " ");
  }
}

Widget missingDocumentsBanner({
  required List<String> missingDocs,
  required BuildContext context,
}) {
  if (missingDocs.isEmpty) return const SizedBox();

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFFFFE082), // image jaisa color
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: Colors.black87),
            SizedBox(width: 8),
            Text(
              "Missing Required Documents",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),

        const SizedBox(height: 8),

        const Text(
          "The following required documents are missing:",
          style: TextStyle(fontSize: 14),
        ),

        const SizedBox(height: 8),

        ...missingDocs.map((docType) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("• "),
                Expanded(
                  child: Text(
                    formatDocumentName(docType),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          );
        }).toList(),

        const SizedBox(height: 6),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                context.push('/document');
              },
              child: const Text(
                "View",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.electricTeal,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
