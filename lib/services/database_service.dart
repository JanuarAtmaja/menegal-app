// lib/services/database_service.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/destination.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'menegal.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Hapus trivia lama dan isi ulang dengan soal lengkap semua destinasi
          await db.delete('trivia_questions');
          await _insertTrivia(db);
          // Update deskripsi destinasi dengan versi lengkap
          await _insertDestinations(db);
        }
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabel Users (untuk login & profil)
    await db.execute('''
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
    ''');

    // Tabel Destinations (data wisata)
    await db.execute('''
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
    ''');

    // Tabel Favorites (relasi user-destination)
    await db.execute('''
      CREATE TABLE favorites (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        destinationId TEXT NOT NULL,
        addedAt TEXT,
        FOREIGN KEY (userId) REFERENCES users(id),
        FOREIGN KEY (destinationId) REFERENCES destinations(id),
        UNIQUE(userId, destinationId)
      )
    ''');

    // Tabel Trivia (pertanyaan kuis per destinasi)
    await db.execute('''
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
    ''');

    // Tabel User Scores (skor trivia per user)
    await db.execute('''
      CREATE TABLE user_scores (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        destinationId TEXT NOT NULL,
        score INTEGER NOT NULL,
        completedAt TEXT,
        FOREIGN KEY (userId) REFERENCES users(id),
        FOREIGN KEY (destinationId) REFERENCES destinations(id)
      )
    ''');

    // Insert demo users
    await _insertDemoUsers(db);

    // Insert destinations
    await _insertDestinations(db);

    // Insert trivia questions
    await _insertTrivia(db);

    // Insert demo user scores
    await _insertDemoScores(db);
  }

  Future<void> _insertDemoUsers(Database db) async {
    final demoUsers = [
      {
        'id': 'user1',
        'email': 'demo@menegal.id',
        'password': 'demo1234',
        'name': 'Januar Atmaja',
        'gender': 'Male',
        'age': 22,
        'totalPoints': 340,
        'createdAt': DateTime.now().toIso8601String(),
      },
      {
        'id': 'user2',
        'email': 'saski@menegal.id',
        'password': 'demo1234',
        'name': 'Elisabeth N.S.',
        'gender': 'Female',
        'age': 24,
        'totalPoints': 280,
        'createdAt': DateTime.now().toIso8601String(),
      },
      {
        'id': 'user3',
        'email': 'temi@menegal.id',
        'password': 'demo1234',
        'name': 'Mister Temi',
        'gender': 'Male',
        'age': 28,
        'totalPoints': 200,
        'createdAt': DateTime.now().toIso8601String(),
      },
      {
        'id': 'user4',
        'email': 'rizki@menegal.id',
        'password': 'demo1234',
        'name': 'Rizki Ramadan',
        'gender': 'Male',
        'age': 20,
        'totalPoints': 160,
        'createdAt': DateTime.now().toIso8601String(),
      },
      {
        'id': 'user5',
        'email': 'putri@menegal.id',
        'password': 'demo1234',
        'name': 'Putri Rahayu',
        'gender': 'Female',
        'age': 21,
        'totalPoints': 120,
        'createdAt': DateTime.now().toIso8601String(),
      },
    ];

    for (final user in demoUsers) {
      await db.insert('users', user, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
  }

  Future<void> _insertDestinations(Database db) async {
    final destinations = [
      {
        'id': '1',
        'name': 'Curug Cantel',
        'address': 'Jl. Raya Tegal, Tegal',
        'distanceKm': 5.0,
        'description': 'Tersembunyi di balik lebatnya hutan kaki Gunung Slamet, air terjun ini telah menjadi bagian dari kehidupan masyarakat Tegal selama berabad-abad.\n\n'
            '🏛️ Latar Belakang & Sejarah\n'
            'Air terjun ini pertama kali tercatat dalam naskah kuno abad ke-16 sebagai tempat semedi para tokoh spiritual Tegal. Pada masa kolonial Belanda, kawasan ini dijadikan sumber air bersih untuk perkebunan teh di lereng Slamet dan menjadi titik penting jalur perdagangan antara pesisir utara dan pedalaman.\n\n'
            '🌿 Legenda\n'
            'Konon, air terjun ini ditemukan oleh Ki Ageng Sutawijaya — seorang petapa sakti yang sedang mencari tempat bertapa. Ia dipandu oleh seekor rusa putih yang tiba-tiba menghilang tepat di depan guyuran air. Masyarakat setempat meyakini bahwa rusa putih itu adalah jelmaan penjaga alam yang menyambut kedatangan sang petapa. Hingga kini, air terjun ini dipercaya memiliki energi penyucian jiwa dan kerap menjadi lokasi ritual tolak bala pada malam Satu Suro.',
        'imageUrl': 'img/tegal_waterfall.webp',
        'latitude': -7.1282,
        'longitude': 109.1347,
        'websiteUrl': 'https://www.tegaltourism.id/waterfall',
      },
      {
        'id': '2',
        'name': 'Guci Hot Springs',
        'address': 'Jl. Raya Guci, Tegal',
        'distanceKm': 25.0,
        'description': 'Berada di lereng barat Gunung Slamet pada ketinggian sekitar 1.050 mdpl, Guci adalah surga air panas alami yang telah memikat wisatawan selama lebih dari satu abad.\n\n'
            '🏛️ Latar Belakang & Sejarah\n'
            'Nama "Guci" berasal dari bahasa Jawa Kuno yang berarti wadah atau tempat penyimpanan — merujuk pada cekungan batu alami tempat air panas berkumpul. Kawasan ini mulai ramai dikunjungi pada masa pemerintahan Hindia Belanda ketika pejabat kolonial menjadikannya tempat peristirahatan resmi. Pada era 1920-an, dibangunlah fasilitas mandi pertama yang kini jejaknya masih bisa dilihat dari struktur batu kuno di area utama.\n\n'
            '🌿 Legenda\n'
            'Legenda setempat menceritakan bahwa sumber air panas Guci berasal dari tangisan Dewi Nawang Wulan, bidadari yang turun ke bumi dan kehilangan selendangnya. Air matanya yang bercampur panas bumi menyembur menjadi sumber-sumber panas yang tersebar di kawasan ini. Dipercaya bahwa mandi di sini pada hari Kamis Wage akan membawa keberuntungan dan menyembuhkan penyakit kulit.',
        'imageUrl': 'img/guci_hot_springs.jpg',
        'latitude': -7.2142,
        'longitude': 109.0891,
        'websiteUrl': 'https://www.gucihotsprings.id',
      },
      {
        'id': '3',
        'name': 'Guci Forest',
        'address': 'Jalan Lingkar, Bojong, Tegal',
        'distanceKm': 26.0,
        'description': 'Hamparan hutan pinus dan damar yang menyelimuti lereng Gunung Slamet di kawasan Guci ini menawarkan pengalaman alam yang sunyi, segar, dan penuh misteri.\n\n'
            '🏛️ Latar Belakang & Sejarah\n'
            'Hutan Guci merupakan bagian dari kawasan hutan lindung yang dikelola Perum Perhutani sejak zaman penjajahan. Pada masa perjuangan kemerdekaan, hutan ini menjadi persembunyian para pejuang Laskar Hisbullah dari Tegal yang menghindari patroli Belanda. Sebuah batu besar di tengah hutan yang kini dijuluki "Batu Perjuangan" masih berdiri sebagai penanda sejarah.\n\n'
            '🌿 Legenda\n'
            'Warga sekitar meyakini hutan ini dijaga oleh sosok yang disebut "Mbah Slamet Wana" — roh leluhur penjaga gunung yang berwujud kakek tua berambut putih. Siapa pun yang masuk hutan dengan niat buruk konon akan tersesat meskipun hanya beberapa langkah dari jalan utama. Para penebang kayu ilegal kerap bersaksi menemukan jejak kaki raksasa di tanah basah setelah malam hari.',
        'imageUrl': 'img/guci_forest.jpg',
        'latitude': -7.2200,
        'longitude': 109.0850,
        'websiteUrl': 'https://www.guciforest.id',
      },
      {
        'id': '4',
        'name': 'Pantai Alam Indah',
        'address': 'Pantai Alam Indah, Tegal',
        'distanceKm': 5.0,
        'description': 'Membentang di tepi utara Kota Tegal, Pantai Alam Indah (PAI) adalah wajah maritim kota ini — tempat nelayan pulang berlabuh, anak-anak bermain, dan matahari perlahan tenggelam di cakrawala Laut Jawa.\n\n'
            '🏛️ Latar Belakang & Sejarah\n'
            'Pantai ini telah menjadi pusat kehidupan nelayan Tegal sejak abad ke-17 ketika Tegal berkembang sebagai pelabuhan niaga penting di pesisir utara Jawa. Pada masa VOC, kapal-kapal dagang Belanda kerap berlabuh di perairan ini untuk mengangkut hasil bumi dari daerah pedalaman. Kawasan pantai kemudian ditata menjadi ruang publik pada era 1980-an dan kini menjadi ikon wisata kota.\n\n'
            '🌿 Legenda\n'
            'Nelayan tua Tegal menuturkan kisah "Nyi Blorong Segara" — penguasa laut utara yang berwujud wanita cantik berambut panjang. Setiap malam Jumat Kliwon, nelayan dilarang melaut karena dipercaya Nyi Blorong sedang berpatroli. Sebuah sesaji bunga tujuh rupa masih rutin dilarung ke laut setiap tahun sebagai bentuk rasa syukur dan permohonan keselamatan.',
        'imageUrl': 'img/pantai_alam_indah.jpeg',
        'latitude': -6.8614,
        'longitude': 109.1250,
        'websiteUrl': 'https://www.pantaialamindah.id',
      },
      {
        'id': '5',
        'name': 'Taman Rakyat Slawi',
        'address': 'Slawi, Tegal',
        'distanceKm': 15.0,
        'description': 'Terletak di jantung Kota Slawi, ibu kota Kabupaten Tegal, taman ini adalah paru-paru kota sekaligus saksi bisu perjalanan panjang masyarakat Slawi dari masa ke masa.\n\n'
            '🏛️ Latar Belakang & Sejarah\n'
            'Kawasan ini dahulu merupakan alun-alun yang dibangun pada era pemerintahan Bupati Tegal pertama di abad ke-18. Pada masa kemerdekaan, lapangan ini menjadi tempat pembacaan proklamasi oleh pejuang lokal dan pengibaran bendera merah putih pertama di Tegal. Kini taman ini direvitalisasi dengan taman bermain, jogging track, dan panggung hiburan.\n\n'
            '🌿 Legenda\n'
            'Pohon beringin tua di sudut taman dipercaya sebagai tempat bersemayamnya roh Ki Gede Sebayu — tokoh pembabat pertama Kota Tegal. Konon, setiap kali ada rencana pembangunan yang akan mengorbankan pohon tersebut, selalu terjadi halangan tak terduga hingga akhirnya rencana itu dibatalkan.',
        'imageUrl': 'img/taman_rakyat_slawi.jpeg',
        'latitude': -6.9987,
        'longitude': 109.1400,
        'websiteUrl': 'https://www.tamanrakyatslawi.id',
      },
      {
        'id': '6',
        'name': 'Waduk Cacaban',
        'address': 'Cacaban, Tegal',
        'distanceKm': 20.0,
        'description': 'Dikelilingi bukit-bukit hijau dan hutan tropis, Waduk Cacaban adalah bendungan tua yang menyimpan kisah pengorbanan sebuah desa demi kemakmuran ribuan hektar sawah di Tegal.\n\n'
            '🏛️ Latar Belakang & Sejarah\n'
            'Waduk Cacaban dibangun antara tahun 1952–1958 sebagai proyek irigasi besar pertama setelah kemerdekaan Indonesia di Jawa Tengah. Pembangunannya menenggelamkan Desa Cacaban Lama beserta seluruh sawah, kebun, dan rumah penduduknya. Waduk ini menjadi tulang punggung irigasi yang mengairi lebih dari 24.000 hektar lahan pertanian di Kabupaten Tegal.\n\n'
            '🌿 Legenda\n'
            'Di kalangan warga, beredar kepercayaan bahwa di kedalaman waduk masih berdiri "Desa Gaib Cacaban" — desa yang tenggelam namun tidak musnah, hanya berpindah dimensi. Pada malam-malam tertentu, nelayan mengaku mendengar suara azan dan kokok ayam dari bawah permukaan air. Ada pula yang mengaku melihat cahaya kekuningan bergerak di dasar waduk saat bulan purnama.',
        'imageUrl': 'img/waduk_cacaban.jpg',
        'latitude': -7.0500,
        'longitude': 109.2200,
        'websiteUrl': 'https://www.wadukcacaban.id',
      },
    ];

    for (final dest in destinations) {
      await db.insert('destinations', dest, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<void> _insertTrivia(Database db) async {
    final triviaData = [
      // ── Destinasi 1: Tegal Waterfall ──
      {'destinationId': '1', 'question': 'Siapa tokoh yang konon menemukan Tegal Waterfall?', 'optionA': 'Ki Ageng Sutawijaya', 'optionB': 'Pangeran Diponegoro', 'optionC': 'Ki Hajar Dewantara', 'optionD': 'Raden Saleh', 'correctIndex': 0},
      {'destinationId': '1', 'question': 'Hewan apa yang dipercaya memandu penemuan air terjun ini?', 'optionA': 'Rusa hitam', 'optionB': 'Harimau putih', 'optionC': 'Rusa putih', 'optionD': 'Burung merak', 'correctIndex': 2},
      {'destinationId': '1', 'question': 'Air terjun ini terletak di kaki gunung apa?', 'optionA': 'Gunung Merapi', 'optionB': 'Gunung Sindoro', 'optionC': 'Gunung Slamet', 'optionD': 'Gunung Sumbing', 'correctIndex': 2},
      {'destinationId': '1', 'question': 'Ritual apa yang sering dilakukan di air terjun ini?', 'optionA': 'Upacara panen', 'optionB': 'Ritual tolak bala malam Satu Suro', 'optionC': 'Perayaan tahun baru', 'optionD': 'Ziarah makam wali', 'correctIndex': 1},
      {'destinationId': '1', 'question': 'Pada masa kolonial, kawasan ini digunakan untuk apa?', 'optionA': 'Benteng pertahanan', 'optionB': 'Penjara tahanan', 'optionC': 'Sumber air perkebunan teh', 'optionD': 'Jalur rel kereta', 'correctIndex': 2},

      // ── Destinasi 2: Guci Hot Springs ──
      {'destinationId': '2', 'question': 'Guci Hot Springs berada di lereng gunung apa?', 'optionA': 'Gunung Merapi', 'optionB': 'Gunung Slamet', 'optionC': 'Gunung Sindoro', 'optionD': 'Gunung Sumbing', 'correctIndex': 1},
      {'destinationId': '2', 'question': 'Arti kata "Guci" dalam bahasa Jawa Kuno adalah?', 'optionA': 'Sumber panas', 'optionB': 'Kolam suci', 'optionC': 'Wadah atau tempat penyimpanan', 'optionD': 'Tanah subur', 'correctIndex': 2},
      {'destinationId': '2', 'question': 'Siapa tokoh legenda yang air matanya dipercaya menciptakan sumber panas Guci?', 'optionA': 'Dewi Sri', 'optionB': 'Dewi Nawang Wulan', 'optionC': 'Nyi Roro Kidul', 'optionD': 'Dewi Kwan Im', 'correctIndex': 1},
      {'destinationId': '2', 'question': 'Pada hari apa mandi di Guci dipercaya membawa keberuntungan?', 'optionA': 'Senin Pahing', 'optionB': 'Jumat Kliwon', 'optionC': 'Kamis Wage', 'optionD': 'Sabtu Legi', 'correctIndex': 2},
      {'destinationId': '2', 'question': 'Guci Hot Springs berada di ketinggian sekitar berapa mdpl?', 'optionA': '500 mdpl', 'optionB': '750 mdpl', 'optionC': '1.050 mdpl', 'optionD': '1.500 mdpl', 'correctIndex': 2},

      // ── Destinasi 3: Guci Forest ──
      {'destinationId': '3', 'question': 'Hutan Guci dikelola oleh lembaga apa?', 'optionA': 'BKSDA', 'optionB': 'Perum Perhutani', 'optionC': 'Kementerian Lingkungan Hidup', 'optionD': 'Dinas Pariwisata Tegal', 'correctIndex': 1},
      {'destinationId': '3', 'question': 'Siapa sosok legendaris penjaga Hutan Guci yang dipercaya warga?', 'optionA': 'Ki Ageng Slamet', 'optionB': 'Mbah Slamet Wana', 'optionC': 'Ki Gede Sebayu', 'optionD': 'Eyang Guci', 'correctIndex': 1},
      {'destinationId': '3', 'question': 'Apa nama batu bersejarah di tengah Hutan Guci?', 'optionA': 'Batu Sakral', 'optionB': 'Batu Legenda', 'optionC': 'Batu Perjuangan', 'optionD': 'Batu Slamet', 'correctIndex': 2},
      {'destinationId': '3', 'question': 'Pada masa kemerdekaan, hutan ini menjadi persembunyian laskar dari mana?', 'optionA': 'Laskar Mataram dari Yogyakarta', 'optionB': 'Laskar Hisbullah dari Tegal', 'optionC': 'Laskar Hizbul Wathan dari Pekalongan', 'optionD': 'Laskar Santri dari Brebes', 'correctIndex': 1},
      {'destinationId': '3', 'question': 'Jenis pohon dominan apa yang tumbuh di Hutan Guci?', 'optionA': 'Jati dan mahoni', 'optionB': 'Bambu dan rotan', 'optionC': 'Pinus dan damar', 'optionD': 'Akasia dan sengon', 'correctIndex': 2},

      // ── Destinasi 4: Pantai Alam Indah ──
      {'destinationId': '4', 'question': 'Singkatan dari nama pantai ini adalah?', 'optionA': 'PAI', 'optionB': 'PAN', 'optionC': 'PAT', 'optionD': 'PAL', 'correctIndex': 0},
      {'destinationId': '4', 'question': 'Siapa penguasa laut utara versi legenda nelayan Tegal?', 'optionA': 'Nyi Roro Kidul', 'optionB': 'Dewi Lanjar', 'optionC': 'Nyi Blorong Segara', 'optionD': 'Nyi Mas Gandasari', 'correctIndex': 2},
      {'destinationId': '4', 'question': 'Pada malam apa nelayan dilarang melaut di pantai ini?', 'optionA': 'Malam Satu Suro', 'optionB': 'Malam Jumat Kliwon', 'optionC': 'Malam Selasa Wage', 'optionD': 'Malam Rabu Pon', 'correctIndex': 1},
      {'destinationId': '4', 'question': 'Pantai Alam Indah mulai berkembang sebagai ruang publik pada era?', 'optionA': '1960-an', 'optionB': '1970-an', 'optionC': '1980-an', 'optionD': '1990-an', 'correctIndex': 2},
      {'destinationId': '4', 'question': 'Tradisi apa yang rutin dilakukan nelayan di pantai ini?', 'optionA': 'Melarung sesaji bunga tujuh rupa', 'optionB': 'Bakar kapal tua', 'optionC': 'Tanam pohon bakau', 'optionD': 'Lomba perahu layar', 'correctIndex': 0},

      // ── Destinasi 5: Taman Rakyat Slawi ──
      {'destinationId': '5', 'question': 'Taman Rakyat Slawi terletak di ibu kota kabupaten mana?', 'optionA': 'Kabupaten Brebes', 'optionB': 'Kabupaten Pemalang', 'optionC': 'Kabupaten Tegal', 'optionD': 'Kabupaten Pekalongan', 'correctIndex': 2},
      {'destinationId': '5', 'question': 'Roh siapa yang dipercaya bersemayam di pohon beringin tua taman ini?', 'optionA': 'Ki Ageng Sutawijaya', 'optionB': 'Ki Gede Sebayu', 'optionC': 'Pangeran Diponegoro', 'optionD': 'Raden Mas Said', 'correctIndex': 1},
      {'destinationId': '5', 'question': 'Kawasan taman ini dulunya berfungsi sebagai?', 'optionA': 'Pasar tradisional', 'optionB': 'Benteng kolonial', 'optionC': 'Alun-alun pusat kota', 'optionD': 'Pelabuhan sungai', 'correctIndex': 2},
      {'destinationId': '5', 'question': 'Taman ini dibangun pada era pemerintahan siapa?', 'optionA': 'Bupati Tegal pertama abad ke-18', 'optionB': 'Gubernur Jenderal Daendels', 'optionC': 'Sultan Agung', 'optionD': 'Presiden Soekarno', 'correctIndex': 0},
      {'destinationId': '5', 'question': 'Fasilitas apa yang tersedia di Taman Rakyat Slawi saat ini?', 'optionA': 'Kolam renang dan waterpark', 'optionB': 'Jogging track, taman bermain, dan panggung hiburan', 'optionC': 'Museum dan perpustakaan', 'optionD': 'Kebun binatang mini', 'correctIndex': 1},

      // ── Destinasi 6: Waduk Cacaban ──
      {'destinationId': '6', 'question': 'Waduk Cacaban dibangun pada tahun berapa?', 'optionA': '1945–1950', 'optionB': '1952–1958', 'optionC': '1960–1965', 'optionD': '1970–1975', 'correctIndex': 1},
      {'destinationId': '6', 'question': 'Apa nama desa yang tenggelam saat waduk dibangun?', 'optionA': 'Desa Guci Lama', 'optionB': 'Desa Slawi Lama', 'optionC': 'Desa Cacaban Lama', 'optionD': 'Desa Bojong Lama', 'correctIndex': 2},
      {'destinationId': '6', 'question': 'Berapa hektar lahan pertanian yang diairi Waduk Cacaban?', 'optionA': '10.000 hektar', 'optionB': '18.000 hektar', 'optionC': '24.000 hektar', 'optionD': '30.000 hektar', 'correctIndex': 2},
      {'destinationId': '6', 'question': 'Apa nama "desa gaib" yang dipercaya masih ada di dasar waduk?', 'optionA': 'Desa Gaib Slawi', 'optionB': 'Desa Gaib Cacaban', 'optionC': 'Desa Gaib Guci', 'optionD': 'Desa Gaib Bojong', 'correctIndex': 1},
      {'destinationId': '6', 'question': 'Waduk Cacaban merupakan proyek irigasi besar pertama setelah kemerdekaan di?', 'optionA': 'Jawa Barat', 'optionB': 'Jawa Timur', 'optionC': 'Jawa Tengah', 'optionD': 'DI Yogyakarta', 'correctIndex': 2},
    ];

    int counter = 0;
    for (final trivia in triviaData) {
      await db.insert('trivia_questions', {
        'id': 'trivia_${counter++}',
        ...trivia,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
  }

  Future<void> _insertDemoScores(Database db) async {
    final scores = [
      {'id': 'score1', 'userId': 'user1', 'destinationId': '1', 'score': 100, 'completedAt': DateTime.now().toIso8601String()},
      {'id': 'score2', 'userId': 'user1', 'destinationId': '4', 'score': 80, 'completedAt': DateTime.now().toIso8601String()},
      {'id': 'score3', 'userId': 'user2', 'destinationId': '2', 'score': 100, 'completedAt': DateTime.now().toIso8601String()},
      {'id': 'score4', 'userId': 'user3', 'destinationId': '5', 'score': 60, 'completedAt': DateTime.now().toIso8601String()},
    ];

    for (final score in scores) {
      await db.insert('user_scores', score, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
  }

  // ───── USER OPERATIONS ─────

  Future<AppUser?> loginUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (result.isEmpty) return null;
    return AppUser.fromMap(result.first);
  }

  Future<bool> registerUser(String email, String password, String name) async {
    final db = await database;
    try {
      await db.insert('users', {
        'id': 'user_${DateTime.now().millisecondsSinceEpoch}',
        'email': email,
        'password': password,
        'name': name,
        'gender': 'Male',
        'age': 20,
        'totalPoints': 0,
        'createdAt': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<AppUser?> getUserById(String userId) async {
    final db = await database;
    final result = await db.query('users', where: 'id = ?', whereArgs: [userId]);
    if (result.isEmpty) return null;
    return AppUser.fromMap(result.first);
  }

  Future<void> updateUser(AppUser user) async {
    final db = await database;
    await db.update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  // ───── DESTINATION OPERATIONS ─────

  Future<List<TriviaQuestion>> _getTriviaForDestination(Database db, String destinationId) async {
    final result = await db.query(
      'trivia_questions',
      where: 'destinationId = ?',
      whereArgs: [destinationId],
    );
    return result.map((map) => TriviaQuestion.fromMap(map)).toList();
  }

  Future<List<Destination>> getAllDestinations() async {
    final db = await database;
    final result = await db.query('destinations');
    final destinations = <Destination>[];
    for (final map in result) {
      final trivia = await _getTriviaForDestination(db, map['id'] as String);
      destinations.add(Destination.fromMap(map, trivia: trivia));
    }
    return destinations;
  }

  // ───── FAVORITE OPERATIONS ─────

  Future<void> addFavorite(String userId, String destinationId) async {
    final db = await database;
    await db.insert('favorites', {
      'id': 'fav_${DateTime.now().millisecondsSinceEpoch}',
      'userId': userId,
      'destinationId': destinationId,
      'addedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> removeFavorite(String userId, String destinationId) async {
    final db = await database;
    await db.delete('favorites', where: 'userId = ? AND destinationId = ?', whereArgs: [userId, destinationId]);
  }

  Future<List<String>> getUserFavorites(String userId) async {
    final db = await database;
    final result = await db.query('favorites', where: 'userId = ?', whereArgs: [userId]);
    return result.map((row) => row['destinationId'] as String).toList();
  }

  // ───── LEADERBOARD OPERATIONS ─────

  Future<List<AppUser>> getLeaderboard() async {
    final db = await database;
    final result = await db.query('users', orderBy: 'totalPoints DESC', limit: 10);
    return result.map((map) => AppUser.fromMap(map)).toList();
  }

  // ───── SCORE OPERATIONS ─────

  Future<void> saveScore(String userId, String destinationId, int score) async {
    final db = await database;
    final user = await getUserById(userId);
    if (user != null) {
      user.totalPoints += score;
      await updateUser(user);
    }
    await db.insert('user_scores', {
      'id': 'score_${DateTime.now().millisecondsSinceEpoch}',
      'userId': userId,
      'destinationId': destinationId,
      'score': score,
      'completedAt': DateTime.now().toIso8601String(),
    });
  }
}
