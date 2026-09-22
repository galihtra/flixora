# FLIXORA

FLIXORA adalah aplikasi Flutter untuk menjelajahi film dan serial TV melalui [TMDB](https://www.themoviedb.org/). Pengguna dapat membuka katalog, memfilter genre, mencari judul, melihat detail, dan menyimpan pilihan di **My List**. Aplikasi ini menampilkan informasi tontonan dan tidak memutar video.

## Demo aplikasi

[▶ Tonton rekaman demo FLIXORA (MP4)](docs/demo/flixora-demo.mp4)

Rekaman layar Android ini memperlihatkan alur dari splash dan shimmer, Home, My List kosong, katalog dan **See All**, filter genre film, detail dan penyimpanan judul, filter genre serial beserta daftar musim, pencarian, hasil kosong, hingga gangguan jaringan dan pemulihannya. Rekaman tidak menggunakan audio.

## Screenshot fitur

Seluruh gambar diambil dari aplikasi yang berjalan di emulator Android. Poster, judul, rating, dan urutan katalog berasal dari TMDB sehingga dapat berubah. Kondisi tanpa koneksi diambil dengan mode pesawat; kondisi token kosong diambil dari build demo sementara tanpa token.

### Pembukaan dan Home

| Splash animasi | Shimmer saat memuat | Home dan hero carousel |
|:---:|:---:|:---:|
| <img src="docs/screenshots/splash.webp" alt="Logo F pada animasi splash FLIXORA" width="220"> | <img src="docs/screenshots/home-shimmer.webp" alt="Skeleton shimmer pada hero dan poster Home" width="220"> | <img src="docs/screenshots/home.webp" alt="Home dengan hero, tombol Details dan My List, serta katalog" width="220"> |

### Jelajahi film

| Movies | Semua judul di kategori | Pilihan genre |
|:---:|:---:|:---:|
| <img src="docs/screenshots/movies.webp" alt="Katalog Movies dengan beberapa rail film" width="220"> | <img src="docs/screenshots/category-see-all.webp" alt="Grid Popular Movies setelah memilih See All" width="220"> | <img src="docs/screenshots/movie-genres.webp" alt="Bottom sheet pilihan genre film" width="220"> |

| Hasil filter Action | Detail film | Film tersimpan |
|:---:|:---:|:---:|
| <img src="docs/screenshots/movies-action.webp" alt="Grid film berdasarkan genre Action" width="220"> | <img src="docs/screenshots/movie-detail.webp" alt="Detail film dengan rating, durasi, genre, dan sinopsis" width="220"> | <img src="docs/screenshots/movie-detail-saved.webp" alt="Tombol My List setelah film disimpan" width="220"> |

### Jelajahi serial TV

| TV Shows | Pilihan genre TV | Hasil filter Action & Adventure |
|:---:|:---:|:---:|
| <img src="docs/screenshots/tv-shows.webp" alt="Katalog TV Shows" width="220"> | <img src="docs/screenshots/tv-genres.webp" alt="Bottom sheet pilihan genre serial" width="220"> | <img src="docs/screenshots/tv-action-adventure.webp" alt="Grid serial genre Action dan Adventure" width="220"> |

| Detail serial | Musim dan episode |
|:---:|:---:|
| <img src="docs/screenshots/tv-detail.webp" alt="Detail serial dengan jumlah musim, episode, rating, genre, dan sinopsis" width="220"> | <img src="docs/screenshots/tv-seasons.webp" alt="Daftar musim serial dengan poster, episode, rating, dan ringkasan" width="220"> |

### Pencarian dan My List

| Sebelum mencari | Minimal dua karakter | Hasil pencarian |
|:---:|:---:|:---:|
| <img src="docs/screenshots/search-initial.webp" alt="State awal pencarian" width="220"> | <img src="docs/screenshots/search-minimum.webp" alt="Pesan untuk mengetik sedikitnya dua karakter" width="220"> | <img src="docs/screenshots/search.webp" alt="Hasil pencarian film dan serial" width="220"> |

| Tidak ada hasil | My List kosong | My List terisi |
|:---:|:---:|:---:|
| <img src="docs/screenshots/search-no-results.webp" alt="State pencarian tanpa hasil" width="220"> | <img src="docs/screenshots/my-list-empty.webp" alt="State My List kosong dan tombol Explore Movies" width="220"> | <img src="docs/screenshots/my-list.webp" alt="Judul tersimpan di My List" width="220"> |

### Loading dan penanganan masalah

| Katalog tanpa koneksi | Pencarian tanpa koneksi | Token TMDB belum diisi |
|:---:|:---:|:---:|
| <img src="docs/screenshots/offline-home.webp" alt="Katalog menampilkan You're Offline dan Try Again" width="220"> | <img src="docs/screenshots/offline-search.webp" alt="Pencarian menampilkan error offline dan tombol Try Again" width="220"> | <img src="docs/screenshots/token-missing.webp" alt="Pesan Unable to Load ketika token TMDB kosong" width="220"> |

## Fitur

- **Splash:** animasi logo sebelum masuk ke Home.
- **Home:** hero carousel, aksi untuk membuka detail atau menyimpan judul, dan rail katalog film maupun serial.
- **Movies dan TV Shows:** katalog populer dan rating tertinggi; kategori film juga mencakup Now Playing dan Coming Soon. Tombol **See All** membuka grid dengan pemuatan halaman berikutnya saat digulir.
- **Filter genre:** pilih **Genres** di Movies atau TV Shows untuk menampilkan grid sesuai genre. Pilih **All** untuk kembali ke katalog biasa. Hasil filter mendukung refresh dan pagination.
- **Detail:** poster dan backdrop, tahun, durasi film atau jumlah musim dan episode serial, rating TMDB, genre, sinopsis, serta rincian tiap musim untuk serial.
- **Search:** pencarian film dan serial mulai dari dua karakter, dengan jeda input, hasil bertahap, serta state ketika tidak ada hasil.
- **My List:** simpan dan hapus judul; daftar disimpan di perangkat dengan `shared_preferences` dan dapat dibuka tanpa koneksi.
- **Status aplikasi:** shimmer saat memuat, pesan untuk keadaan kosong, offline, kesalahan layanan atau token, dan aksi **Try Again**.
- **Layout adaptif:** `flutter_screenutil` dan jumlah kolom poster yang mengikuti lebar layar.

## Persyaratan

- [Flutter SDK](https://docs.flutter.dev/get-started/install) dengan Dart **>=3.10.4 dan <4.0.0**. Proyek ini dijalankan dengan Flutter **3.38.5**.
- [Android SDK](https://developer.android.com/studio) serta emulator atau perangkat Android untuk versi Android.
- macOS, Xcode, dan CocoaPods untuk menjalankan versi iOS.
- Koneksi internet dan **TMDB API Read Access Token** dari [pengaturan API TMDB](https://www.themoviedb.org/settings/api) untuk katalog.

Periksa lingkungan pengembangan:

```bash
flutter doctor
flutter devices
```

## Instalasi dan konfigurasi

```bash
git clone https://github.com/galihtra/flixora.git
cd flixora
flutter pub get
cp lib/app/config_app.example.dart lib/app/config_app.dart
```

Isi `AppConfig.tmdbToken` di `lib/app/config_app.dart` dengan **API Read Access Token** milik Anda:

```dart
abstract final class AppConfig {
  static const tmdbToken = 'TMDB_API_READ_ACCESS_TOKEN_ANDA';
}
```

File `lib/app/config_app.dart` diabaikan Git. Repositori hanya menyimpan `lib/app/config_app.example.dart` yang kosong. Token dikompilasi ke dalam aplikasi, jadi jangan commit token pribadi. Jika token belum diisi atau tidak valid, katalog tidak dapat dimuat; My List lokal tetap bisa dibuka.

## Menjalankan aplikasi

Pastikan ID perangkat muncul di `flutter devices`, kemudian:

```bash
flutter run -d DEVICE_ID
```

Contoh untuk emulator Android:

```bash
flutter run -d emulator-5554
```

Untuk iOS, buka iOS Simulator atau hubungkan iPhone yang sudah disiapkan untuk pengembangan, lalu gunakan ID perangkat dari `flutter devices`. iPhone fisik memerlukan pengaturan **Signing & Capabilities** pada `ios/Runner.xcworkspace` dengan Apple Development Team Anda.

## Membuat build

```bash
flutter build apk --release
flutter build ipa --release
```

APK ada di `build/app/outputs/flutter-apk/app-release.apk`; IPA ada di `build/ios/ipa/`. Perintah IPA memerlukan macOS, Xcode, dan signing yang sesuai. Konfigurasi Android saat ini memakai debug signing untuk build lokal; siapkan keystore rilis sendiri sebelum mendistribusikan APK.

## Memeriksa state khusus

- **Shimmer:** buka aplikasi setelah instalasi atau refresh katalog saat permintaan TMDB masih berjalan.
- **Offline:** matikan koneksi internet pada emulator/perangkat, buka katalog atau cari judul baru, lalu gunakan **Try Again** setelah koneksi pulih.
- **Token belum diisi:** biarkan `AppConfig.tmdbToken` kosong dalam build lokal untuk melihat pesan konfigurasi pada katalog.
- **Pencarian kosong:** masukkan kata yang tidak cocok dengan judul apa pun.
- **My List kosong:** buka My List sebelum menyimpan judul. Setelah menyimpan judul, daftar tetap tersedia secara lokal.

## Struktur proyek

```text
lib/
├── main.dart            # entry point
├── app/                 # bootstrap, router, konfigurasi, dan navigasi
├── resources/           # warna, string, tema, aset, dan ukuran
├── data/                # model, provider, repository, dan API client
├── pages/               # layar utama dan widget khusus layar
├── components/          # komponen yang dipakai berulang
└── base_widgets/        # widget dasar bersama

docs/
├── screenshots/         # screenshot asli dari emulator
└── demo/                # rekaman layar aplikasi
```

## Pemeriksaan proyek

```bash
flutter analyze
flutter test
```

Tes di `test/` mencakup penanganan kesalahan API, pencarian, penyimpanan My List, dan layout pada beberapa ukuran layar serta skala teks.

FLIXORA menggunakan TMDB API, tetapi tidak didukung atau disertifikasi oleh TMDB.
