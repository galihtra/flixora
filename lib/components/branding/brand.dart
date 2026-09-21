import 'package:flutter/material.dart';
import 'package:flixora/resources/colors_app.dart';
import 'package:flixora/resources/strings_app.dart';

class Brand extends StatelessWidget {
  const Brand({super.key, this.size = 25});
  final double size;
  @override
  Widget build(BuildContext context) => Text(
    AppStrings.appName,
    style: TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w900,
      color: AppColors.accent,
      letterSpacing: -1.5,
    ),
  );
}
