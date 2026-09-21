import 'package:flixora/data/model/media_item.dart';

class MediaPage {
  const MediaPage(this.items, this.page, this.totalPages);
  final List<MediaItem> items;
  final int page;
  final int totalPages;
}
