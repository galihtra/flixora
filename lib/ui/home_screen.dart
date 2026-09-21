import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../core/models.dart';
import '../features/home/home_provider.dart';
import 'widgets/common_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<HomeProvider>().ensureLoaded();
    });
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: RefreshIndicator(
      color: AppTheme.accent,
      onRefresh: () => context.read<HomeProvider>().refresh(),
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: BrowseHeader(title: null)),
          const SliverToBoxAdapter(child: HeroCarousel()),
          const SliverToBoxAdapter(child: SizedBox(height: 18)),
          for (final category in Categories.home)
            SliverToBoxAdapter(child: CategoryRail(category: category)),
          const SliverToBoxAdapter(child: SizedBox(height: 28)),
        ],
      ),
    ),
  );
}

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key, required this.type});
  final MediaType type;
  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<HomeProvider>().ensureLoaded();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = widget.type == MediaType.movie
        ? Categories.movies
        : Categories.tv;
    return SafeArea(
      child: RefreshIndicator(
        color: AppTheme.accent,
        onRefresh: () => context.read<HomeProvider>().refresh(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: BrowseHeader(
                title: widget.type == MediaType.movie ? 'Movies' : 'TV Shows',
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.type == MediaType.movie
                          ? 'Stories worth watching.'
                          : 'Your next obsession starts here.',
                      style: const TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -.7,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Explore the best of TMDB',
                      style: TextStyle(color: AppTheme.muted),
                    ),
                  ],
                ),
              ),
            ),
            for (final category in categories)
              SliverToBoxAdapter(child: CategoryRail(category: category)),
            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }
}

class BrowseHeader extends StatelessWidget {
  const BrowseHeader({super.key, this.title});
  final String? title;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 9, 12, 5),
    child: Row(
      children: [
        const Brand(),
        if (title != null) ...[
          const SizedBox(width: 12),
          Container(width: 1, height: 18, color: Colors.white30),
          const SizedBox(width: 12),
          Text(title!, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
        const Spacer(),
        IconButton(
          tooltip: 'Search',
          onPressed: () => context.push('/search'),
          icon: const Icon(Icons.search_rounded, size: 27),
        ),
      ],
    ),
  );
}

class HeroCarousel extends StatefulWidget {
  const HeroCarousel({super.key});
  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  int active = 0;
  final PageController _controller = PageController(viewportFraction: .91);
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = context.watch<HomeProvider>().heroes;
    if (items.isEmpty) {
      final state = context.read<HomeProvider>().state(
        Categories.popularMovies,
      );
      if (state.error != null) {
        return ErrorMessage(
          error: state.error!,
          retry: () => context.read<HomeProvider>().loadCategory(
            Categories.popularMovies,
          ),
        );
      }
      if (!state.loading) {
        return const StateMessage(
          icon: Icons.movie_filter_outlined,
          title: 'Nothing Here Yet',
          message: 'Pull down to refresh the catalog.',
        );
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: LoadingBlock(
          width: MediaQuery.sizeOf(context).width - 40,
          height: 420,
          radius: 8,
        ),
      );
    }
    return Column(
      children: [
        SizedBox(
          height: 450,
          child: PageView.builder(
            itemCount: items.length,
            controller: _controller,
            onPageChanged: (value) => setState(() => active = value),
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Artwork(
                        path: item.posterPath ?? item.backdropPath,
                        width: double.infinity,
                        height: 450,
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black26,
                              Colors.transparent,
                              Color(0xE8000000),
                            ],
                            stops: [0, .4, 1],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 22,
                        right: 22,
                        bottom: 23,
                        child: Column(
                          children: [
                            Text(
                              item.title,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                height: 1.05,
                                shadows: [
                                  Shadow(color: Colors.black87, blurRadius: 16),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${item.type.label.toUpperCase()}  •  ${item.year}  •  ★ ${item.rating.toStringAsFixed(1)}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 17),
                            Row(
                              children: [
                                Expanded(
                                  child: FilledButton.icon(
                                    onPressed: () => openDetail(
                                      context,
                                      item,
                                      'hero-${item.key}-$index',
                                    ),
                                    icon: const Icon(
                                      Icons.info_outline_rounded,
                                    ),
                                    label: const Text('Details'),
                                  ),
                                ),
                                const SizedBox(width: 9),
                                Expanded(
                                  child: ListAction(
                                    item: item,
                                    fullWidth: true,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 13),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            items.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: active == index ? 20 : 5,
              height: 5,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: active == index ? AppTheme.accent : Colors.white38,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CategoryRail extends StatelessWidget {
  const CategoryRail({super.key, required this.category});
  final CatalogCategory category;
  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeProvider>().state(category);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 12, 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  category.title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -.35,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => context.push(
                  '/category/${category.path.substring(1).replaceAll('/', '-')}',
                ),
                child: const Text(
                  'See All',
                  style: TextStyle(color: AppTheme.muted, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        if (state.items.isNotEmpty)
          SizedBox(
            height: 226,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: state.items.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (_, index) =>
                  PosterCard(item: state.items[index], scope: category.path),
            ),
          )
        else if (state.error != null)
          ErrorMessage(
            error: state.error!,
            compact: true,
            retry: () => context.read<HomeProvider>().loadCategory(category),
          )
        else if (state.loading)
          const PosterSkeletonRow()
        else
          const SizedBox(height: 40),
        const SizedBox(height: 5),
      ],
    );
  }
}
