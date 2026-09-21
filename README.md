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

## Requirements

- Flutter SDK with Dart 3.10 or newer
- Android SDK for Android builds
- A TMDB API Read Access Token from [TMDB API settings](https://www.themoviedb.org/settings/api)

## Configure the token

Copy `config/tmdb.example.json` to `config/tmdb.local.json`, then replace the placeholder with your TMDB API Read Access Token. The local file is ignored by Git. Do not commit or share the token.

```sh
cp config/tmdb.example.json config/tmdb.local.json
flutter pub get
flutter run --dart-define-from-file=config/tmdb.local.json
```

The same configuration is required for a functional Android APK:

```sh
flutter build apk --release --dart-define-from-file=config/tmdb.local.json
```

The APK will be at `build/app/outputs/flutter-apk/app-release.apk`. The project uses a debug signing key for local release builds; configure your own signing key before distributing an APK.

If no token is provided, the app still opens and shows a service configuration message. My List remains accessible offline.

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
flutter build apk --debug --dart-define-from-file=config/tmdb.local.json
```

The tests cover API error mapping, debounced search with stale response protection, and My List persistence.

This product uses the TMDB API but is not endorsed or certified by TMDB.
