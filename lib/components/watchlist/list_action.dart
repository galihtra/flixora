import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flixora/data/model/models.dart';
import 'package:flixora/data/providers/watchlist/watchlist_provider.dart';
import 'package:flixora/resources/colors_app.dart';
import 'package:flixora/resources/strings_app.dart';

class ListAction extends StatelessWidget {
  const ListAction({super.key, required this.item, this.fullWidth = false});
  final MediaItem item;
  final bool fullWidth;
  @override
  Widget build(BuildContext context) {
    final saved = context.select<WatchlistProvider, bool>(
      (provider) => provider.contains(item),
    );
    return OutlinedButton.icon(
      onPressed: () => context.read<WatchlistProvider>().toggle(item),
      icon: Icon(saved ? Icons.check_rounded : Icons.add_rounded),
      label: Text(saved ? AppStrings.inMyList : AppStrings.myList),
      style: OutlinedButton.styleFrom(
        minimumSize: Size(fullWidth ? double.infinity : 0, 46),
        side: const BorderSide(color: AppColors.white54),
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }
}
