# Nusantara Cerdas

Aplikasi mobile **Smart City** berbasis Flutter untuk membantu warga Kota Nusantara mengakses layanan publik (perizinan, kesehatan, transportasi) dalam satu aplikasi.

Nama package di `pubspec.yaml`: `nusantara_nav_707012400103`.

## Tentang Project

`Nusantara Cerdas` adalah aplikasi prototype layanan publik digital. Tujuannya adalah menunjukkan bagaimana warga bisa melihat daftar layanan kota, membuka detail suatu layanan, lalu mengajukan permohonan langsung dari aplikasi, tanpa harus datang ke kantor dinas.

Masalah yang dicoba diselesaikan:

- Warga sering tidak tahu layanan apa saja yang tersedia di kotanya.
- Informasi jam pelayanan dan instansi penanggung jawab mudah tercecer.
- Belum ada satu tempat untuk catatan pengajuan dan layanan favorit.

Cara kerjanya: seluruh data layanan (nama layanan, dinas, jam, keterangan) masih ditulis secara hardcode di dalam widget halaman, sedangkan interaksi pengguna disimpan di memori aplikasi lewat `ChangeNotifier` dan package `provider`, lalu hilang saat aplikasi ditutup. Jadi project ini **belum terhubung ke database maupun API server sungguhan**. Ini penting diketahui sebelum mengembangkan lebih jauh.

Enam pilar Smart City (Smart Governance, Smart Branding, Smart Economy, Smart Living, Smart Society, Smart Environment) ditampilkan di halaman Beranda sebagai konteks kota pintar.

## Fitur

Fitur yang benar-benar ada di kode saat ini:

- **Beranda**: header "Selamat Datang di Nusantara Cerdas", kartu "Kota Cerdas untuk Semua", dan grid enam pilar Smart City (2 kolom di layar sempit, 3 kolom jika lebar minimal 700 px).
- **Halaman Layanan**: 3 tab kategori.
  - Perizinan: Izin Usaha, Izin Bangunan, Izin Keramaian
  - Kesehatan: Pendaftaran Puskesmas, Layanan Ambulans, Jadwal Vaksinasi
  - Transportasi: Kartu Transportasi, Pengaduan Transportasi, Informasi Rute
- **Detail Layanan**: menampilkan instansi penanggung jawab, jam pelayanan, deskripsi, dan tombol "Ajukan Permohonan".
- **Pengajuan Layanan (simulasi)**: tombol ajukan menampilkan spinner selama 1 detik, menambah nama layanan ke `PengajuanModel`, lalu kembali ke halaman sebelumnya dengan konfirmasi `SnackBar`.
- **Badge jumlah pengajuan**: ikon "Warga" di navigasi menampilkan badge berisi total pengajuan.
- **Layanan Favorit**: setiap item layanan bisa dibintangi di halaman Layanan, lalu tampil di halaman Warga.
- **Halaman Warga**: kartu profil statis, shortcut Riwayat Laporan, daftar layanan favorit, dan dua menu yang belum punya fungsi nyata (Pengaduan Warga, Informasi Warga).
- **Riwayat Laporan**: tiga kartu laporan statis dengan status (Diproses, Selesai, Menunggu), Floating Action Button, dan BottomAppBar berisi tombol filter.
- **Pengaturan Kota**: dropdown pilihan kota, switch Notifikasi dan Layanan Lokasi, tombol simpan.
- **Tentang Aplikasi**: informasi aplikasi, daftar fitur, dan nomor versi.
- **Halaman route tidak ditemukan**: `RouteTidakDikenalPage` untuk route yang tidak terdaftar.
- **Layout responsif**: `NavigationBar` di bawah pada layar kecil, `NavigationRail` di samping pada layar lebar minimal 600 px, `NavigationDrawer` sebagai menu sampingan.

## Teknologi yang Digunakan

