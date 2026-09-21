import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flixora/resources/colors_app.dart';
import 'package:flixora/resources/strings_app.dart';

class Brand extends StatelessWidget {
  const Brand({super.key, this.size = 25});
  final double size;
  @override
  Widget build(BuildContext context) => Text(
    AppStrings.appName,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: size.sp,
      fontWeight: FontWeight.w900,
      color: AppColors.accent,
      letterSpacing: (-1.5).sp,
    ),
  );
}
