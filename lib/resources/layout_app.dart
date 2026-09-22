import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flixora/resources/values_app.dart';

abstract final class AppLayout {
  static double get pageInset => 16.w.clamp(12.0, 28.0);
  static double get gridGap => 10.w.clamp(8.0, 18.0);
  static double get rowGap => 15.h.clamp(10.0, 22.0);
  static double get railPosterWidth => 120.w.clamp(94.0, 170.0);
  static double get posterTitleSize => 12.sp.clamp(10.0, 16.0);
  static double get posterMetaSize => 11.sp.clamp(9.0, 14.0);

  static int columns(double width) {
    if (width < 360) return 2;
    if (width < 520) return 3;
    if (width < 700) return 4;
    if (width < 900) return 5;
    return 6;
  }

  static double posterWidth(double availableWidth) {
    final count = columns(availableWidth);
    return (availableWidth - 2 * pageInset - (count - 1) * gridGap) / count;
  }

  static double posterTileHeight(BuildContext context, double posterWidth) {
    final textScale = MediaQuery.textScalerOf(context);
    final titleLine = textScale.scale(posterTitleSize * 1.25);
    final metaLine = textScale.scale(posterMetaSize * 1.25);
    return posterWidth * AppValues.posterRatio +
        titleLine +
        math.max(metaLine, 13.r) +
        7.h +
        2.h +
        math.max(36.0, 18.r);
  }

  static double heroHeight(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);
    return math.min(430.h, math.max(260.r, screen.height * .56));
  }
}
