import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flixora/components/loading/loading_block.dart';

class DetailSkeleton extends StatelessWidget {
  const DetailSkeleton({super.key});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Backdrop
          LoadingBlock(width: width, height: width * 9 / 16 + 44.h, radius: 0),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 32.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    LoadingBlock(width: 104.w, height: 156.w, radius: 5),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              LoadingBlock(width: 40.w, height: 16.h, radius: 3),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          LoadingBlock(width: 180.w, height: 28.h),
                          SizedBox(height: 6.h),
                          LoadingBlock(width: 120.w, height: 28.h),
                          SizedBox(height: 11.h),
                          LoadingBlock(width: 90.w, height: 14.h),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 23.h),
                LoadingBlock(width: 150.w, height: 26.h),
                SizedBox(height: 19.h),
                LoadingBlock(width: width - 40.w, height: 48.h),
                SizedBox(height: 25.h),
                Row(
                  children: [
                    LoadingBlock(width: 60.w, height: 26.h, radius: 4),
                    SizedBox(width: 8.w),
                    LoadingBlock(width: 80.w, height: 26.h, radius: 4),
                    SizedBox(width: 8.w),
                    LoadingBlock(width: 70.w, height: 26.h, radius: 4),
                  ],
                ),
                SizedBox(height: 27.h),
                LoadingBlock(width: 100.w, height: 22.h),
                SizedBox(height: 9.h),
                LoadingBlock(width: width - 40.w, height: 14.h),
                SizedBox(height: 6.h),
                LoadingBlock(width: width - 40.w, height: 14.h),
                SizedBox(height: 6.h),
                LoadingBlock(width: width * 0.7, height: 14.h),
                SizedBox(height: 25.h),
                LoadingBlock(width: 120.w, height: 22.h),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    LoadingBlock(width: 70.w, height: 105.w, radius: 4),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LoadingBlock(width: 120.w, height: 18.h),
                        SizedBox(height: 6.h),
                        LoadingBlock(width: 80.w, height: 14.h),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
