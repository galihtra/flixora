import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flixora/data/model/models.dart';
import 'package:flixora/data/repositories/media_repository.dart';
import 'package:flixora/resources/values_app.dart';

abstract class WatchlistStore {
  Future<String?> read();
  Future<void> write(String json);
}

class PreferencesWatchlistStore implements WatchlistStore {
  static const key = AppValues.watchlistKey;
  @override
  Future<String?> read() async =>
      (await SharedPreferences.getInstance()).getString(key);
  @override
  Future<void> write(String json) async {
    await (await SharedPreferences.getInstance()).setString(key, json);
  }
}

class WatchlistProvider extends ChangeNotifier {
  WatchlistProvider(this._store, {MediaRepository? repository})
    : _repository = repository;

  final WatchlistStore _store;
  final MediaRepository? _repository;
  final Map<String, MediaItem> _items = {};
  Future<void> _pendingWrite = Future<void>.value();
  bool _disposed = false;
  bool ready = false;

  List<MediaItem> get items => _items.values.toList().reversed.toList();
  bool contains(MediaItem item) => _items.containsKey(item.key);

  Future<void> load() async {
    try {
      final raw = await _store.read();
      if (raw != null) {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          for (final entry in decoded.whereType<Map>()) {
            final item = MediaItem.fromStorage(
              Map<String, dynamic>.from(entry),
            );
            if (item.id > 0) _items[item.key] = item;
          }
        }
      }
    } catch (_) {
      _items.clear();
    }
    if (_disposed) return;
    ready = true;
    notifyListeners();

    // Older My List records did not store releaseDate. Fill only those records;
    // the list remains visible while details are loaded in the background.
    for (final item
        in _items.values.where((item) => item.year == '—').toList()) {
      if (_disposed) return;
      await _fillMissingDate(item);
    }
  }

  Future<void> toggle(MediaItem item) async {
    final added = !_items.containsKey(item.key);
    if (added) {
      _items[item.key] = item;
    } else {
      _items.remove(item.key);
    }
    notifyListeners();
    await _save();
    if (added && item.year == '—') await _fillMissingDate(item);
  }

  Future<void> _fillMissingDate(MediaItem item) async {
    final repository = _repository;
    if (repository == null || _items[item.key]?.year != '—') return;
    try {
      final detail = await repository.detail(item.type, item.id);
      final date = detail.item.releaseDate;
      if (_disposed || date == null || date.length < 4) return;
      final current = _items[item.key];
      if (current == null || current.year != '—') return;
      _items[item.key] = current.withReleaseDate(date);
      notifyListeners();
      await _save();
    } catch (_) {
      // Keep the saved item available offline and retry on the next app start.
    }
  }

  Future<void> _save() {
    final snapshot = jsonEncode(
      _items.values.map((item) => item.toStorage()).toList(),
    );
    final write = _pendingWrite.then((_) => _store.write(snapshot));
    _pendingWrite = write.catchError((Object _) {});
    return write;
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
