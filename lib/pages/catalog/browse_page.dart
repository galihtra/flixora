import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flixora/data/model/models.dart';
import 'package:flixora/data/providers/home/home_provider.dart';
import 'package:flixora/data/providers/genre/genre_provider.dart';
import 'package:flixora/components/header/browse_header.dart';
import 'package:flixora/resources/strings_app.dart';

import 'category_rail.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key, required this.type});
  final MediaType type;
  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  Genre? _selectedGenre;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HomeProvider>().ensureLoaded();
        context.read<GenreProvider>().ensureLoaded(widget.type);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories =
        widget.type == MediaType.movie ? Categories.movies : Categories.tv;

    return SafeArea(
      child: Column(
        children: [
          BrowseHeader(
            title: widget.type == MediaType.movie
                ? AppStrings.movies
                : AppStrings.tvShows,
            type: widget.type,
            selectedGenre: _selectedGenre,
            onGenreSelected: (genre) {
              setState(() => _selectedGenre = genre);
            },
          ),

          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.03),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              child: _selectedGenre == null
                  ? CategoryRailView(
                      key: const ValueKey('rails'),
                      categories: categories,
                      type: widget.type,
                    )
                  : GenreGridView(
                      key: ValueKey('genre-${_selectedGenre!.id}'),
                      genre: _selectedGenre!,
                      type: widget.type,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

