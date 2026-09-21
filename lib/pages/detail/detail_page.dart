import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flixora/app/navigation.dart';
import 'package:flixora/data/model/models.dart';
import 'package:flixora/base_widgets/image/artwork.dart';
import 'package:flixora/components/loading/detail_skeleton.dart';
import 'package:flixora/components/network_error/error_message.dart';
import 'package:flixora/components/watchlist/list_action.dart';
import 'package:flixora/data/providers/detail/detail_provider.dart';
import 'package:flixora/resources/colors_app.dart';
import 'package:flixora/resources/strings_app.dart';

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
            backgroundColor: AppColors.background,
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
                          AppColors.black38,
                          AppColors.transparent,
                          AppColors.background,
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
                                color: AppColors.accent,
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
                                  style: const TextStyle(
                                    color: AppColors.muted,
                                  ),
                                ),
                                if (detail != null &&
                                    detail.durationLabel.isNotEmpty)
                                  Text(
                                    '•  ${detail.durationLabel}',
                                    style: const TextStyle(
                                      color: AppColors.muted,
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
                        color: AppColors.rating,
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
                        style: TextStyle(color: AppColors.muted),
                      ),
                      if (item.voteCount > 0) ...[
                        const SizedBox(width: 12),
                        Text(
                          '(${item.voteCount} votes)',
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                      const Spacer(),
                      const Text(
                        AppStrings.tmdb,
                        style: TextStyle(
                          color: AppColors.muted,
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
                      color: AppColors.accent,
                      backgroundColor: AppColors.surface,
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
                                color: AppColors.surface,
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
                    AppStrings.overview,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    item.overview.isEmpty
                        ? AppStrings.noOverview
                        : item.overview,
                    style: const TextStyle(
                      color: AppColors.bodyText,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Divider(color: AppColors.white24),
                  const SizedBox(height: 10),
                  const Text(
                    AppStrings.discoverMore,
                    style: TextStyle(color: AppColors.muted, fontSize: 12),
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
