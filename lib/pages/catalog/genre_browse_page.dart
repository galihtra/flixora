import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flixora/data/model/models.dart';
import 'package:flixora/data/providers/genre/genre_browse_provider.dart';
import 'package:flixora/data/providers/catalog/catalog_provider.dart';
import 'package:flixora/components/loading/poster_grid_skeleton.dart';
import 'package:flixora/components/network_error/error_message.dart';
import 'package:flixora/components/network_error/state_message.dart';
import 'package:flixora/components/poster/poster_card.dart';
import 'package:flixora/resources/colors_app.dart';
import 'package:flixora/resources/layout_app.dart';
import 'package:flixora/resources/strings_app.dart';

class GenreBrowsePage extends StatefulWidget {
  const GenreBrowsePage({super.key, required this.genre, required this.type});

  final Genre genre;
  final MediaType type;

  @override
  State<GenreBrowsePage> createState() => _GenreBrowsePageState();
}

class _GenreBrowsePageState extends State<GenreBrowsePage> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.extentAfter < 500) {
        context.read<GenreBrowseProvider>().loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GenreBrowseProvider>();

    if (provider.status == LoadStatus.loading) {
      return const PosterGridSkeleton();
    }

    if (provider.status == LoadStatus.error) {
      return Center(
        child: ErrorMessage(error: provider.error!, retry: provider.retry),
      );
    }

    if (provider.status == LoadStatus.empty) {
      return const StateMessage(
        icon: Icons.movie_filter_outlined,
        title: AppStrings.nothingHereYet,
        message: AppStrings.checkBackLater,
      );
    }

    return RefreshIndicator(
      color: AppColors.accent,
      onRefresh: provider.refresh,
      child: CustomScrollView(
        controller: _scroll,
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              AppLayout.pageInset,
              12.h,
              AppLayout.pageInset,
              16.h,
            ),
            sliver: SliverLayoutBuilder(
              builder: (context, constraints) {
                final available =
                    constraints.crossAxisExtent + 2 * AppLayout.pageInset;
                final columns = AppLayout.columns(available);
                final gap = AppLayout.gridGap;
                final width =
                    (constraints.crossAxisExtent - (columns - 1) * gap) /
                    columns;
                return SliverGrid.builder(
                  itemCount: provider.items.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: gap,
                    mainAxisSpacing: AppLayout.rowGap,
                    mainAxisExtent: AppLayout.posterTileHeight(context, width),
                  ),
                  itemBuilder: (context, index) => PosterCard(
                    item: provider.items[index],
                    scope: 'genre-${widget.genre.id}',
                    width: width,
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: provider.isLoadingMore
                ? Padding(
                    padding: EdgeInsets.all(20.r),
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : provider.loadMoreError != null
                ? ErrorMessage(
                    error: provider.loadMoreError!,
                    compact: true,
                    retry: provider.retryLoadMore,
                  )
                : SizedBox(height: 18.h),
          ),
        ],
      ),
    );
  }
}
