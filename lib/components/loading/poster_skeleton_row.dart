import 'package:flutter/material.dart';
import 'package:flixora/components/loading/loading_block.dart';

class PosterSkeletonRow extends StatelessWidget {
  const PosterSkeletonRow({super.key});
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 219,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 5,
      separatorBuilder: (_, _) => const SizedBox(width: 10),
      itemBuilder: (_, _) => const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoadingBlock(width: 120, height: 180),
          SizedBox(height: 8),
          LoadingBlock(width: 92, height: 10),
        ],
      ),
    ),
  );
}
