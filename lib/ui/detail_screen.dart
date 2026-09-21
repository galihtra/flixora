import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../core/models.dart';
import '../features/detail/detail_provider.dart';
import 'widgets/common_widgets.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, this.args});
  final DetailArgs? args;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DetailProvider>();
    final detail = provider.detail;
    final item = detail?.item ?? args?.item;
    if (item == null) {
      return Scaffold(
        appBar: AppBar(),
        body: provider.error != null
            ? ErrorMessage(error: provider.error!, retry: provider.load)
            : const DetailSkeleton(),
      );
    }
    final screen = MediaQuery.sizeOf(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: screen.width * 9 / 16 + 44,
            backgroundColor: AppTheme.background,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Artwork(
                    path: item.backdropPath ?? item.posterPath,
                    backdrop: item.backdropPath != null,
                    width: screen.width,
                    height: screen.width * 9 / 16 + 44,
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black38,
                          Colors.transparent,
                          AppTheme.background,
                        ],
                        stops: [0, .48, 1],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Artwork(
                          path: item.posterPath,
                          width: 104,
                          height: 156,
                          heroTag: args?.heroTag,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.accent,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text(
                                item.type.label.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w900,
                                height: 1.07,
                              ),
                            ),
                            const SizedBox(height: 11),
                            Wrap(
                              spacing: 8,
                              runSpacing: 5,
                              children: [
                                Text(
                                  item.year,
                                  style: const TextStyle(color: AppTheme.muted),
                                ),
                                if (detail != null &&
                                    detail.durationLabel.isNotEmpty)
                                  Text(
                                    '•  ${detail.durationLabel}',
                                    style: const TextStyle(
                                      color: AppTheme.muted,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 23),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFFFC857),
                        size: 26,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        item.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        '/ 10',
                        style: TextStyle(color: AppTheme.muted),
                      ),
                      if (item.voteCount > 0) ...[
                        const SizedBox(width: 12),
                        Text(
                          '(${item.voteCount} votes)',
                          style: const TextStyle(
                            color: AppTheme.muted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                      const Spacer(),
                      const Text(
                        'TMDB',
                        style: TextStyle(
                          color: AppTheme.muted,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 19),
                  ListAction(item: item, fullWidth: true),
                  if (provider.error != null) ...[
                    const SizedBox(height: 14),
                    ErrorMessage(
                      error: provider.error!,
                      retry: provider.load,
                      compact: true,
                    ),
                  ],
                  if (provider.loading) ...[
                    const SizedBox(height: 18),
                    const LinearProgressIndicator(
                      color: AppTheme.accent,
                      backgroundColor: AppTheme.surface,
                    ),
                  ],
                  if (detail != null && detail.genres.isNotEmpty) ...[
                    const SizedBox(height: 25),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: detail.genres
                          .map(
                            (genre) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 11,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.surface,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                genre,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: 27),
                  const Text(
                    'Overview',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    item.overview.isEmpty
                        ? 'No overview available yet.'
                        : item.overview,
                    style: const TextStyle(
                      color: Color(0xFFD4D4D4),
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 10),
                  const Text(
                    'Discover more on FLIXORA',
                    style: TextStyle(color: AppTheme.muted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailSkeleton extends StatelessWidget {
  const DetailSkeleton({super.key});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoadingBlock(width: width, height: width * 9 / 16, radius: 0),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LoadingBlock(width: 180, height: 28),
                const SizedBox(height: 16),
                const LoadingBlock(width: 115, height: 18),
                const SizedBox(height: 25),
                LoadingBlock(width: width - 40, height: 48),
                const SizedBox(height: 30),
                const LoadingBlock(width: 135, height: 22),
                const SizedBox(height: 14),
                LoadingBlock(width: width - 40, height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
