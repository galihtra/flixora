import 'package:flixora/data/model/models.dart';

abstract final class AppRoutes {
  static const splash = '/splash';
  static const home = '/home';
  static const movies = '/movies';
  static const tv = '/tv';
  static const myList = '/my-list';
  static const search = '/search';
  static const categoryPattern = '/category/:name';
  static const detailPattern = '/detail/:type/:id';

  static String category(CatalogCategory value) =>
      '/category/${value.path.substring(1).replaceAll('/', '-')}';

  static String detail(MediaItem value) =>
      '/detail/${value.type.name}/${value.id}';
}
