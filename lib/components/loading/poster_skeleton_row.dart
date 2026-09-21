import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flixora/resources/layout_app.dart';
import 'package:flixora/components/loading/loading_block.dart';
import 'package:flixora/resources/values_app.dart';

class PosterSkeletonRow extends StatelessWidget {
  const PosterSkeletonRow({super.key});
  @override
  Widget build(BuildContext context) => SizedBox(
    height: AppLayout.railPosterWidth * AppValues.posterRatio + 34.h,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: 5,
      separatorBuilder: (_, _) => SizedBox(width: 10.w),
      itemBuilder: (_, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoadingBlock(
            width: AppLayout.railPosterWidth,
            height: AppLayout.railPosterWidth * AppValues.posterRatio,
          ),
          SizedBox(height: 8.h),
          LoadingBlock(width: AppLayout.railPosterWidth * .77, height: 10.h),
        ],
      ),
    ),
  );
}
