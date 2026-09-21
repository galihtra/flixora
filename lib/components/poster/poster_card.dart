import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flixora/resources/layout_app.dart';
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
    this.width,
  });
  final MediaItem item;
  final String scope;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final tag = '$scope-${item.key}';
    final cardWidth = width ?? AppLayout.railPosterWidth;
    return Semantics(
      button: true,
      label: AppStrings.openTitle(item.title),
      child: InkWell(
        onTap: () => openDetail(context, item, tag),
        borderRadius: BorderRadius.circular(5.r),
        child: SizedBox(
          width: cardWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5.r),
                child: Artwork(
                  path: item.posterPath,
                  width: cardWidth,
                  height: cardWidth * AppValues.posterRatio,
                  heroTag: tag,
                ),
              ),
              SizedBox(height: 7.h),
              Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: AppLayout.posterTitleSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Icon(Icons.star_rounded, color: AppColors.rating, size: 13.r),
                  SizedBox(width: 2.w),
                  Flexible(
                    child: Text(
                      item.rating.toStringAsFixed(1),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: AppLayout.posterMetaSize,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                  SizedBox(width: 7.w),
                  Flexible(
                    child: Text(
                      item.year,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: AppLayout.posterMetaSize,
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
