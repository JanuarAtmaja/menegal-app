# MENEGAL - SQLite DATABASE SETUP GUIDE

## 📦 INSTALL DEPENDENCIES

Edit `pubspec.yaml`, kemudian jalankan:

```bash
flutter pub get
```

Dependencies yang ditambah:
- `sqflite: ^2.3.0` - SQLite database
- `path: ^1.8.3` - Path handling

---

## 🗄️ DATABASE SCHEMA

### 1. **users** - Data Login & Profil
```sql
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  name TEXT NOT NULL,
  gender TEXT,
  age INTEGER,
  totalPoints INTEGER DEFAULT 0,
  createdAt TEXT
)
```

**Fields:**
- `id` - User ID unik
- `email` - Email login (unique)
- `password` - Password (plaintext, bisa di-hash)
- `name` - Nama lengkap (dari register)
- `gender` - Jenis kelamin (Male/Female)
- `age` - Umur (dari profil)
- `totalPoints` - Total poin dari trivia
- `createdAt` - Waktu pembuatan akun

---

### 2. **destinations** - Data Wisata
```sql
CREATE TABLE destinations (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  address TEXT NOT NULL,
  distanceKm REAL NOT NULL,
  description TEXT NOT NULL,
  imageUrl TEXT NOT NULL,
  latitude REAL NOT NULL,
  longitude REAL NOT NULL,
  websiteUrl TEXT
)
```

**Fields:**
- `id` - Destination ID
- `name` - Nama wisata
- `address` - Alamat lengkap
- `distanceKm` - Jarak dari pusat
- `description` - Deskripsi panjang
- `imageUrl` - Path gambar (img/nama.jpg)
- `latitude` - Koordinat latitude
- `longitude` - Koordinat longitude
- `websiteUrl` - Website destinasi

---

### 3. **favorites** - Relasi User-Destination
```sql
CREATE TABLE favorites (
  id TEXT PRIMARY KEY,
  userId TEXT NOT NULL,
  destinationId TEXT NOT NULL,
  addedAt TEXT,
  UNIQUE(userId, destinationId),
  FOREIGN KEY (userId) REFERENCES users(id),
  FOREIGN KEY (destinationId) REFERENCES destinations(id)
)
```

**Purpose:** Track destinasi favorit user
**Fields:**
- `id` - Favorite ID
- `userId` - ID user (foreign key)
- `destinationId` - ID destinasi (foreign key)
- `addedAt` - Waktu ditambahkan

**Constraint:** Satu user tidak bisa add destinasi yang sama 2x

---

### 4. **trivia_questions** - Pertanyaan Kuis
```sql
CREATE TABLE trivia_questions (
  id TEXT PRIMARY KEY,
  destinationId TEXT NOT NULL,
  question TEXT NOT NULL,
  optionA TEXT NOT NULL,
  optionB TEXT NOT NULL,
  optionC TEXT NOT NULL,
  optionD TEXT NOT NULL,
  correctIndex INTEGER NOT NULL,
  FOREIGN KEY (destinationId) REFERENCES destinations(id)
)
```

**Purpose:** Menyimpan 5 pertanyaan per destinasi
**Fields:**
- `id` - Question ID
- `destinationId` - ID destinasi (foreign key)
- `question` - Teks pertanyaan
- `optionA`, `optionB`, `optionC`, `optionD` - 4 pilihan jawaban
- `correctIndex` - Index jawaban benar (0-3)

---

### 5. **user_scores** - Skor Trivia User
```sql
CREATE TABLE user_scores (
  id TEXT PRIMARY KEY,
  userId TEXT NOT NULL,
  destinationId TEXT NOT NULL,
  score INTEGER NOT NULL,
  completedAt TEXT,
  FOREIGN KEY (userId) REFERENCES users(id),
  FOREIGN KEY (destinationId) REFERENCES destinations(id)
)
```

**Purpose:** Track skor user per destinasi + update totalPoints
**Fields:**
- `id` - Score ID
- `userId` - ID user (foreign key)
- `destinationId` - ID destinasi (foreign key)
- `score` - Skor trivia (0-100)
- `completedAt` - Waktu selesai

---

## 🔑 DEMO DATA

Database dibuat dengan 5 demo user + 6 destinasi + trivia questions otomatis.

**Demo Users:**
```
user1 → demo@menegal.id / demo1234 (Januar Atmaja, M, 22, 340 poin)
user2 → sari@menegal.id / demo1234 (Sari Dewi, F, 24, 280 poin)
user3 → budi@menegal.id / demo1234 (Budi Santoso, M, 28, 200 poin)
user4 → rizki@menegal.id / demo1234 (Rizki Ramadan, M, 20, 160 poin)
user5 → putri@menegal.id / demo1234 (Putri Rahayu, F, 21, 120 poin)
```

