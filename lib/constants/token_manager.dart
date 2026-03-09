import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../common_widgets/custom_button.dart';
import '../constants/local_storage.dart';
import 'colors.dart';
import 'token_expired.dart';

class SessionManager {
  static bool _dialogShowing = false;

  static Future<void> handleSessionExpired() async {
    if (_dialogShowing) return;

    _dialogShowing = true;

    await LocalStorage.clearToken();

    final context = NavigationService.context;

    if (context != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return AlertDialog(
              title: const Text("Session Expired"),
              content: const Text(
                "Your session has expired. Please login again.",
              ),
              actions: [
                CustomButton(
                  text: "Login Again",
                  backgroundColor: AppColors.electricTeal,
                  borderColor: AppColors.electricTeal,
                  textColor: AppColors.lightGrayBackground,
                  onPressed: () {
                    _dialogShowing = false;
                    GoRouter.of(context).go('/login');
                  },
                ),
              ],
            );
          },
        );
      });
    }
  }
}
