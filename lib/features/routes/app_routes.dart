import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logisticdriverapp/features/authentication/Registration_flow/otp_registration.dart';

// Auth Screens
import 'package:logisticdriverapp/features/authentication/Registration_flow/register.dart';
import 'package:logisticdriverapp/features/authentication/Registration_flow/register_successful.dart';

// Bottom Navbar
import 'package:logisticdriverapp/features/bottom_navbar/bottom_navbar_screen.dart';

// Splash
import 'package:logisticdriverapp/features/custom_splash/splash.dart';
import 'package:logisticdriverapp/features/home/Settings/Change_password_flow/Change_password_screen.dart';
import 'package:logisticdriverapp/features/home/Settings/documents/document_screen.dart';
import 'package:logisticdriverapp/features/home/Settings/edit_profile/Edit_profile.dart';
import 'package:logisticdriverapp/features/home/Settings/get_profile/get_profile_screen.dart';
import 'package:logisticdriverapp/features/home/Settings/help_support_screen.dart';
import 'package:logisticdriverapp/features/home/conform_order_screen.dart';
import 'package:logisticdriverapp/features/home/conform_order_successfull.dart';

// Home Main Screens
import 'package:logisticdriverapp/features/home/Map/map_screen.dart';
import 'package:logisticdriverapp/features/home/notification_screen.dart';
import 'package:logisticdriverapp/features/home/order_successful.dart';
import 'package:logisticdriverapp/features/home/summary_screen.dart';

import '../../constants/token_expired.dart';
import '../authentication/Login/login.dart';
import '../authentication/Registration_flow/create_password.dart';
import '../authentication/forget_password_flow/forget_password/forgot_password.dart';
import '../authentication/forget_password_flow/otp/otp_forget.dart';
import '../authentication/forget_password_flow/password_change/password_change.dart';
import '../home/main_screens/home_screen/home_screen.dart';
import '../home/order_details_screen/order_detail_modal.dart';
import '../home/order_details_screen/order_tracking_history_screen.dart';

final GoRouter router = GoRouter(
  navigatorKey: NavigationService.navigatorKey,
  routes: [
    // ---------- Splash ----------
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),

    // ---------- Authentication ----------
    GoRoute(path: '/login', builder: (context, state) => const Login()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const SignUpScreen(),
    ),

    GoRoute(
      path: '/create-password',
      builder: (context, state) => const CreatePasswordScreen(),
    ),
    GoRoute(
      path: '/register-success',
      builder: (context, state) => const RegisterSuccessful(),
    ),
    GoRoute(
      path: '/forget-password',
      builder: (context, state) => const ForgotPassword(),
    ),

    GoRoute(
      path: '/document',
      builder: (context, state) => const DriverDocumentsScreen(),
    ),

    GoRoute(
      path: '/otp-forget',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>?;

        return OtpForgetScreen(
          email: data?["email"] ?? "",
          otp: data?["otp"] ?? 0,
        );
      },
    ),
    GoRoute(
      path: '/otp-registration',
      builder: (context, state) => const OtpRegistrationScreen(),
    ),

    GoRoute(
      path: '/change-password',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final email = extra['email'] as String? ?? '';
        final resetToken = extra['resetToken'] as String? ?? '';

        return ResetPasswordChangeScreen(email: email, resetToken: resetToken);
      },
    ),

     GoRoute(
      path: '/change-password-profile',
      builder: (context, state) =>
          const ChangePasswordScreen(),
    ),

    // ---------- Bottom Navbar ----------
    GoRoute(
      path: '/home',
      builder: (context, state) =>
          const TripsBottomNavBarScreen(initialIndex: 0),
    ),

    GoRoute(
      path: '/current',
      builder: (context, state) {
        final tab = state.extra as int? ?? 0;
        return CurrentScreen(initialTab: tab);
      },
    ),

    GoRoute(
      path: '/order-details',
      builder: (context, state) {
        final orderId = state.extra as int? ?? 0; // safe fallback
        if (orderId == 0) {
          return const Scaffold(body: Center(child: Text("Invalid order ID")));
        }
        return TripsBottomNavBarScreen(initialIndex: 1, orderId: orderId);
      },
    ),

    GoRoute(
      path: '/earning',
      builder: (context, state) =>
          const TripsBottomNavBarScreen(initialIndex: 2),
    ),

    GoRoute(
      path: '/setting',
      builder: (context, state) =>
          const TripsBottomNavBarScreen(initialIndex: 3),
    ),

    GoRoute(
      path: '/profile',
      builder: (context, state) =>
          const GetProfileScreen(),
    ),

    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/help-support',
      builder: (context, state) => const HelpSupportScreen(),
    ),
    GoRoute(
      path: '/change-password',
      builder: (context, state) => const ChangePasswordScreen(),
    ),

    // ---------- Order Screens ----------
    GoRoute(
      path: '/confirm-order',
      builder: (context, state) => const ConformOrderScreen(),
    ),
    GoRoute(
      path: '/confirm-success',
      builder: (context, state) => const ConformOrderSuccessfull(),
    ),
    GoRoute(
      path: '/order-success',
      builder: (context, state) => const OrderSuccessful(),
    ),
    GoRoute(
      path: '/summary',
      builder: (context, state) => const SummaryScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationScreen(),
    ),
    GoRoute(
      path: "/order-tracking",
      builder: (context, state) {
        final order = state.extra as OrderModel;
        return OrderTrackingScreen(order: order);
      },
    ),

    GoRoute(
      path: '/map',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;

        if (extra == null) {
          return const Scaffold(
            body: Center(child: Text("Invalid map parameters")),
          );
        }

        final order = extra['order'] as OrderModel?;
        final type = extra['type'] as String?;
        final stop = extra['stop'] as OrderStop?;

        if ((order == null && stop == null) || (type == null && stop == null)) {
          return const Scaffold(
            body: Center(child: Text("Invalid map parameters")),
          );
        }

        // If stop exists, derive type from stop
        final finalType = type ?? stop!.stopType;

        final orderId = order?.id ?? stop!.id;

        return MapScreen(orderId: orderId, type: finalType);
      },
    ),
  ],
);
