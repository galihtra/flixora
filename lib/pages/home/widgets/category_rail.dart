import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flixora/app/app_routes.dart';
import 'package:flixora/data/model/models.dart';
import 'package:flixora/components/loading/poster_skeleton_row.dart';
import 'package:flixora/components/network_error/error_message.dart';
import 'package:flixora/components/poster/poster_card.dart';
import 'package:flixora/data/providers/home/home_provider.dart';
import 'package:flixora/resources/colors_app.dart';
import 'package:flixora/resources/strings_app.dart';

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
                onPressed: () => context.push(AppRoutes.category(category)),
                child: const Text(
                  AppStrings.seeAll,
                  style: TextStyle(color: AppColors.muted, fontSize: 12),
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
