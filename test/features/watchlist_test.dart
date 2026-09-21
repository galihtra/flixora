import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flixora/data/repositories/media_repository.dart';
import 'package:flixora/data/model/models.dart';
import 'package:flixora/data/providers/watchlist/watchlist_provider.dart';

class MemoryStore implements WatchlistStore {
  String? value;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String json) async => value = json;
}

class DetailRepository implements MediaRepository {
  final calls = <String>[];

  @override
  Future<MediaDetail> detail(
    MediaType type,
    int id, {
    CancelToken? cancelToken,
  }) async {
    calls.add('${type.name}:$id');
    return MediaDetail(
      item: MediaItem(
        id: id,
        type: type,
        title: 'Updated title',
        releaseDate: id == 1 ? '2025-12-01' : '2026-07-31',
      ),
      genres: const [],
    );
  }

  @override
  Future<MediaPage> category(
    CatalogCategory category,
    int page, {
    CancelToken? cancelToken,
  }) => throw UnimplementedError();

  @override
  Future<MediaPage> search(
    String query,
    int page, {
    CancelToken? cancelToken,
  }) => throw UnimplementedError();

  @override
  String? imageUrl(String? path, {bool backdrop = false}) => null;
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

  test('restores saved dates and backfills older My List entries', () async {
    final store = MemoryStore();
    store.value = jsonEncode([
      {
        'id': 1,
        'type': 'movie',
        'title': 'Mutiny',
        'posterPath': '/poster-one',
        'rating': 6.4,
      },
      {
        'id': 2,
        'type': 'movie',
        'title': 'Spider-Man',
        'posterPath': '/poster-two',
        'rating': 7.9,
      },
    ]);
    final repository = DetailRepository();
    final watchlist = WatchlistProvider(store, repository: repository);
    await watchlist.load();

    expect(repository.calls, ['movie:1', 'movie:2']);
    expect(watchlist.items.map((item) => item.year), ['2026', '2025']);
    expect(watchlist.items.map((item) => item.title), ['Spider-Man', 'Mutiny']);

    final restored = WatchlistProvider(store);
    await restored.load();
    expect(restored.items.map((item) => item.year), ['2026', '2025']);
    watchlist.dispose();
    restored.dispose();
  });

  test('newly saved item keeps its release date after reload', () async {
    final store = MemoryStore();
    final watchlist = WatchlistProvider(store);
    await watchlist.load();
    await watchlist.toggle(
      const MediaItem(
        id: 3,
        type: MediaType.tv,
        title: 'A Show',
        releaseDate: '2024-03-05',
      ),
    );

    final restored = WatchlistProvider(store);
    await restored.load();
    expect(restored.items.single.year, '2024');
    watchlist.dispose();
    restored.dispose();
  });
}
