import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flixora/data/model/models.dart';
import 'package:flixora/data/providers/home/home_provider.dart';
import 'package:flixora/components/header/browse_header.dart';
import 'package:flixora/pages/home/widgets/category_rail.dart';
import 'package:flixora/resources/colors_app.dart';
import 'package:flixora/resources/strings_app.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key, required this.type});
  final MediaType type;
  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<HomeProvider>().ensureLoaded();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = widget.type == MediaType.movie
        ? Categories.movies
        : Categories.tv;
    return SafeArea(
      child: RefreshIndicator(
        color: AppColors.accent,
        onRefresh: () => context.read<HomeProvider>().refresh(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: BrowseHeader(
                title: widget.type == MediaType.movie
                    ? AppStrings.movies
                    : AppStrings.tvShows,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.type == MediaType.movie
                          ? AppStrings.moviesTagline
                          : AppStrings.tvTagline,
                      style: TextStyle(
                        fontSize: 27.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -.7,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      AppStrings.exploreTmdb,
                      style: TextStyle(color: AppColors.muted, fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
            ),
            for (final category in categories)
              SliverToBoxAdapter(child: CategoryRail(category: category)),
            SliverToBoxAdapter(child: SizedBox(height: 30.h)),
          ],
        ),
      ),
    );
  }
}