| Kategori | Teknologi |
|---|---|
| Bahasa | Dart (SDK `^3.10.1`) |
| Framework | Flutter, Material 3 (`useMaterial3: true`) |
| State management | `provider` `^6.1.5+1` (`MultiProvider`, `ChangeNotifierProvider`, `context.watch`, `context.read`, `context.select`) |
| Dependency lain | `cupertino_icons` `^1.0.8` |
| Dev tools | `flutter_test`, `flutter_lints` `^6.0.0` |
| Navigasi | Named routes (`MaterialApp.routes`, `onGenerateRoute`, `onUnknownRoute`) |
| Target platform | Android, iOS, Web, Windows, macOS, Linux (semua folder platform tersedia dari `flutter create`) |
| Database / API / backend | Tidak ada |
| Environment variable / `.env` | Tidak ada |

Batas versi Flutter yang tercatat di `pubspec.lock`: `>=3.18.0-18.0.pre.54`.

## Struktur Project

```
lib/
  main.dart                            # Entry point: MultiProvider + MaterialApp
  models/
    favorit_model.dart                 # ChangeNotifier untuk layanan favorit
    pengajuan_model.dart               # ChangeNotifier untuk daftar pengajuan
  navigation/
    app_routes.dart                    # Nama route, tabel route, route dengan arguments
    kerangka_navigasi.dart             # Scaffold induk: drawer, rail/bar bawah, ganti halaman
  pages/
    beranda_page.dart                  # Halaman Beranda (enam pilar Smart City)
    layanan_page.dart                  # Halaman Layanan (tab perizinan, kesehatan, transportasi)
    detail_layanan_page.dart           # Halaman Detail Layanan dan tombol ajukan
    warga_page.dart                    # Halaman Warga (profil, aktivitas, favorit)
    riwayat_laporan_page.dart          # Halaman Riwayat Laporan
    pengaturan_kota_page.dart          # Halaman Pengaturan Kota
    tentang_aplikasi_page.dart         # Halaman Tentang Aplikasi
    route_tidak_dikenal_page.dart      # Fallback untuk route tidak ditemukan

test/
  widget_test.dart                     # Test bawaan flutter create (masih template)

android/ ios/ web/ windows/ macos/ linux/   # Folder platform bawaan flutter create
pubspec.yaml                           # Konfigurasi package dan dependency
pubspec.lock                           # Kunci versi dependency
analysis_options.yaml                  # Aturan lint (memakai flutter_lints)
.metadata                              # Metadata project dan daftar platform
```

Penjelasan singkat tiap bagian:

- **`main.dart`**: membungkus `NusantaraCerdasApp` dengan `MultiProvider` yang mendaftarkan `FavoritModel` dan `PengajuanModel`, lalu mengonfigurasi `MaterialApp` (initial route `/`, tabel route, route dengan arguments, dan route unknown).
- **`models/`**: tempat state aplikasi. Keduanya `extends ChangeNotifier`, jadi setiap perubahan data otomatis memicu rebuild widget yang memanggil `watch`, `read`, atau `select` di tree widget.
- **`navigation/app_routes.dart`**: semua route dikumpulkan sebagai konstanta statis, yaitu `/`, `/layanan`, `/detail-layanan`, `/warga`, `/riwayat-laporan`, `/pengaturan-kota`, dan `/tentang-aplikasi`. Route yang butuh data memakai `onGenerateRoute` dengan `settings.arguments`.
- **`navigation/kerangka_navigasi.dart`**: `Scaffold` utama yang membatasi navigasi ke tiga halaman utama (Beranda, Layanan, Warga) lewat sebuah indeks, lalu membuka halaman tambahan dengan `Navigator.pushNamed` dari drawer. Di sini juga berisi logika breakpoint 600 px dan badge jumlah pengajuan.
- **`pages/`**: seluruh UI. Hampir semuanya `StatelessWidget`, kecuali `DetailLayananPage` dan `PengaturanKotaPage` yang membutuhkan state lokal.

