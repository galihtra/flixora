# FLIXORA

An Android movie and TV discovery app built with Flutter. FLIXORA uses the TMDB API for its catalog and keeps My List on the device. It does not stream video.

## Features

- Cinematic Home with a swipeable hero and six independent TMDB categories
- Movies, TV Shows, and paginated See All grids
- Movie and TV detail with poster, backdrop, rating, genres, synopsis, and runtime or episode information
- Search across movies and TV with 400 ms debounce, cancellation, stale-response protection, and pagination
- Offline My List stored with `shared_preferences`
- Shimmer loading, pull-to-refresh, image cache, bounded retries, and contextual error states
- Native Android splash screen and FLIXORA icon
- Responsive layouts with `flutter_screenutil`, adaptive poster grids, and overflow checks for phone, tablet, landscape, and larger text

## Requirements

- Flutter SDK with Dart 3.10 or newer
- Android SDK for Android builds
- A TMDB API Read Access Token from [TMDB API settings](https://www.themoviedb.org/settings/api)

## Configure TMDB

For a new checkout, copy `lib/resources/config_app.example.dart` to `lib/resources/config_app.dart` and set `AppConfig.tmdbToken` to your TMDB API Read Access Token. The local config file is ignored by Git. Keep the token private.

```sh
cp -n lib/resources/config_app.example.dart lib/resources/config_app.dart
flutter pub get
flutter run
```

For an Android APK, run `flutter build apk --release`. The APK will be at `build/app/outputs/flutter-apk/app-release.apk`. The project uses a debug signing key for local release builds; configure your own signing key before distributing an APK. The token is compiled into the app, so protect any APK you distribute and use appropriate TMDB token restrictions.

If the token is empty, the app opens and shows a service configuration message. My List remains accessible offline.

## Architecture

The folder layout follows the reference pattern used by `turun`:

```text
lib/
  main.dart                 # entry point only
  app/                      # bootstrap, router, provider setup, navigation
  resources/                # colors, strings, theme, configuration values
  data/
    model/                  # TMDB and local data models
    providers/              # feature state (Provider / ChangeNotifier)
    repositories/           # catalog and detail access
    services/               # Dio client and API error mapping
  pages/                    # screens and screen-specific widgets
  components/               # reusable cards, headers, loading, state views
  base_widgets/             # shared primitive UI widgets
```

API requests use a 10 s connection timeout, 20 s receive timeout, and 10 s send timeout. Transient GET failures receive up to two retries; rate limits honor Retry-After. Each category fails independently. Catalog data already loaded remains visible on refresh and pagination failure. The app has no permanent offline catalog; poster availability offline depends on the image cache.

## Verify

```sh
flutter analyze
flutter test
flutter build apk --debug
```

The tests cover API error mapping, debounced search with stale response protection, My List persistence, and viewport overflow checks across seven screen and text-scale combinations.

This product uses the TMDB API but is not endorsed or certified by TMDB.
