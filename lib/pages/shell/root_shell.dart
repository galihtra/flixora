import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flixora/app/app_routes.dart';
import 'package:flixora/resources/colors_app.dart';
import 'package:flixora/resources/strings_app.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.location, required this.child});
  final String location;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final index = switch (location) {
      AppRoutes.movies => 1,
      AppRoutes.tv => 2,
      AppRoutes.myList => 3,
      _ => 0,
    };
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        height: 68,
        backgroundColor: AppColors.navigation,
        indicatorColor: AppColors.accent.withValues(alpha: .16),
        selectedIndex: index,
        onDestinationSelected: (value) => context.go(
          [
            AppRoutes.home,
            AppRoutes.movies,
            AppRoutes.tv,
            AppRoutes.myList,
          ][value],
        ),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: AppStrings.home,
          ),
          NavigationDestination(
            icon: Icon(Icons.movie_outlined),
            selectedIcon: Icon(Icons.movie),
            label: AppStrings.movies,
          ),
          NavigationDestination(
            icon: Icon(Icons.live_tv_outlined),
            selectedIcon: Icon(Icons.live_tv),
            label: AppStrings.tvShows,
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border),
            selectedIcon: Icon(Icons.bookmark),
            label: AppStrings.myList,
          ),
        ],
      ),
    );
  }
}
