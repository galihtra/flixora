import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flixora/components/loading/loading_block.dart';

class DetailSkeleton extends StatelessWidget {
  const DetailSkeleton({super.key});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoadingBlock(width: width, height: width * 9 / 16, radius: 0),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoadingBlock(width: 180.w, height: 28.h),
                SizedBox(height: 16.h),
                LoadingBlock(width: 115.w, height: 18.h),
                SizedBox(height: 25.h),
                LoadingBlock(width: width - 40.w, height: 48.h),
                SizedBox(height: 30.h),
                LoadingBlock(width: 135.w, height: 22.h),
                SizedBox(height: 14.h),
                LoadingBlock(width: width - 40.w, height: 100.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
