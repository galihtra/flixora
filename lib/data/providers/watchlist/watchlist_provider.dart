import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flixora/data/model/models.dart';
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
  WatchlistProvider(this._store);
  final WatchlistStore _store;
  final Map<String, MediaItem> _items = {};
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
    ready = true;
    notifyListeners();
  }

  Future<void> toggle(MediaItem item) async {
    if (_items.containsKey(item.key)) {
      _items.remove(item.key);
    } else {
      _items[item.key] = item;
    }
    notifyListeners();
    await _store.write(
      jsonEncode(_items.values.map((item) => item.toStorage()).toList()),
    );
  }
}
