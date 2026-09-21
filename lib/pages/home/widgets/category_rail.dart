import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flixora/resources/layout_app.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flixora/app/app_routes.dart';
import 'package:flixora/data/model/models.dart';
import 'package:flixora/components/loading/poster_skeleton_row.dart';
import 'package:flixora/components/network_error/error_message.dart';
import 'package:flixora/components/poster/poster_card.dart';
import 'package:flixora/data/providers/home/home_provider.dart';
import 'package:flixora/resources/colors_app.dart';
import 'package:flixora/resources/strings_app.dart';

class CategoryRail extends StatelessWidget {
  const CategoryRail({super.key, required this.category});
  final CatalogCategory category;
  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeProvider>().state(category);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 18.h, 12.w, 12.h),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  category.title,
                  style: TextStyle(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -.35,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => context.push(AppRoutes.category(category)),
                child: Text(
                  AppStrings.seeAll,
                  style: TextStyle(color: AppColors.muted, fontSize: 12.sp),
                ),
              ),
            ],
          ),
        ),
        if (state.items.isNotEmpty)
          SizedBox(
            height: AppLayout.posterTileHeight(
              context,
              AppLayout.railPosterWidth,
            ),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: state.items.length,
              separatorBuilder: (_, _) => SizedBox(width: 10.w),
              itemBuilder: (_, index) =>
                  PosterCard(item: state.items[index], scope: category.path),
            ),
          )
        else if (state.error != null)
          ErrorMessage(
            error: state.error!,
            compact: true,
            retry: () => context.read<HomeProvider>().loadCategory(category),
          )
        else if (state.loading)
          const PosterSkeletonRow()
        else
          SizedBox(height: 40.h),
        SizedBox(height: 5.h),
      ],
    );
  }
}
