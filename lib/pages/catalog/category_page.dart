import 'package:flixora/resources/values_app.dart';
import 'package:flutter/material.dart';
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
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    sliver: SliverLayoutBuilder(
                      builder: (context, constraints) {
                        final width = (constraints.crossAxisExtent - 20) / 3;
                        return SliverGrid.builder(
                          itemCount: provider.items.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 15,
                                mainAxisExtent:
                                    width * AppValues.posterRatio + 40,
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
                        ? const Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : provider.loadMoreError != null
                        ? ErrorMessage(
                            error: provider.loadMoreError!,
                            compact: true,
                            retry: provider.retryLoadMore,
                          )
                        : const SizedBox(height: 18),
                  ),
                ],
              ),
            ),
    );
  }
}
