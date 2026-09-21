import 'package:flutter_test/flutter_test.dart';
import 'package:flixora/data/model/models.dart';
import 'package:flixora/data/providers/watchlist/watchlist_provider.dart';

class MemoryStore implements WatchlistStore {
  String? value;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String json) async => value = json;
}

void main() {
  test(
    'uses media type and ID, avoids duplicates, and survives reload',
    () async {
      final store = MemoryStore();
      final watchlist = WatchlistProvider(store);
      await watchlist.load();
      const movie = MediaItem(id: 42, type: MediaType.movie, title: 'A Movie');
      const tv = MediaItem(id: 42, type: MediaType.tv, title: 'A Show');
      await watchlist.toggle(movie);
      await watchlist.toggle(tv);
      expect(watchlist.items.length, 2);

      final restored = WatchlistProvider(store);
      await restored.load();
      expect(restored.contains(movie), true);
      expect(restored.contains(tv), true);
      await restored.toggle(movie);
      expect(restored.items.single.key, tv.key);
      watchlist.dispose();
      restored.dispose();
    },
  );
}
