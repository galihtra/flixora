import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flixora/resources/colors_app.dart';
import 'package:flixora/resources/strings_app.dart';

class StateMessage extends StatelessWidget {
  const StateMessage({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
    this.actionLabel = AppStrings.tryAgain,
    this.compact = false,
  });
  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? action;
  final String actionLabel;
  final bool compact;
  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: 28.w,
        vertical: compact ? 18.h : 40.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: compact ? 32.r : 48.r, color: AppColors.muted),
          SizedBox(height: 14.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: compact ? 16.sp : 22.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 7.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.muted,
              height: 1.4,
              fontSize: 14.sp,
            ),
          ),
          if (action != null) ...[
            SizedBox(height: 20.h),
            OutlinedButton(onPressed: action, child: Text(actionLabel)),
          ],
        ],
      ),
    ),
  );
}