Semua data auto-insert saat first run.

---

## 📱 FITUR TERINTEGRASI

### 1. LOGIN & REGISTER
- **Query:** `SELECT * FROM users WHERE email = ? AND password = ?`
- **Insert:** Nama dari register → users table → langsung bisa lihat di profil
- Database validates email unique

### 2. PROFILE
- **Load:** `SELECT * FROM users WHERE id = ?`
- **Update:** Edit name/gender/age → `UPDATE users`
- Dropdown destinasi dihapus (sesuai permintaan)
- Display: Nama, email, jenis kelamin, umur, total poin

### 3. FAVORITES
- **Add:** `INSERT INTO favorites (userId, destinationId)`
- **Remove:** `DELETE FROM favorites WHERE userId = ? AND destinationId = ?`
- **Query:** `SELECT destinationId FROM favorites WHERE userId = ?`
- Layar Favorite mulai dengan 0 destinasi, user bisa tambah via Home/Explore

### 4. LEADERBOARD
- **Query:** `SELECT * FROM users ORDER BY totalPoints DESC LIMIT 10`
- Auto-populate dengan 5 demo user
- Real-time jika user selesai trivia (totalPoints terupdate)

### 5. TRIVIA & SCORING
- **Load:** `SELECT * FROM trivia_questions WHERE destinationId = ?`
- **Save Score:** `INSERT INTO user_scores` + `UPDATE users SET totalPoints = totalPoints + score`
- 5 soal per destinasi
- 20 poin per jawaban benar (max 100 poin per trivia)

---

## 🚀 STEP-BY-STEP RUN

### 1. Setup Project
```bash
unzip wisata_tegal_sqlite.zip
cd wisata_tegal
flutter pub get
```

### 2. Build & Run
```bash
# Android/iOS
flutter run

# Windows
flutter run -d windows

# Web
flutter run -d chrome
```

**First run:** Database otomatis create + insert demo data

### 3. Test Login
- Email: `demo@menegal.id`
- Password: `demo1234`

### 4. Test Features
✅ Edit profil → data tersimpan di SQLite
✅ Add favorite → data tersimpan di SQLite
✅ Buka leaderboard → 5 demo user terlihat
✅ Main trivia → skor update otomatis ke totalPoints

---

## 📝 CUSTOMIZE DATA

### Tambah User Baru
Edit `lib/services/database_service.dart` → `_insertDemoUsers()`:

```dart
{
  'id': 'user6',
  'email': 'newuser@menegal.id',
  'password': 'demo1234',
  'name': 'Nama User',
  'gender': 'Male',
  'age': 25,
  'totalPoints': 150,
  'createdAt': DateTime.now().toIso8601String(),
},
```

### Tambah Trivia Soal
Edit `lib/services/database_service.dart` → `_insertTrivia()`:

```dart
{
  'destinationId': '1', // Destinasi mana
  'question': 'Pertanyaan?',
  'optionA': 'Jawaban A',
  'optionB': 'Jawaban B',
  'optionC': 'Jawaban C',
  'optionD': 'Jawaban D',
  'correctIndex': 0, // Index jawaban benar (0-3)
},
```

---

## 🔐 SECURITY NOTES

⚠️ **For Production:**
- Hash password menggunakan `bcrypt` atau `argon2`
- Jangan simpan password plaintext
- Gunakan encryption untuk sensitive data
- Implement rate limiting untuk login

```dart
import 'package:bcrypt/bcrypt.dart';

// Hash saat register
String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

// Verify saat login
bool isPasswordCorrect = BCrypt.checkpw(password, hashedPassword);
```

---

## 📊 DATABASE QUERIES

### Login User
```dart
final user = await _db.loginUser('demo@menegal.id', 'demo1234');
```

### Get User Profile
```dart
final user = await _db.getUserById('user1');
```

### Update User
```dart
user.name = 'New Name';
await _db.updateUser(user);
```

### Get User Favorites
```dart
final favIds = await _db.getUserFavorites('user1');
```

### Add to Favorites
```dart
await _db.addFavorite('user1', 'dest_1');
```

### Get Leaderboard
```dart
final top10 = await _db.getLeaderboard();
```

### Save Trivia Score
```dart
await _db.saveScore('user1', 'dest_1', 100); // otomatis update totalPoints
```

---

## ✅ CHECKLIST

- [ ] Run `flutter pub get`
- [ ] First run → database auto-create
- [ ] Login demo@menegal.id / demo1234
- [ ] Edit profil → data persist
- [ ] Add favorite → sync ke database
- [ ] View leaderboard → 5 user terlihat
- [ ] Main trivia → skor terupdate
- [ ] Close app → buka lagi → data masih ada

---

**Database siap! Enjoy!** 🎉
