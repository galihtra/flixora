import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flixora/data/model/models.dart';
import 'package:flixora/data/services/api_error_mapper.dart';
import 'package:flixora/data/repositories/media_repository.dart';
import 'package:flixora/resources/values_app.dart';

class SearchProvider extends ChangeNotifier {
  SearchProvider(this._repository, {this.debounce = AppValues.searchDebounce});
  final MediaRepository _repository;
  final Duration debounce;
  Timer? _timer;
  CancelToken? _cancelToken;
  int _version = 0;
  bool _disposed = false;
  String query = '';
  List<MediaItem> items = [];
  bool loading = false;
  bool debouncing = false;
  bool loadingMore = false;
  bool hasMore = false;
  int currentPage = 0;
  AppException? error;
  AppException? loadMoreError;

  void updateQuery(String value) {
    final trimmed = value.trim();
    if (trimmed == query) return;
    query = trimmed;
    _version++;
    _timer?.cancel();
    _cancelToken?.cancel();
    items = [];
    error = null;
    loadMoreError = null;
    loading = false;
    debouncing = trimmed.length >= 2;
    loadingMore = false;
    currentPage = 0;
    hasMore = false;
    notifyListeners();
    if (trimmed.length < 2) return;
    final requestVersion = _version;
    _timer = Timer(debounce, () => _search(requestVersion, 1));
  }

  Future<void> _search(int requestVersion, int page) async {
    if (_disposed || requestVersion != _version) return;
    debouncing = false;
    final activeQuery = query;
    final cancelToken = CancelToken();
    _cancelToken = cancelToken;
    if (page == 1) {
      loading = true;
    } else {
      loadingMore = true;
      loadMoreError = null;
    }
    notifyListeners();
    try {
      final result = await _repository.search(
        activeQuery,
        page,
        cancelToken: cancelToken,
      );
      if (_disposed || requestVersion != _version || activeQuery != query) {
        return;
      }
      final seen = <String>{};
      items = (page == 1 ? result.items : [...items, ...result.items])
          .where((item) => seen.add(item.key))
          .toList();
      currentPage = result.page;
      hasMore = result.page < result.totalPages;
      error = null;
    } catch (caught) {
      if (_disposed ||
          requestVersion != _version ||
          caught is DioException && CancelToken.isCancel(caught)) {
        return;
      }
      if (page == 1) {
        error = ApiErrorMapper.map(caught);
      } else {
        loadMoreError = ApiErrorMapper.map(caught);
      }
    } finally {
      if (!_disposed && requestVersion == _version) {
        loading = false;
        loadingMore = false;
        notifyListeners();
      }
    }
  }

  void retry() {
    if (query.length >= 2 && !loading) _search(_version, 1);
  }

  void loadMore() {
    if (!loading && !loadingMore && hasMore && loadMoreError == null) {
      _search(_version, currentPage + 1);
    }
  }

  void retryLoadMore() {
    if (!loadingMore && loadMoreError != null) {
      _search(_version, currentPage + 1);
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    _cancelToken?.cancel();
    super.dispose();
  }
}