## Cara Menjalankan Project

Prasyarat:

- Flutter SDK sudah terinstal, dengan Dart minimal `3.10.1`.
- Android Studio dan Android SDK, atau Xcode, atau Chrome, tergantung platform target.

Langkah:

```bash
# 1. Ambil dependency
flutter pub get

# 2. Cek device yang tersedia
flutter devices

# 3a. Jalankan di Android (butuh emulator atau device yang tersambung)
flutter run

# 3b. Jalankan di Chrome
flutter run -d chrome

# 3c. Jalankan di iOS (hanya di macOS)
flutter run -d ios

# 3d. Jalankan di desktop
flutter run -d windows   # atau -d linux / -d macos
```

Command lain yang memang diperlukan:

```bash
# Build APK release
flutter build apk --release

# Build versi web
flutter build web

# Analisis statis dan lint
flutter analyze

# Jalankan test
flutter test
```

Tidak ada berkas `.env` maupun langkah konfigurasi environment variable pada project ini.

## Cara Kerja Project

Alur aplikasi dari awal sampai sebuah interaksi selesai diproses:

1. **`main()`** membuat `MultiProvider` berisi dua `ChangeNotifier` (`FavoritModel` dan `PengajuanModel`), lalu menjalankan `NusantaraCerdasApp`.
2. **`NusantaraCerdasApp`** membangun `MaterialApp` dengan `initialRoute: AppRoutes.beranda` yang bernilai `/`, tabel route dari `AppRoutes.daftarRoute()`, `onGenerateRoute: AppRoutes.bentukRoute`, dan `onUnknownRoute: AppRoutes.routeTidakDikenal`.
3. **Route `/` membuka `KerangkaNavigasi`**. Widget ini menyimpan `_index` untuk menentukan halaman aktif dari daftar `_halaman`, yaitu `[BerandaPage, LayananPage, WargaPage]`.
   - Layar di bawah 600 px: `NavigationBar` tampil di bawah.
   - Layar 600 px ke atas: `NavigationRail` tampil di samping dan `NavigationBar` disembunyikan.
   - `NavigationDrawer` dari ikon menu di AppBar menyediakan menu tambahan: Pengaturan Kota, Tentang Aplikasi, dan Keluar.
4. **Pengguna membuka `LayananPage`**, memilih salah satu dari tiga tab kategori, lalu menekan salah satu kartu layanan.
5. **Navigasi dengan arguments.** `LayananPage` memanggil `Navigator.pushNamed(context, AppRoutes.detailLayanan, arguments: item)`, dengan `item` berupa `Map<String, String>` berisi kunci `nama`, `dinas`, `jam`, dan `keterangan`.
6. **`onGenerateRoute` (`AppRoutes.bentukRoute`)** menangkap arguments itu, memcast-nya menjadi `Map<String, String>`, lalu meneruskannya ke `DetailLayananPage(layanan: ...)`.
7. **Pengguna menekan "Ajukan Permohonan"** di `DetailLayananPage`:
   - state lokal `_sedangMengajukan` bernilai `true`, sehingga tombol menampilkan `CircularProgressIndicator` dan teks "Mengajukan...";
   - `await Future.delayed(const Duration(seconds: 1))` mensimulasikan proses pengajuan;
   - `context.read<PengajuanModel>().tambahPengajuan(namaLayanan)` menambah data dan memicu `notifyListeners()`;
   - `Navigator.pop(context, 'Permohonan $namaLayanan telah diajukan')` mengembalikan nilai ke `LayananPage`, yang menampilkannya lewat `SnackBar` selama 3 detik.
