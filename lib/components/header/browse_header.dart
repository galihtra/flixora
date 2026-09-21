import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flixora/app/app_routes.dart';
import 'package:flixora/components/branding/brand.dart';
import 'package:flixora/resources/colors_app.dart';
import 'package:flixora/resources/strings_app.dart';

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
          Container(width: 1, height: 18, color: AppColors.white30),
          const SizedBox(width: 12),
          Text(title!, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
        const Spacer(),
        IconButton(
          tooltip: AppStrings.search,
          onPressed: () => context.push(AppRoutes.search),
          icon: const Icon(Icons.search_rounded, size: 27),
        ),
      ],
    ),
  );
}
