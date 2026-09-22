import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flixora/app/flixora_app.dart';
import 'package:go_router/go_router.dart';
import 'package:flixora/app/app_routes.dart';
import 'package:flixora/pages/home/home_page.dart';
import 'package:flixora/data/model/models.dart';
import 'package:flixora/data/repositories/media_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LayoutRepository implements MediaRepository {
  static final movie = MediaItem(
    id: 1,
    type: MediaType.movie,
    title: 'A Very Long Movie Title That Needs To Fit On Every Screen',
    backdropPath: '/hero',
    overview: 'A detailed story with a long description. ' * 12,
    rating: 8.7,
    voteCount: 1234567,
    releaseDate: '2026-01-01',
  );

  @override
  Future<MediaPage> category(
    CatalogCategory category,
    int page, {
    CancelToken? cancelToken,
  }) async => MediaPage(
    [
      movie,
      MediaItem(
        id: 2,
        type: category.type,
        title: 'Another Long Title For A Poster',
        rating: 7.1,
      ),
    ],
    1,
    1,
  );

  @override
  Future<MediaDetail> detail(
    MediaType type,
    int id, {
    CancelToken? cancelToken,
  }) async => MediaDetail(
    item: movie,
    genres: ['Science Fiction', 'Adventure', 'Drama'],
    adult: false,
    productionCompanies: const [],
    seasonList: const [],
    runtime: 138,
  );

  @override
  Future<MediaPage> search(
    String query,
    int page, {
    CancelToken? cancelToken,
  }) async => MediaPage([movie], 1, 1);

  @override
  String? imageUrl(String? path, {bool backdrop = false}) => null;
}

void main() {
  for (final (size, textScale) in <(Size, double)>[
    (const Size(280, 480), 1),
    (const Size(320, 568), 1),
    (const Size(390, 844), 1),
    (const Size(800, 1280), 1),
    (const Size(844, 390), 1),
    (const Size(320, 568), 2),
    (const Size(844, 390), 1.8),
  ]) {
    testWidgets(
      'screens fit ${size.width}x${size.height} at ${textScale}x text',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = size;
        tester.binding.platformDispatcher.textScaleFactorTestValue = textScale;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
          tester.binding.platformDispatcher.clearTextScaleFactorTestValue();
        });
        SharedPreferences.setMockInitialValues({});
        await tester.pumpWidget(FlixoraApp(repository: LayoutRepository()));
        await tester.pump(const Duration(milliseconds: 1300));
        await tester.pump();
        expect(tester.takeException(), isNull);

        final router = GoRouter.of(tester.element(find.byType(HomeScreen)));
        for (final path in [
          AppRoutes.movies,
          AppRoutes.tv,
          AppRoutes.myList,
          AppRoutes.category(Categories.popularMovies),
          '/detail/movie/1',
          AppRoutes.search,
        ]) {
          router.go(path);
          await tester.pump(const Duration(milliseconds: 500));
          await tester.pump();
          expect(
            tester.takeException(),
            isNull,
            reason: 'Overflow on $path at $size',
          );
        }
        await tester.enterText(find.byType(TextField), 'movie');
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump();
        expect(tester.takeException(), isNull);
      },
    );
  }
}
