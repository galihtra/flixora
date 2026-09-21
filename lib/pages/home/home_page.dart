import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flixora/data/model/models.dart';
import 'package:flixora/data/providers/home/home_provider.dart';
import 'package:flixora/components/header/browse_header.dart';
import 'package:flixora/pages/home/widgets/hero_carousel.dart';
import 'package:flixora/pages/home/widgets/category_rail.dart';
import 'package:flixora/resources/colors_app.dart';

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
      color: AppColors.accent,
      onRefresh: () => context.read<HomeProvider>().refresh(),
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: BrowseHeader(title: null)),
          const SliverToBoxAdapter(child: HeroCarousel()),
          SliverToBoxAdapter(child: SizedBox(height: 18.h)),
          for (final category in Categories.home)
            SliverToBoxAdapter(child: CategoryRail(category: category)),
          SliverToBoxAdapter(child: SizedBox(height: 28.h)),
        ],
      ),
    ),
  );
}
