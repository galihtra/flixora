import 'package:flutter/material.dart';
import 'package:flixora/components/loading/loading_block.dart';
import 'package:flixora/resources/values_app.dart';

class PosterGridSkeleton extends StatelessWidget {
  const PosterGridSkeleton({super.key});
  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.sizeOf(context).width - 52) / 3;
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 12,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 15,
        mainAxisExtent: width * AppValues.posterRatio + 40,
      ),
      itemBuilder: (_, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoadingBlock(width: width, height: width * AppValues.posterRatio),
          const SizedBox(height: 8),
          LoadingBlock(width: width * .75, height: 10),
        ],
      ),
    );
  }
}
