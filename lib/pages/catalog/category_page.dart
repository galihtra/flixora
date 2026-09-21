import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flixora/resources/layout_app.dart';
import 'package:provider/provider.dart';
import 'package:flixora/data/model/models.dart';
import 'package:flixora/components/loading/poster_grid_skeleton.dart';
import 'package:flixora/components/network_error/error_message.dart';
import 'package:flixora/components/network_error/state_message.dart';
import 'package:flixora/components/poster/poster_card.dart';
import 'package:flixora/data/providers/catalog/catalog_provider.dart';
import 'package:flixora/resources/colors_app.dart';
import 'package:flixora/resources/strings_app.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key, required this.category});
  final CatalogCategory category;
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _scroll = ScrollController();
  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.extentAfter < 500) {
        context.read<CatalogProvider>().loadMore();
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
    final provider = context.watch<CatalogProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: provider.status == LoadStatus.loading
          ? const PosterGridSkeleton()
          : provider.status == LoadStatus.error
          ? ErrorMessage(error: provider.error!, retry: provider.retry)
          : provider.status == LoadStatus.empty
          ? const StateMessage(
              icon: Icons.movie_filter_outlined,
              title: AppStrings.nothingHereYet,
              message: AppStrings.checkBackLater,
            )
          : RefreshIndicator(
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
                            constraints.crossAxisExtent +
                            2 * AppLayout.pageInset;
                        final columns = AppLayout.columns(available);
                        final gap = AppLayout.gridGap;
                        final width =
                            (constraints.crossAxisExtent -
                                (columns - 1) * gap) /
                            columns;
                        return SliverGrid.builder(
                          itemCount: provider.items.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                crossAxisSpacing: gap,
                                mainAxisSpacing: AppLayout.rowGap,
                                mainAxisExtent: AppLayout.posterTileHeight(
                                  context,
                                  width,
                                ),
                              ),
                          itemBuilder: (context, index) => PosterCard(
                            item: provider.items[index],
                            scope: 'grid-${widget.category.path}',
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
                            child: Center(child: CircularProgressIndicator()),
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
            ),
    );
  }
}
