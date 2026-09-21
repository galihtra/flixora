import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flixora/resources/layout_app.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flixora/app/app_routes.dart';
import 'package:flixora/components/network_error/state_message.dart';
import 'package:flixora/components/poster/poster_card.dart';
import 'package:flixora/data/providers/watchlist/watchlist_provider.dart';
import 'package:flixora/resources/colors_app.dart';
import 'package:flixora/resources/strings_app.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WatchlistProvider>();
    final items = provider.items;
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 15.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    AppStrings.myList,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 27.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Icon(
                  Icons.bookmark_rounded,
                  color: AppColors.accent,
                  size: 24.r,
                ),
              ],
            ),
          ),
          Expanded(
            child: !provider.ready
                ? const Center(child: CircularProgressIndicator())
                : items.isEmpty
                ? StateMessage(
                    icon: Icons.bookmark_add_outlined,
                    title: AppStrings.emptyList,
                    message: AppStrings.emptyListBody,
                    actionLabel: AppStrings.exploreMovies,
                    action: () => context.go(AppRoutes.movies),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = AppLayout.columns(constraints.maxWidth);
                      final inset = AppLayout.pageInset;
                      final gap = AppLayout.gridGap;
                      final width =
                          (constraints.maxWidth -
                              2 * inset -
                              (columns - 1) * gap) /
                          columns;
                      return GridView.builder(
                        padding: EdgeInsets.fromLTRB(inset, 4.h, inset, 25.h),
                        itemCount: items.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: gap,
                          mainAxisSpacing: AppLayout.rowGap,
                          mainAxisExtent: AppLayout.posterTileHeight(
                            context,
                            width,
                          ),
                        ),
                        itemBuilder: (context, index) => PosterCard(
                          item: items[index],
                          scope: 'my-list',
                          width: width,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
