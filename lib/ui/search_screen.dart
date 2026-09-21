import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../core/copy.dart';
import '../features/search/search_provider.dart';
import 'catalog_screen.dart';
import 'widgets/common_widgets.dart';

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
          Copy.search,
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 18),
            child: TextField(
              controller: _controller,
              autofocus: true,
              onChanged: context.read<SearchProvider>().updateQuery,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Search movies and TV shows',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _controller.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Clear search',
                        onPressed: () {
                          _controller.clear();
                          context.read<SearchProvider>().updateQuery('');
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
                filled: true,
                fillColor: AppTheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
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
        title: 'What are you looking for?',
        message: 'Search thousands of movies and TV shows.',
      );
    }
    if (provider.query.length < 2) {
      return const StateMessage(
        icon: Icons.search_rounded,
        title: 'Keep typing',
        message: 'Enter at least 2 characters to search.',
      );
    }
    if (provider.debouncing) {
      return const StateMessage(
        icon: Icons.search_rounded,
        title: 'Searching soon',
        message: 'Finding titles that match your search.',
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
        title: Copy.noResults,
        message: Copy.noResultsBody,
      );
    }
    final width = (MediaQuery.sizeOf(context).width - 52) / 3;
    return CustomScrollView(
      controller: _scroll,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          sliver: SliverGrid.builder(
            itemCount: provider.items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 15,
              mainAxisExtent: width * 1.5 + 40,
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
              : const SizedBox(height: 16),
        ),
      ],
    );
  }
}
