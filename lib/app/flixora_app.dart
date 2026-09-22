import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flixora/app/app_router.dart';
import 'package:flixora/data/repositories/media_repository.dart';
import 'package:flixora/data/providers/home/home_provider.dart';
import 'package:flixora/data/providers/watchlist/watchlist_provider.dart';
import 'package:flixora/data/providers/genre/genre_provider.dart';
import 'package:flixora/resources/styles_app.dart';
import 'package:flixora/resources/strings_app.dart';

class FlixoraApp extends StatefulWidget {
  const FlixoraApp({super.key, required this.repository});
  final MediaRepository repository;

  @override
  State<FlixoraApp> createState() => _FlixoraAppState();
}

class _FlixoraAppState extends State<FlixoraApp> {
  late final HomeProvider home = HomeProvider(widget.repository);
  late final GenreProvider genre = GenreProvider(widget.repository);
  late final WatchlistProvider watchlist = WatchlistProvider(
    PreferencesWatchlistStore(),
    repository: widget.repository,
  )..load();
  late final router = createAppRouter(widget.repository);

  @override
  void dispose() {
    router.dispose();
    home.dispose();
    genre.dispose();
    watchlist.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      Provider<MediaRepository>.value(value: widget.repository),
      ChangeNotifierProvider<HomeProvider>.value(value: home),
      ChangeNotifierProvider<GenreProvider>.value(value: genre),
      ChangeNotifierProvider<WatchlistProvider>.value(value: watchlist),
    ],
    child: ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp.router(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        routerConfig: router,
      ),
    ),
  );
}
