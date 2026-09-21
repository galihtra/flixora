import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flixora/resources/layout_app.dart';
import 'package:provider/provider.dart';
import 'package:flixora/components/loading/poster_grid_skeleton.dart';
import 'package:flixora/components/network_error/error_message.dart';
import 'package:flixora/components/network_error/state_message.dart';
import 'package:flixora/components/poster/poster_card.dart';
import 'package:flixora/data/providers/search/search_provider.dart';
import 'package:flixora/resources/colors_app.dart';
import 'package:flixora/resources/strings_app.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.extentAfter < 500) {
        context.read<SearchProvider>().loadMore();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.search,
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(18.w, 4.h, 18.w, 18.h),
            child: TextField(
              controller: _controller,
              autofocus: true,
              onChanged: context.read<SearchProvider>().updateQuery,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: AppStrings.searchHint,
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _controller.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: AppStrings.clearSearch,
                        onPressed: () {
                          _controller.clear();
                          context.read<SearchProvider>().updateQuery('');
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(child: _results(provider)),
        ],
      ),
    );
  }

  Widget _results(SearchProvider provider) {
    if (provider.query.isEmpty) {
      return const StateMessage(
        icon: Icons.search_rounded,
        title: AppStrings.searchInitialTitle,
        message: AppStrings.searchInitialBody,
      );
    }
    if (provider.query.length < 2) {
      return const StateMessage(
        icon: Icons.search_rounded,
        title: AppStrings.keepTyping,
        message: AppStrings.minSearchBody,
      );
    }
    if (provider.debouncing) {
      return const StateMessage(
        icon: Icons.search_rounded,
        title: AppStrings.searchingSoon,
        message: AppStrings.searchingBody,
      );
    }
    if (provider.loading && provider.items.isEmpty) {
      return const PosterGridSkeleton();
    }
    if (provider.error != null && provider.items.isEmpty) {
      return ErrorMessage(error: provider.error!, retry: provider.retry);
    }
    if (!provider.loading && provider.items.isEmpty) {
      return const StateMessage(
        icon: Icons.search_off_rounded,
        title: AppStrings.noResults,
        message: AppStrings.noResultsBody,
      );
    }
    final available = MediaQuery.sizeOf(context).width;
    final columns = AppLayout.columns(available);
    final gap = AppLayout.gridGap;
    final width = AppLayout.posterWidth(available);
    return CustomScrollView(
      controller: _scroll,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            AppLayout.pageInset,
            0,
            AppLayout.pageInset,
            16.h,
          ),
          sliver: SliverGrid.builder(
            itemCount: provider.items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: gap,
              mainAxisSpacing: AppLayout.rowGap,
              mainAxisExtent: AppLayout.posterTileHeight(context, width),
            ),
            itemBuilder: (context, index) => PosterCard(
              item: provider.items[index],
              scope: 'search-${provider.query}',
              width: width,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: provider.loadingMore
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
              : SizedBox(height: 16.h),
        ),
      ],
    );
  }
}
