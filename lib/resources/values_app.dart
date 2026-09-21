abstract final class AppValues {
  static const apiBaseUrl = 'https://api.themoviedb.org/3';
  static const imageBaseUrl = 'https://image.tmdb.org/t/p/';
  static const watchlistKey = 'flixora.watchlist.v1';
  static const searchDebounce = Duration(milliseconds: 400);
  static const splashDuration = Duration(milliseconds: 1200);
  static const connectTimeout = Duration(seconds: 10);
  static const receiveTimeout = Duration(seconds: 20);
  static const sendTimeout = Duration(seconds: 10);
  static const posterRatio = 1.5;
}
