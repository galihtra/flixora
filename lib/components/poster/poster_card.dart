import 'package:flutter/material.dart';
import 'package:flixora/app/navigation.dart';
import 'package:flixora/data/model/models.dart';
import 'package:flixora/base_widgets/image/artwork.dart';
import 'package:flixora/resources/colors_app.dart';
import 'package:flixora/resources/strings_app.dart';
import 'package:flixora/resources/values_app.dart';

class PosterCard extends StatelessWidget {
  const PosterCard({
    super.key,
    required this.item,
    required this.scope,
    this.width = 120,
  });
  final MediaItem item;
  final String scope;
  final double width;

  @override
  Widget build(BuildContext context) {
    final tag = '$scope-${item.key}';
    return Semantics(
      button: true,
      label: AppStrings.openTitle(item.title),
      child: InkWell(
        onTap: () => openDetail(context, item, tag),
        borderRadius: BorderRadius.circular(5),
        child: SizedBox(
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Artwork(
                  path: item.posterPath,
                  width: width,
                  height: width * AppValues.posterRatio,
                  heroTag: tag,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: AppColors.rating,
                    size: 13,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    item.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.muted,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Flexible(
                    child: Text(
                      item.year,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
