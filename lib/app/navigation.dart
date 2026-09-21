import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flixora/data/model/models.dart';
import 'package:flixora/app/app_routes.dart';

class DetailArgs {
  const DetailArgs(this.item, this.heroTag);
  final MediaItem item;
  final String heroTag;
}

void openDetail(BuildContext context, MediaItem item, String heroTag) {
  context.push(AppRoutes.detail(item), extra: DetailArgs(item, heroTag));
}
