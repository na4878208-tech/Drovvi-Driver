import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'export.dart';
import 'features/routes/app_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (defaultTargetPlatform == TargetPlatform.android) {
    // ignore: deprecated_member_use
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Logistic Driver',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.electricTeal),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.electricTeal,
          elevation: 0,
        ),
      ),
      routerConfig: router,
    );
  }
}
