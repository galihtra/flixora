import 'package:flutter/foundation.dart';
import '../../core/models.dart';
import '../../data/api.dart';

enum LoadStatus { initial, loading, success, empty, error }

class CatalogProvider extends ChangeNotifier {
  CatalogProvider(this._repository, this.category);
  final MediaRepository _repository;
  final CatalogCategory category;
  List<MediaItem> items = [];
  LoadStatus status = LoadStatus.initial;
  bool isLoadingMore = false;
  bool isRefreshing = false;
  bool hasMore = true;
  int currentPage = 0;
  AppException? error;
  AppException? loadMoreError;

  Future<void> load() async {
    if (status != LoadStatus.initial) return;
    status = LoadStatus.loading;
    notifyListeners();
    await _firstPage();
  }

  Future<void> retry() async {
    if (status != LoadStatus.error) return;
    status = LoadStatus.loading;
    notifyListeners();
    await _firstPage();
  }

  Future<void> refresh() async {
    if (isRefreshing) return;
    isRefreshing = true;
    notifyListeners();
    await _firstPage();
    isRefreshing = false;
    notifyListeners();
  }

  Future<void> _firstPage() async {
    try {
      final result = await _repository.category(category, 1);
      items = _dedupe(result.items);
      currentPage = result.page;
      hasMore = result.page < result.totalPages;
      status = items.isEmpty ? LoadStatus.empty : LoadStatus.success;
      error = null;
      loadMoreError = null;
    } catch (caught) {
      error = ApiErrorMapper.map(caught);
      status = items.isEmpty ? LoadStatus.error : LoadStatus.success;
    }
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (isLoadingMore ||
        isRefreshing ||
        !hasMore ||
        status != LoadStatus.success ||
        loadMoreError != null) {
      return;
    }
    isLoadingMore = true;
    loadMoreError = null;
    notifyListeners();
    try {
      final result = await _repository.category(category, currentPage + 1);
      items = _dedupe([...items, ...result.items]);
      currentPage = result.page;
      hasMore = result.page < result.totalPages;
    } catch (caught) {
      loadMoreError = ApiErrorMapper.map(caught);
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> retryLoadMore() async {
    loadMoreError = null;
    await loadMore();
  }

  List<MediaItem> _dedupe(List<MediaItem> source) {
    final seen = <String>{};
    return source.where((item) => seen.add(item.key)).toList();
  }
}
