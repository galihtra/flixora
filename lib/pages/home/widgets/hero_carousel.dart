import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flixora/data/model/models.dart';
import 'package:flixora/app/navigation.dart';
import 'package:flixora/base_widgets/image/artwork.dart';
import 'package:flixora/components/loading/loading_block.dart';
import 'package:flixora/components/network_error/state_message.dart';
import 'package:flixora/components/network_error/error_message.dart';
import 'package:flixora/components/watchlist/list_action.dart';
import 'package:flixora/data/providers/home/home_provider.dart';
import 'package:flixora/resources/colors_app.dart';
import 'package:flixora/resources/strings_app.dart';

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
          title: AppStrings.nothingHereYet,
          message: AppStrings.pullToRefresh,
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
                              AppColors.black26,
                              AppColors.transparent,
                              AppColors.heroBottom,
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
                                  Shadow(
                                    color: AppColors.black87,
                                    blurRadius: 16,
                                  ),
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
                                    label: const Text(AppStrings.details),
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
                color: active == index ? AppColors.accent : AppColors.white38,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
