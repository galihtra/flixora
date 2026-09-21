import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flixora/app/app_routes.dart';
import 'package:flixora/app/navigation.dart';
import 'package:flixora/data/model/models.dart';
import 'package:flixora/data/repositories/media_repository.dart';
import 'package:flixora/data/providers/catalog/catalog_provider.dart';
import 'package:flixora/data/providers/detail/detail_provider.dart';
import 'package:flixora/data/providers/search/search_provider.dart';
import 'package:flixora/pages/catalog/browse_page.dart';
import 'package:flixora/pages/catalog/category_page.dart';
import 'package:flixora/pages/detail/detail_page.dart';
import 'package:flixora/pages/home/home_page.dart';
import 'package:flixora/pages/search/search_page.dart';
import 'package:flixora/pages/shell/root_shell.dart';
import 'package:flixora/pages/splash/splash_page.dart';
import 'package:flixora/pages/watchlist/watchlist_page.dart';
import 'package:flixora/resources/strings_app.dart';

GoRouter createAppRouter(MediaRepository repository) => GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(path: AppRoutes.splash, builder: (_, _) => const SplashScreen()),
    ShellRoute(
      builder: (context, state, child) =>
          AppShell(location: state.uri.path, child: child),
      routes: [
        GoRoute(path: AppRoutes.home, builder: (_, _) => const HomeScreen()),
        GoRoute(
          path: AppRoutes.movies,
          builder: (_, _) => const BrowseScreen(type: MediaType.movie),
        ),
        GoRoute(
          path: AppRoutes.tv,
          builder: (_, _) => const BrowseScreen(type: MediaType.tv),
        ),
        GoRoute(
          path: AppRoutes.myList,
          builder: (_, _) => const WatchlistScreen(),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.search,
      builder: (_, _) => ChangeNotifierProvider(
        create: (_) => SearchProvider(repository),
        child: const SearchScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.categoryPattern,
      builder: (_, state) {
        final name = state.pathParameters['name'];
        final category = Categories.home
            .where(
              (item) => item.path.substring(1).replaceAll('/', '-') == name,
            )
            .firstOrNull;
        if (category == null) {
          return const Scaffold(
            body: Center(child: Text(AppStrings.categoryNotFound)),
          );
        }
        return ChangeNotifierProvider(
          create: (_) => CatalogProvider(repository, category)..load(),
          child: CategoryScreen(category: category),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.detailPattern,
      builder: (_, state) {
        final type = state.pathParameters['type'] == 'tv'
            ? MediaType.tv
            : MediaType.movie;
        final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
        return ChangeNotifierProvider(
          create: (_) => DetailProvider(repository, type, id)..load(),
          child: DetailScreen(
            args: state.extra is DetailArgs ? state.extra as DetailArgs : null,
          ),
        );
      },
    ),
  ],
);
