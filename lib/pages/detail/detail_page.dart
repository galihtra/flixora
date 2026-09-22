import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flixora/app/navigation.dart';
import 'package:flixora/data/model/models.dart';
import 'package:flixora/base_widgets/image/artwork.dart';
import 'package:flixora/components/loading/detail_skeleton.dart';
import 'package:flixora/components/loading/loading_block.dart';
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
                            Row(
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
                                if (detail?.adult == true) ...[
                                  SizedBox(width: 8.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade800,
                                      borderRadius: BorderRadius.circular(3.r),
                                    ),
                                    child: Text(
                                      '18+',
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
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
                    if (item.overview.isEmpty) ...[
                      SizedBox(height: 27.h),
                      LoadingBlock(width: 100.w, height: 22.h),
                      SizedBox(height: 9.h),
                      LoadingBlock(width: screen.width - 40.w, height: 14.h),
                      SizedBox(height: 6.h),
                      LoadingBlock(width: screen.width - 40.w, height: 14.h),
                      SizedBox(height: 6.h),
                      LoadingBlock(width: screen.width * 0.7, height: 14.h),
                    ],
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
                  if (detail != null && detail.seasonList.isNotEmpty) ...[
                    SizedBox(height: 25.h),
                    Text(
                      'Seasons',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    ...detail.seasonList.map(
                      (s) => Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4.r),
                              child: Artwork(
                                path: s.posterPath,
                                width: 70.w,
                                height: 105.w,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s.name,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Wrap(
                                    spacing: 8.w,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      if (s.seasonNumber != null)
                                        Text(
                                          'Season ${s.seasonNumber}',
                                          style: TextStyle(
                                            color: AppColors.muted,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      if (s.episodeCount != null)
                                        Text(
                                          '${s.episodeCount} Eps',
                                          style: TextStyle(
                                            color: AppColors.muted,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      if (s.voteAverage != null &&
                                          s.voteAverage! > 0)
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.star_rounded,
                                              color: AppColors.rating,
                                              size: 14.r,
                                            ),
                                            SizedBox(width: 2.w),
                                            Text(
                                              s.voteAverage!.toStringAsFixed(1),
                                              style: TextStyle(
                                                color: AppColors.muted,
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                  if (s.overview != null &&
                                      s.overview!.isNotEmpty) ...[
                                    SizedBox(height: 6.h),
                                    Text(
                                      s.overview!,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: AppColors.bodyText,
                                        fontSize: 12.sp,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (detail != null &&
                      detail.productionCompanies.isNotEmpty) ...[
                    SizedBox(height: 25.h),
                    Text(
                      'Production',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      child: Row(
                        children: detail.productionCompanies.map((p) {
                          return Padding(
                            padding: EdgeInsets.only(right: 16.w),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (p.logoPath != null) ...[
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    padding: EdgeInsets.all(4.r),
                                    child: Artwork(
                                      path: p.logoPath,
                                      width: 24.w,
                                      height: 24.w,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                ],
                                Text(
                                  p.name,
                                  style: TextStyle(
                                    color: AppColors.muted,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                  SizedBox(height: 30.h),
                  const Divider(color: AppColors.white24),
                  SizedBox(height: 10.h),
                  Text(
                    AppStrings.discoverMore,
                    style: TextStyle(color: AppColors.muted, fontSize: 12.sp),
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
