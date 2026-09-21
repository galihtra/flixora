import 'package:flixora/resources/values_app.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flixora/app/app_routes.dart';
import 'package:flixora/components/network_error/state_message.dart';
import 'package:flixora/components/poster/poster_card.dart';
import 'package:flixora/data/providers/watchlist/watchlist_provider.dart';
import 'package:flixora/resources/colors_app.dart';
import 'package:flixora/resources/strings_app.dart';

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
                  AppStrings.myList,
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800),
                ),
                Spacer(),
                Icon(Icons.bookmark_rounded, color: AppColors.accent),
              ],
            ),
          ),
          Expanded(
            child: !provider.ready
                ? const Center(child: CircularProgressIndicator())
                : items.isEmpty
                ? StateMessage(
                    icon: Icons.bookmark_add_outlined,
                    title: AppStrings.emptyList,
                    message: AppStrings.emptyListBody,
                    actionLabel: AppStrings.exploreMovies,
                    action: () => context.go(AppRoutes.movies),
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
                          mainAxisExtent: width * AppValues.posterRatio + 40,
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
