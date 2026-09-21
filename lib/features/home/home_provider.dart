import 'package:flutter/foundation.dart';
import '../../core/models.dart';
import '../../data/api.dart';

class CategoryState {
  List<MediaItem> items = [];
  bool loading = false;
  AppException? error;
}

class HomeProvider extends ChangeNotifier {
  HomeProvider(this._repository);
  final MediaRepository _repository;
  final Map<String, CategoryState> _sections = {
    for (final category in Categories.home) category.path: CategoryState(),
  };
  bool _started = false;

  CategoryState state(CatalogCategory category) => _sections[category.path]!;
  List<MediaItem> get heroes {
    final popular = state(Categories.popularMovies).items;
    return popular.where((item) => item.backdropPath != null).take(5).toList();
  }

  void ensureLoaded() {
    if (_started) return;
    _started = true;
    for (final category in Categories.home) {
      loadCategory(category);
    }
  }

  Future<void> refresh() async {
    await Future.wait(
      Categories.home.map((category) => loadCategory(category)),
    );
  }

  Future<void> loadCategory(CatalogCategory category) async {
    final section = state(category);
    if (section.loading) return;
    section.loading = true;
    section.error = null;
    notifyListeners();
    try {
      final page = await _repository.category(category, 1);
      section.items = page.items;
    } catch (error) {
      section.error = ApiErrorMapper.map(error);
    } finally {
      section.loading = false;
      notifyListeners();
    }
  }
}
