import 'package:dio/dio.dart';
import 'package:flixora/data/model/models.dart';

abstract class MediaRepository {
  Future<MediaPage> category(
    CatalogCategory category,
    int page, {
    CancelToken? cancelToken,
  });
  Future<MediaDetail> detail(
    MediaType type,
    int id, {
    CancelToken? cancelToken,
  });
  Future<MediaPage> search(String query, int page, {CancelToken? cancelToken});
  Future<MediaPage> byGenre(
    MediaType type,
    int genreId,
    int page, {
    CancelToken? cancelToken,
  });
  Future<List<Genre>> genres(MediaType type, {CancelToken? cancelToken});
  String? imageUrl(String? path, {bool backdrop = false});
}
