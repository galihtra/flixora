import 'package:flutter/material.dart';
import 'package:flixora/components/loading/loading_block.dart';

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
