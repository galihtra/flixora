import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flixora/app/app_routes.dart';
import 'package:flixora/resources/colors_app.dart';
import 'package:flixora/resources/strings_app.dart';

import '../../resources/assets_app.dart';

class BrowseHeader extends StatelessWidget {
  const BrowseHeader({super.key, this.title});
  final String? title;
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(20.w, 9.h, 4.w, 5.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(AppIcons.textLogo, height: 25.h),
              if (title != null) ...[
                SizedBox(width: 10.w),
                Container(width: 1.w, height: 18.h, color: AppColors.white30),
                SizedBox(width: 10.w),
                Flexible(
                  child: Text(
                    title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        IconButton(
          tooltip: AppStrings.search,
          onPressed: () => context.push(AppRoutes.search),
          icon: Icon(Icons.search_rounded, size: 27.r),
        ),
      ],
    ),
  );
}
