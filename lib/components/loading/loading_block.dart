import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flixora/resources/colors_app.dart';

class LoadingBlock extends StatelessWidget {
  const LoadingBlock({
    super.key,
    required this.width,
    required this.height,
    this.radius = 5,
  });
  final double width;
  final double height;
  final double radius;
  @override
  Widget build(BuildContext context) {
    final block = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
    if (MediaQuery.disableAnimationsOf(context)) return block;
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: AppColors.shimmerHighlight,
      child: block,
    );
  }
}
