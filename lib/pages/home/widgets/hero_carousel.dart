import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flixora/resources/layout_app.dart';
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
  final PageController _controller = PageController(viewportFraction: .91);
  late final HomeProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = context.read<HomeProvider>();
    _provider.addListener(_syncPage);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.startHeroAutoScroll();
    });
  }

  void _syncPage() {
    if (!_controller.hasClients) return;
    final target = _provider.heroIndex;
    if ((_controller.page?.round() ?? 0) != target) {
      _controller.animateToPage(
        target,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _provider.removeListener(_syncPage);
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final items = context.watch<HomeProvider>().heroes;
    final heroHeight = AppLayout.heroHeight(context);
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
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: LoadingBlock(
          width: MediaQuery.sizeOf(context).width - 40.w,
          height: heroHeight,
          radius: 8.r,
        ),
      );
    }
    return Column(
      children: [
        SizedBox(
          height: heroHeight,
          child: PageView.builder(
            itemCount: items.length,
            controller: _controller,
            onPageChanged: (value) => _provider.setHeroIndex(value),
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Artwork(
                        path: item.posterPath ?? item.backdropPath,
                        width: double.infinity,
                        height: heroHeight,
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
                        left: 22.w,
                        right: 22.w,
                        bottom: 23.h,
                        child: Column(
                          children: [
                            Text(
                              item.title,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 30.sp,
                                fontWeight: FontWeight.w900,
                                height: 1.05,
                                shadows: [
                                  Shadow(
                                    color: AppColors.black87,
                                    blurRadius: 16.r,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              '${item.type.label.toUpperCase()}  •  ${item.year}  •  ★ ${item.rating.toStringAsFixed(1)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2.sp,
                              ),
                            ),
                            SizedBox(height: 17.h),
                            Row(
                              children: [
                                Expanded(
                                  child: FilledButton.icon(
                                    style: FilledButton.styleFrom(
                                      minimumSize: Size(double.infinity, 38.h),
                                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6.r),
                                      ),
                                    ),
                                    onPressed: () => openDetail(
                                      context,
                                      item,
                                      'hero-${item.key}-$index',
                                    ),
                                    icon: Icon(
                                      Icons.info_outline_rounded,
                                      size: 16.r,
                                    ),
                                    label: Text(
                                      AppStrings.details,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 13.sp),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 9.w),
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
        SizedBox(height: 13.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            items.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: _provider.heroIndex == index ? 20.w : 5.w,
              height: 5.h,
              margin: EdgeInsets.symmetric(horizontal: 3.w),
              decoration: BoxDecoration(
                color: _provider.heroIndex == index ? AppColors.accent : AppColors.white38,
                borderRadius: BorderRadius.circular(3.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
