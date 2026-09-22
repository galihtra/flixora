import 'package:flutter/foundation.dart';
import 'package:flixora/data/model/models.dart';
import 'package:flixora/data/repositories/media_repository.dart';
import 'package:flixora/data/services/api_error_mapper.dart';

enum GenreLoadStatus { initial, loading, success, error }

class GenreProvider extends ChangeNotifier {
  GenreProvider(this._repository);
  final MediaRepository _repository;

  final Map<MediaType, List<Genre>> _cache = {};
  final Map<MediaType, GenreLoadStatus> _status = {};
  final Map<MediaType, AppException?> _errors = {};

  List<Genre> genresFor(MediaType type) => _cache[type] ?? [];
  GenreLoadStatus statusFor(MediaType type) =>
      _status[type] ?? GenreLoadStatus.initial;
  AppException? errorFor(MediaType type) => _errors[type];

  Future<void> ensureLoaded(MediaType type) async {
    final s = statusFor(type);
    if (s == GenreLoadStatus.loading || s == GenreLoadStatus.success) return;
    await _load(type);
  }

  Future<void> reload(MediaType type) => _load(type);

  Future<void> _load(MediaType type) async {
    _status[type] = GenreLoadStatus.loading;
    _errors[type] = null;
    notifyListeners();
    try {
      final list = await _repository.genres(type);
      _cache[type] = list;
      _status[type] = GenreLoadStatus.success;
    } catch (e) {
      _errors[type] = ApiErrorMapper.map(e);
      _status[type] = GenreLoadStatus.error;
    }
    notifyListeners();
  }
}
