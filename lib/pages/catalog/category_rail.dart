import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/model/catalog_category.dart';
import '../../data/model/media_type.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/model/genre_model.dart';
import '../../data/providers/genre/genre_browse_provider.dart';
import '../../data/providers/home/home_provider.dart';
import '../../data/repositories/media_repository.dart';
import '../../resources/colors_app.dart';
import '../../resources/strings_app.dart';
import '../home/widgets/category_rail.dart';
import 'genre_browse_page.dart';


class CategoryRailView extends StatelessWidget {
  const CategoryRailView({super.key, required this.categories, required this.type});
  final List<CatalogCategory> categories;
  final MediaType type;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.accent,
      onRefresh: () => context.read<HomeProvider>().refresh(),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type == MediaType.movie
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
    );
  }
}


class GenreGridView extends StatelessWidget {
  const GenreGridView({super.key, required this.genre, required this.type});
  final Genre genre;
  final MediaType type;

  @override
  Widget build(BuildContext context) {
    final repository = context.read<MediaRepository>();
    return ChangeNotifierProvider(
      create: (_) => GenreBrowseProvider(repository, type, genre)..load(),
      child: GenreBrowsePage(genre: genre, type: type),
    );
  }
}