<div align="center">

# 🗺️ Menegal — Jelajah Wisata Tegal

**Aplikasi panduan wisata interaktif Kota & Kabupaten Tegal berbasis Flutter**

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-sqflite-003B57?logo=sqlite&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Desktop-lightgrey)
![Version](https://img.shields.io/badge/Version-2.0.0-brightgreen)

</div>

---

## 📖 Deskripsi

**Menegal** adalah aplikasi wisata lokal yang membantu pengguna menjelajahi destinasi-destinasi menarik di Tegal — lengkap dengan sejarah, latar belakang budaya, dan legenda setempat. Pengguna dapat menyimpan destinasi favorit, mengikuti kuis trivia berhadiah poin, dan bersaing di papan peringkat.

---

## ✨ Fitur Utama

### 🏠 Beranda
- Menampilkan daftar destinasi wisata Tegal
- Data dimuat langsung dari SQLite — status favorit selalu sinkron
- Navigasi ke detail destinasi dengan satu ketuk

### 🔍 Explore
- Jelajahi semua destinasi tersedia
- Toggle simpan favorit langsung dari kartu destinasi
- Tombol kembali (×) mengarahkan ke tab Beranda

### ❤️ Favorit
- Menampilkan daftar destinasi yang disimpan pengguna
- Reload otomatis setiap kali tab dibuka — selalu up-to-date
- Hapus favorit langsung dari daftar

### 📍 Detail Destinasi
- Foto destinasi, alamat, dan jarak
- **Deskripsi kaya**: penjelasan umum, 🏛️ Latar Belakang & Sejarah, dan 🌿 Legenda
- Tombol navigasi ke Google Maps
- Tombol buka website resmi
- Akses langsung ke Trivia destinasi tersebut

### 🧠 Trivia
- 5 soal pilihan ganda per destinasi (30 soal total untuk 6 destinasi)
- Feedback jawaban benar/salah secara visual langsung
- Skor dihitung: **20 poin per jawaban benar**
- Poin tersimpan ke database dan ditambahkan ke total poin akun
- Layar hasil menampilkan skor, persentase, dan jumlah benar

### 🏆 Leaderboard
- Papan peringkat 10 pengguna teratas berdasarkan total poin
- Podium visual untuk peringkat 1–3
- Reload otomatis setiap kali tab dibuka

### 👤 Profil
- Lihat dan edit nama, gender, usia
- Total poin tampil dan update setiap masuk ke tab ini
- Logout akun

### 🔐 Autentikasi
- Halaman Login dan Registrasi
- Data pengguna tersimpan lokal di SQLite

---

## 🗂️ Struktur Proyek

```
lib/
├── main.dart                        # Entry point, inisialisasi FFI & routing
├── models/
│   └── destination.dart             # Model: Destination, TriviaQuestion, AppUser, DestinationData
├── screens/
│   ├── splash_screen.dart           # Splash screen awal
│   ├── login_screen.dart            # Halaman login
│   ├── register_screen.dart         # Halaman registrasi
│   ├── main_screen.dart             # IndexedStack + GlobalKey reload per tab
│   ├── home_screen.dart             # Tab Beranda
│   ├── explore_screen.dart          # Tab Explore
│   ├── favorite_screen.dart         # Tab Favorit
│   ├── destination_detail_screen.dart # Detail destinasi + trivia launcher
│   ├── trivia_screen.dart           # Kuis trivia + simpan poin ke DB
│   ├── leaderboard_screen.dart      # Papan peringkat
│   ├── profile_screen.dart          # Profil pengguna
│   └── settings_screen.dart         # Pengaturan
├── services/
│   └── database_service.dart        # Singleton SQLite: semua operasi DB
├── theme/
│   └── app_theme.dart               # Warna, tipografi, konstanta tema
└── widgets/
    └── common_widgets.dart          # Widget reusable: card, nav bar, search bar, dll
```

---

## 🗄️ Skema Database

| Tabel | Kolom Utama | Keterangan |
|---|---|---|
| `users` | id, name, email, password, gender, age, totalPoints | Data akun pengguna |
| `destinations` | id, name, address, distanceKm, description, imageUrl, latitude, longitude, websiteUrl | Data destinasi wisata |
| `trivia_questions` | id, destinationId, question, optionA–D, correctIndex | Soal trivia per destinasi |
| `user_favorites` | userId, destinationId | Relasi favorit pengguna |
| `user_scores` | id, userId, destinationId, score, completedAt | Riwayat skor trivia |

---

## 🏛️ Destinasi & Trivia

| # | Destinasi | Soal Trivia |
|---|---|---|
| 1 | Curug Cantel | 5 soal |
| 2 | Guci Hot Springs | 5 soal |
| 3 | Guci Forest | 5 soal |
| 4 | Pantai Alam Indah | 5 soal |
| 5 | Taman Rakyat Slawi | 5 soal |
| 6 | Waduk Cacaban | 5 soal |

Setiap destinasi dilengkapi deskripsi berisi **penjelasan umum**, **latar belakang & sejarah**, dan **legenda lokal**.

---

## ⚙️ Arsitektur & Pola Desain

### Sinkronisasi State antar Tab (`IndexedStack`)
`IndexedStack` membuat semua tab hidup di memory sekaligus — `initState` hanya dipanggil sekali. Solusinya menggunakan `GlobalKey` per screen untuk memanggil `loadData()` saat tab aktif:

```dart
// main_screen.dart
void _onTabTap(int index) {
  setState(() => _currentIndex = index);
  if (index == 0) _homeKey.currentState?.loadData();
  if (index == 1) _exploreKey.currentState?.loadData();
  if (index == 2) _favoriteKey.currentState?.loadData();
  if (index == 3) _profileKey.currentState?.loadData();
  if (index == 4) _leaderboardKey.currentState?.loadData();
}
```

### DatabaseService Singleton
Semua operasi database terpusat dalam satu class singleton untuk menghindari multiple connection:

```dart
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();
}
```

### Callback Favorit dari Detail ke Parent
Perubahan favorit di `DestinationDetailScreen` dikomunikasikan ke parent screen lewat callback agar UI tetap sinkron tanpa reload penuh:

```dart
DestinationDetailScreen(
  destination: dest,
  userId: widget.userId,
  onFavoriteChanged: (id, isFav) {
    setState(() => dest.isFavorite = isFav);
  },
)
```

---

## 🚀 Cara Menjalankan

### Prasyarat
- Flutter SDK `>=3.0.0 <4.0.0`
- Dart SDK `>=3.0.0`
- Android Studio / VS Code dengan Flutter extension
- Android Emulator atau perangkat fisik

### Instalasi

```bash
# 1. Clone repositori
git clone https://github.com/username/menegal.git
cd menegal

# 2. Install dependencies
flutter pub get

# 3. Jalankan aplikasi
flutter run
```

### Menjalankan di Desktop (Windows/Linux/macOS)

Aplikasi mendukung platform desktop berkat `sqflite_common_ffi`:

```bash
flutter run -d windows
flutter run -d linux
flutter run -d macos
```

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6
  google_maps_flutter: ^2.5.0    # Peta interaktif di detail destinasi
  url_launcher: ^6.2.0            # Buka website & navigasi eksternal
  sqflite: ^2.3.0                 # Database SQLite lokal
  sqflite_common_ffi: ^2.3.0     # Dukungan SQLite untuk platform desktop
  path: ^1.8.3                    # Utilitas path untuk lokasi database
```

---

## 🔧 Monitoring Database (DB Browser for SQLite)

Untuk memantau isi database saat development:

**Android Emulator:**
```bash
# Ambil file database dari emulator
adb pull /data/data/com.example.tegal_tourism/databases/menegal.db ~/Desktop/menegal.db
```

**iOS Simulator:**
```bash
# Cari file database
find ~/Library/Developer/CoreSimulator -name "menegal.db" 2>/dev/null
```

Buka file `.db` di **DB Browser for SQLite** → tab **Browse Data** → pilih tabel yang ingin dipantau.

> Setiap perubahan di emulator perlu di-pull ulang; DB Browser hanya menampilkan snapshot saat file dibuka.

---

## 🎨 Design System

| Token | Nilai |
|---|---|
| Primary Color | `#2A7F7F` |
| Font Family | Poppins (Regular 500, SemiBold 600, Bold 700) |
| Background | `#F5F7FA` |
| Card / White | `#FFFFFF` |
| Text Primary | `#1A1A2E` |
| Text Secondary | `#6B7280` |

---

## 📄 Lisensi

Proyek ini dibuat untuk keperluan akademik. Seluruh data destinasi, sejarah, dan legenda ditulis berdasarkan riset budaya lokal Tegal.

---

<div align="center">
Dibuat dengan ❤️ untuk Tegal
</div>
