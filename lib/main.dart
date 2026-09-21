import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'core/app_theme.dart';
import 'core/models.dart';
import 'data/api.dart';
import 'features/catalog/catalog_provider.dart';
import 'features/detail/detail_provider.dart';
import 'features/home/home_provider.dart';
import 'features/search/search_provider.dart';
import 'features/watchlist/watchlist_provider.dart';
import 'ui/catalog_screen.dart';
import 'ui/detail_screen.dart';
import 'ui/home_screen.dart';
import 'ui/search_screen.dart';
import 'ui/watchlist_screen.dart';
import 'ui/widgets/common_widgets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  const token = String.fromEnvironment('TMDB_TOKEN');
  final repository = TmdbRepository(ApiClient(token: token));
  unawaited(repository.loadImageConfiguration());
  runApp(FlixoraApp(repository: repository));
}

class FlixoraApp extends StatefulWidget {
  const FlixoraApp({super.key, required this.repository});
  final MediaRepository repository;
  @override
  State<FlixoraApp> createState() => _FlixoraAppState();
}

class _FlixoraAppState extends State<FlixoraApp> {
  late final HomeProvider home = HomeProvider(widget.repository);
  late final WatchlistProvider watchlist = WatchlistProvider(
    PreferencesWatchlistStore(),
  )..load();
  late final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(location: state.uri.path, child: child),
        routes: [
          GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
          GoRoute(
            path: '/movies',
            builder: (_, _) => const BrowseScreen(type: MediaType.movie),
          ),
          GoRoute(
            path: '/tv',
            builder: (_, _) => const BrowseScreen(type: MediaType.tv),
          ),
          GoRoute(path: '/my-list', builder: (_, _) => const WatchlistScreen()),
        ],
      ),
      GoRoute(
        path: '/search',
        builder: (_, _) => ChangeNotifierProvider(
          create: (_) => SearchProvider(widget.repository),
          child: const SearchScreen(),
        ),
      ),
      GoRoute(
        path: '/category/:name',
        builder: (_, state) {
          final name = state.pathParameters['name'];
          final category = Categories.home
              .where(
                (item) => item.path.substring(1).replaceAll('/', '-') == name,
              )
              .firstOrNull;
          if (category == null) {
            return const Scaffold(
              body: Center(child: Text('Category not found')),
            );
          }
          return ChangeNotifierProvider(
            create: (_) => CatalogProvider(widget.repository, category)..load(),
            child: CategoryScreen(category: category),
          );
        },
      ),
      GoRoute(
        path: '/detail/:type/:id',
        builder: (_, state) {
          final type = state.pathParameters['type'] == 'tv'
              ? MediaType.tv
              : MediaType.movie;
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return ChangeNotifierProvider(
            create: (_) => DetailProvider(widget.repository, type, id)..load(),
            child: DetailScreen(
              args: state.extra is DetailArgs
                  ? state.extra as DetailArgs
                  : null,
            ),
          );
        },
      ),
    ],
  );

  @override
  void dispose() {
    router.dispose();
    home.dispose();
    watchlist.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      Provider<MediaRepository>.value(value: widget.repository),
      ChangeNotifierProvider<HomeProvider>.value(value: home),
      ChangeNotifierProvider<WatchlistProvider>.value(value: watchlist),
    ],
    child: MaterialApp.router(
      title: 'FLIXORA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: router,
    ),
  );
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1200), () {
      if (mounted) context.go('/home');
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.play_arrow_rounded, color: AppTheme.accent, size: 82),
          SizedBox(height: 4),
          Brand(size: 36),
          SizedBox(height: 10),
          Text(
            'DISCOVER WHAT MOVES YOU',
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 2.4,
              color: AppTheme.muted,
            ),
          ),
        ],
      ),
    ),
  );
}

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.location, required this.child});
  final String location;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final index = switch (location) {
      '/movies' => 1,
      '/tv' => 2,
      '/my-list' => 3,
      _ => 0,
    };
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        height: 68,
        backgroundColor: const Color(0xFF101010),
        indicatorColor: AppTheme.accent.withValues(alpha: .16),
        selectedIndex: index,
        onDestinationSelected: (value) =>
            context.go(['/home', '/movies', '/tv', '/my-list'][value]),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.movie_outlined),
            selectedIcon: Icon(Icons.movie),
            label: 'Movies',
          ),
          NavigationDestination(
            icon: Icon(Icons.live_tv_outlined),
            selectedIcon: Icon(Icons.live_tv),
            label: 'TV Shows',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border),
            selectedIcon: Icon(Icons.bookmark),
            label: 'My List',
          ),
        ],
      ),
    );
  }
}
