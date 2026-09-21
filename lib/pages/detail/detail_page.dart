import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flixora/app/navigation.dart';
import 'package:flixora/data/model/models.dart';
import 'package:flixora/base_widgets/image/artwork.dart';
import 'package:flixora/components/loading/detail_skeleton.dart';
import 'package:flixora/components/network_error/error_message.dart';
import 'package:flixora/components/watchlist/list_action.dart';
import 'package:flixora/data/providers/detail/detail_provider.dart';
import 'package:flixora/resources/colors_app.dart';
import 'package:flixora/resources/strings_app.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, this.args});
  final DetailArgs? args;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DetailProvider>();
    final detail = provider.detail;
    final item = detail?.item ?? args?.item;
    if (item == null) {
      return Scaffold(
        appBar: AppBar(),
        body: provider.error != null
            ? ErrorMessage(error: provider.error!, retry: provider.load)
            : const DetailSkeleton(),
      );
    }
    final screen = MediaQuery.sizeOf(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: screen.width * 9 / 16 + 44.h,
            backgroundColor: AppColors.background,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Artwork(
                    path: item.backdropPath ?? item.posterPath,
                    backdrop: item.backdropPath != null,
                    width: screen.width,
                    height: screen.width * 9 / 16 + 44.h,
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.black38,
                          AppColors.transparent,
                          AppColors.background,
                        ],
                        stops: [0, .48, 1],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 32.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.r),
                        child: Artwork(
                          path: item.posterPath,
                          width: 104.w,
                          height: 156.w,
                          heroTag: args?.heroTag,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(3.r),
                              ),
                              child: Text(
                                item.type.label.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.sp,
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              item.title,
                              style: TextStyle(
                                fontSize: 25.sp,
                                fontWeight: FontWeight.w900,
                                height: 1.07,
                              ),
                            ),
                            SizedBox(height: 11.h),
                            Wrap(
                              spacing: 8.w,
                              runSpacing: 5.h,
                              children: [
                                Text(
                                  item.year,
                                  style: const TextStyle(
                                    color: AppColors.muted,
                                  ),
                                ),
                                if (detail != null &&
                                    detail.durationLabel.isNotEmpty)
                                  Text(
                                    '•  ${detail.durationLabel}',
                                    style: const TextStyle(
                                      color: AppColors.muted,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 23.h),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 5.w,
                    runSpacing: 5.h,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: AppColors.rating,
                        size: 26.r,
                      ),
                      Text(
                        item.rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 21.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '/ 10',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 14.sp,
                        ),
                      ),
                      if (item.voteCount > 0)
                        Text(
                          '(${item.voteCount} votes)',
                          style: TextStyle(
                            color: AppColors.muted,
                            fontSize: 12.sp,
                          ),
                        ),
                      Text(
                        AppStrings.tmdb,
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 19.h),
                  ListAction(item: item, fullWidth: true),
                  if (provider.error != null) ...[
                    SizedBox(height: 14.h),
                    ErrorMessage(
                      error: provider.error!,
                      retry: provider.load,
                      compact: true,
                    ),
                  ],
                  if (provider.loading) ...[
                    SizedBox(height: 18.h),
                    const LinearProgressIndicator(
                      color: AppColors.accent,
                      backgroundColor: AppColors.surface,
                    ),
                  ],
                  if (detail != null && detail.genres.isNotEmpty) ...[
                    SizedBox(height: 25.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: detail.genres
                          .map(
                            (genre) => Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 11.w,
                                vertical: 7.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                genre,
                                style: TextStyle(fontSize: 12.sp),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  SizedBox(height: 27.h),
                  Text(
                    AppStrings.overview,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 9.h),
                  Text(
                    item.overview.isEmpty
                        ? AppStrings.noOverview
                        : item.overview,
                    style: TextStyle(
                      color: AppColors.bodyText,
                      fontSize: 14.sp,
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  const Divider(color: AppColors.white24),
                  SizedBox(height: 10.h),
                  Text(
                    AppStrings.discoverMore,
                    style: TextStyle(color: AppColors.muted, fontSize: 12.sp),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
