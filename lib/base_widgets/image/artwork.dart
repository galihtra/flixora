import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flixora/data/repositories/media_repository.dart';
import 'package:flixora/resources/colors_app.dart';

class Artwork extends StatelessWidget {
  const Artwork({
    super.key,
    required this.path,
    required this.height,
    required this.width,
    this.backdrop = false,
    this.heroTag,
  });
  final String? path;
  final double height;
  final double width;
  final bool backdrop;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final repository = context.read<MediaRepository>();
    final url = repository.imageUrl(path, backdrop: backdrop);
    Widget child;
    if (url == null) {
      child = _placeholder();
    } else {
      child = CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (_, _) => const ColoredBox(color: AppColors.surface),
        errorWidget: (_, _, _) => _placeholder(),
      );
    }
    child = SizedBox(width: width, height: height, child: child);
    if (heroTag != null) child = Hero(tag: heroTag!, child: child);
    return child;
  }

  Widget _placeholder() => Container(
    color: AppColors.surface,
    alignment: Alignment.center,
    child: const Icon(Icons.movie_outlined, size: 42, color: AppColors.white38),
  );
}
