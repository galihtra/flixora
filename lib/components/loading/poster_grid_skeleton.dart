import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flixora/resources/layout_app.dart';
import 'package:flixora/components/loading/loading_block.dart';
import 'package:flixora/resources/values_app.dart';

class PosterGridSkeleton extends StatelessWidget {
  const PosterGridSkeleton({super.key});
  @override
  Widget build(BuildContext context) {
    final available = MediaQuery.sizeOf(context).width;
    final columns = AppLayout.columns(available);
    final width = AppLayout.posterWidth(available);
    return GridView.builder(
      padding: EdgeInsets.all(AppLayout.pageInset),
      itemCount: 12,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: AppLayout.gridGap,
        mainAxisSpacing: AppLayout.rowGap,
        mainAxisExtent: AppLayout.posterTileHeight(context, width),
      ),
      itemBuilder: (_, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoadingBlock(width: width, height: width * AppValues.posterRatio),
          SizedBox(height: 8.h),
          LoadingBlock(width: width * .75, height: 10.h),
        ],
      ),
    );
  }
}
