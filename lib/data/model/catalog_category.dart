import 'package:flixora/data/model/media_type.dart';
import 'package:flixora/resources/strings_app.dart';

class CatalogCategory {
  const CatalogCategory(this.title, this.path, this.type);
  final String title;
  final String path;
  final MediaType type;
}

abstract final class Categories {
  static const popularMovies = CatalogCategory(
    AppStrings.popularMovies,
    '/movie/popular',
    MediaType.movie,
  );
  static const topMovies = CatalogCategory(
    AppStrings.topRatedMovies,
    '/movie/top_rated',
    MediaType.movie,
  );
  static const nowPlaying = CatalogCategory(
    AppStrings.nowPlaying,
    '/movie/now_playing',
    MediaType.movie,
  );
  static const upcoming = CatalogCategory(
    AppStrings.comingSoon,
    '/movie/upcoming',
    MediaType.movie,
  );
  static const popularTv = CatalogCategory(
    AppStrings.popularTvShows,
    '/tv/popular',
    MediaType.tv,
  );
  static const topTv = CatalogCategory(
    AppStrings.topRatedTvShows,
    '/tv/top_rated',
    MediaType.tv,
  );
  static const home = [
    popularMovies,
    topMovies,
    nowPlaying,
    upcoming,
    popularTv,
    topTv,
  ];
  static const movies = [popularMovies, topMovies, nowPlaying, upcoming];
  static const tv = [popularTv, topTv];
}
