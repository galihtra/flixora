import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flixora/data/model/models.dart';
import 'package:flixora/data/repositories/media_repository.dart';
import 'package:flixora/data/providers/search/search_provider.dart';

class FakeRepository implements MediaRepository {
  final calls = <String>[];
  final pending = <String, Completer<MediaPage>>{};
  @override
  Future<MediaPage> search(String query, int page, {CancelToken? cancelToken}) {
    calls.add(query);
    final completer = Completer<MediaPage>();
    pending[query] = completer;
    return completer.future;
  }

  @override
  Future<MediaPage> category(
    CatalogCategory category,
    int page, {
    CancelToken? cancelToken,
  }) => throw UnimplementedError();
  @override
  Future<MediaDetail> detail(
    MediaType type,
    int id, {
    CancelToken? cancelToken,
  }) => throw UnimplementedError();
  @override
  String? imageUrl(String? path, {bool backdrop = false}) => null;
}

void main() {
  testWidgets('debounces rapid input and discards stale responses', (
    tester,
  ) async {
    final repository = FakeRepository();
    final provider = SearchProvider(repository);
    provider.updateQuery('Bat');
    await tester.pump(const Duration(milliseconds: 150));
    provider.updateQuery('Batman');
    await tester.pump(const Duration(milliseconds: 399));
    expect(repository.calls, isEmpty);
    await tester.pump(const Duration(milliseconds: 1));
    expect(repository.calls, ['Batman']);

    provider.updateQuery('Dune');
    await tester.pump(const Duration(milliseconds: 400));
    expect(repository.calls, ['Batman', 'Dune']);
    repository.pending['Dune']!.complete(
      const MediaPage(
        [MediaItem(id: 2, type: MediaType.movie, title: 'Dune')],
        1,
        1,
      ),
    );
    await tester.pump();
    repository.pending['Batman']!.complete(
      const MediaPage(
        [MediaItem(id: 1, type: MediaType.movie, title: 'Batman')],
        1,
        1,
      ),
    );
    await tester.pump();
    expect(provider.items.single.title, 'Dune');
    provider.dispose();
  });
}
