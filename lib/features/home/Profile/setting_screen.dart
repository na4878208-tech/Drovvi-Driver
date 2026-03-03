import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logisticdriverapp/constants/bottom_show.dart';
import 'package:logisticdriverapp/features/home/Profile/logout/logout_controller.dart';
import '../../../constants/colors.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  void showCustomModal({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String confirmText,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.pureWhite,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Subtitle
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.darkGray,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Buttons Row
                  Row(
                    children: [
                      // CANCEL
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(
                              color: AppColors.electricTeal,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () => context.pop(),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              color: AppColors.electricTeal,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // CONFIRM
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.electricTeal,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: onConfirm,
                          child: Text(
                            confirmText,
                            style: const TextStyle(
                              color: AppColors.pureWhite,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 45,
        leading: IconButton(
          onPressed: () => context.go("/profile"),
          icon: const Icon(Icons.arrow_back, size: 18),
        ),
        backgroundColor: AppColors.electricTeal,
        foregroundColor: AppColors.pureWhite,
      ),
      // ⭐ Scrollable Screen
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            _buildSettingsCard(
              title: "General",
              children: [
                _buildSettingTile(
                  Icons.notifications_none,
                  "Notifications",
                  () {
                    context.push("/notifications");
                  },
                ),
                // _buildSettingTile(Icons.language, "Language", () {
                //   showCenteredLanguageModal(context);
                // }),
              ],
            ),

            const SizedBox(height: 18),

            _buildSettingsCard(
              title: "Security",
              children: [
                _buildSettingTile(Icons.lock_outline, "Change Password", () {
                  context.push("/change-password");
                }),
              ],
            ),

            const SizedBox(height: 18),

            _buildSettingsCard(
              title: "Support",
              children: [
                _buildSettingTile(Icons.help_outline, "Help & Support", () {
                  context.push("/help-support");
                }),
              ],
            ),

            const SizedBox(height: 18),

            _buildSettingsCard(
              title: "Account",
              children: [_buildLogoutTile()],
            ),
          ],
        ),
      ),
    );
  }

  // ⭐ Card Widget for grouping settings
  Widget _buildSettingsCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.electricTeal.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Title
          Text(
            title,
            style: const TextStyle(
              color: AppColors.electricTeal,
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 15),

          // Settings list
          ...children,
        ],
      ),
    );
  }

  void showCenteredLanguageModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.80,
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.pureWhite,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Select Language",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),

                  const SizedBox(height: 20),
                  const Divider(),

                  // English
                  InkWell(
                    onTap: () {
                      context.pop();
                      print("Selected: English");
                      // TODO: update language
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Center(
                        child: Text(
                          "English",
                          style: TextStyle(
                            fontSize: 17,
                            color: AppColors.mediumGray,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const Divider(height: 1),

                  // Urdu
                  InkWell(
                    onTap: () {
                      context.pop();
                      print("Selected: Urdu");
                      // TODO: update language
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Center(
                        child: Text(
                          "Urdu",
                          style: TextStyle(
                            fontSize: 17,
                            color: AppColors.mediumGray,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ⭐ Generic Setting Tile
  Widget _buildSettingTile(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: AppColors.electricTeal, size: 26),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.mediumGray,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutTile() {
    return Consumer(
      builder: (context, ref, _) {
        final logoutState = ref.watch(logoutControllerProvider);
        final controller = ref.read(logoutControllerProvider.notifier);

        return InkWell(
          onTap: () {
            showCustomModal(
              context: context,
              title: "Sign Out ?",
              subtitle: "Are you sure you want to Sign out?",
              confirmText: "Sign Out",
              onConfirm: () async {
                context.pop();

                try {
                  await controller.logout();

                  context.go("/login");

                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(
                  //     content: Text("Successfully logged out"),
                  //     backgroundColor: Colors.green,
                  //   ),
                  // );

                  AppSnackBar.showSuccess(context, "Successfully logged out");
                } catch (e) {
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     content: Text(e.toString()),
                  //     backgroundColor: Colors.red,
                  //   ),
                  // );

                  AppSnackBar.showError(context, e.toString());
                }
              },
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.logout, color: Colors.red, size: 26),
                const SizedBox(width: 12),
                const Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (logoutState.isLoading) ...[
                  const SizedBox(width: 10),
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
