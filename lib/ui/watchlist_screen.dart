import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../core/copy.dart';
import '../features/watchlist/watchlist_provider.dart';
import 'widgets/common_widgets.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WatchlistProvider>();
    final items = provider.items;
    return SafeArea(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 18, 20, 15),
            child: Row(
              children: [
                Text(
                  Copy.myList,
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800),
                ),
                Spacer(),
                Icon(Icons.bookmark_rounded, color: AppTheme.accent),
              ],
            ),
          ),
          Expanded(
            child: !provider.ready
                ? const Center(child: CircularProgressIndicator())
                : items.isEmpty
                ? StateMessage(
                    icon: Icons.bookmark_add_outlined,
                    title: Copy.emptyList,
                    message: Copy.emptyListBody,
                    actionLabel: Copy.exploreMovies,
                    action: () => context.go('/movies'),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final width = (constraints.maxWidth - 52) / 3;
                      return GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 25),
                        itemCount: items.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 15,
                          mainAxisExtent: width * 1.5 + 40,
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