8. **Badge ikut terupdate** karena `KerangkaNavigasi` memakai `context.select<PengajuanModel, int>((model) => model.totalPengajuan)`, sehingga hanya angka total yang memicu rebuild, bukan seluruh object model.
9. **Favorit** bekerja dengan pola serupa: tombol bintang di `LayananPage` memanggil `tandai` atau `batalTandai` pada `FavoritModel`, lalu `WargaPage` menampilkannya lewat `Consumer<FavoritModel>`.
10. **Route yang tidak dikenal** ditangani oleh `onUnknownRoute` dan menampilkan `RouteTidakDikenalPage`, yang punya tombol kembali ke route `/`.

Semua data bersifat lokal dan sementara. Tidak ada request network, tidak ada database, tidak ada autentikasi, dan tidak ada persistensi. Menutup atau me-restart aplikasi akan mengembalikan data ke kondisi awal.

## Penggunaan

Contoh pemakaian setelah aplikasi berjalan:

1. Jalankan `flutter run`, lalu buka aplikasi di device atau emulator.
2. Di Beranda, terlihat judul "Nusantara Cerdas", kartu biru "Kota Cerdas untuk Semua", dan grid enam pilar Smart City.
3. Ketuk tab **Layanan** di navigasi bagian bawah.
4. Pada tab **Kesehatan**, ketuk ikon bintang di kanan kartu "Layanan Ambulans". Ikon berubah menjadi bintang berwarna amber.
5. Ketuk kartu tersebut. Terbuka halaman **Detail Layanan** yang berisi instansi, jam pelayanan (24 Jam), dan deskripsi.
6. Ketuk **Ajukan Permohonan**. Tombol berubah menjadi "Mengajukan..." dengan spinner selama sekitar satu detik.
7. Aplikasi kembali ke halaman Layanan dan muncul `SnackBar` berisi pesan "Permohonan Layanan Ambulans telah diajukan".
8. Perhatikan ikon **Warga** di navigasi, kini ada badge angka `1`.
9. Ketuk tab **Warga**. Di bagian "Layanan Favorit" kini muncul entri "Layanan Ambulans".
10. Coba perkecil jendela aplikasi (di browser, pakai Inspect Device) sehingga lebar di bawah 600 px. Navigasi berubah dari `NavigationRail` menjadi `NavigationBar`.
11. Buka menu drawer, lalu coba **Pengaturan Kota**, **Tentang Aplikasi**, atau **Keluar** untuk melihat dialog konfirmasi.
12. Dari halaman Warga, ketuk **Riwayat Laporan** untuk melihat tiga laporan beserta statusnya.

## Konfigurasi

- **`pubspec.yaml`**: nama package `nusantara_nav_707012400103`, versi `1.0.0+1`, versi SDK Dart `^3.10.1`, daftar dependency, dan flag `uses-material-design: true`. Tidak ada section `assets` maupun `fonts`, jadi aplikasi memakai Material Icons bawaan.
- **`analysis_options.yaml`**: mengaktifkan `package:flutter_lints/flutter.yaml`. Aturan lint tambahan bisa ditulis di file ini.
- **`android/app/src/main/AndroidManifest.xml`**: `android:label` masih bernilai default `nusantara_nav_707012400103`, belum diganti menjadi "Nusantara Cerdas". `applicationId` di `android/app/build.gradle.kts` juga masih `com.example.nusantara_nav_707012400103`.
- **`web/index.html` dan `web/manifest.json`**: nama aplikasi masih default `nusantara_nav_707012400103` dan deskripsi masih "A new Flutter project.".
- **Tema dan warna**: tema diambil dari `ColorScheme.fromSeed(seedColor: Colors.blue)` di `main.dart`. Warna biru juga dipakai langsung di banyak widget halaman, misalnya `Colors.blue` dan `Colors.blue.shade50`.
- **Breakpoint responsif**: nilai 600 px untuk navigasi dan 700 px untuk jumlah kolom grid pilar ditulis langsung di dalam widget, bukan lewat konstanta.
- **Tidak ada** berkas `.env`, konfigurasi API key, kredensial, atau secret apa pun di repository ini.
