import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flixora/data/model/models.dart';
import 'package:flixora/data/services/api_error_mapper.dart';
import 'package:flixora/data/repositories/media_repository.dart';

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
  int _heroIndex = 0;
  Timer? _heroScrollTimer;

  int get heroIndex => _heroIndex;

  void startHeroAutoScroll() {
    _heroScrollTimer?.cancel();
    _heroScrollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (heroes.length < 2) return;
      _heroIndex = (_heroIndex + 1) % heroes.length;
      notifyListeners();
    });
  }

  void setHeroIndex(int index) {
    _heroIndex = index;
  }

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

  @override
  void dispose() {
    _heroScrollTimer?.cancel();
    super.dispose();
  }
}
