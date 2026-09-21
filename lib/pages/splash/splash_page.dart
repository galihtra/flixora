import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flixora/app/app_routes.dart';
import 'package:flixora/components/branding/brand.dart';
import 'package:flixora/resources/colors_app.dart';
import 'package:flixora/resources/strings_app.dart';
import 'package:flixora/resources/values_app.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer(AppValues.splashDuration, () {
      if (mounted) context.go(AppRoutes.home);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.play_arrow_rounded, color: AppColors.accent, size: 82),
          SizedBox(height: 4),
          Brand(size: 36),
          SizedBox(height: 10),
          Text(
            AppStrings.splashTagline,
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 2.4,
              color: AppColors.muted,
            ),
          ),
        ],
      ),
    ),
  );
}
