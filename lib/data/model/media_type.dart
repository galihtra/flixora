import 'package:flixora/resources/strings_app.dart';

enum MediaType { movie, tv }

extension MediaTypePath on MediaType {
  String get label =>
      this == MediaType.movie ? AppStrings.movie : AppStrings.tvShow;
}
