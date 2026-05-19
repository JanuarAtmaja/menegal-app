class Destination {
  final String id;
  final String name;
  final String address;
  final double distanceKm;
  final String description;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final String websiteUrl;
  final List<TriviaQuestion> trivia;
  bool isFavorite;

  Destination({
    required this.id,
    required this.name,
    required this.address,
    required this.distanceKm,
    required this.description,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    this.websiteUrl = '',
    this.trivia = const [],
    this.isFavorite = false,
  });

  factory Destination.fromMap(Map<String, dynamic> map, {List<TriviaQuestion> trivia = const []}) {
    return Destination(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      distanceKm: map['distanceKm'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      websiteUrl: map['websiteUrl'] ?? '',
      trivia: trivia,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'distanceKm': distanceKm,
      'description': description,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'websiteUrl': websiteUrl,
    };
  }
}

class TriviaQuestion {
  final String id;
  final String destinationId;
  final String question;
  final List<String> options;
  final int correctIndex;

  TriviaQuestion({
    required this.id,
    required this.destinationId,
    required this.question,
    required this.options,
    required this.correctIndex,
  });

  factory TriviaQuestion.fromMap(Map<String, dynamic> map) {
    return TriviaQuestion(
      id: map['id'],
      destinationId: map['destinationId'],
      question: map['question'],
      options: [map['optionA'], map['optionB'], map['optionC'], map['optionD']],
      correctIndex: map['correctIndex'],
    );
  }
}

class AppUser {
  final String id;
  String name;
  String email;
  String gender;
  int age;
  int totalPoints;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.gender = 'Male',
    this.age = 20,
    this.totalPoints = 0,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      gender: map['gender'] ?? 'Male',
      age: map['age'] ?? 20,
      totalPoints: map['totalPoints'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'gender': gender,
      'age': age,
      'totalPoints': totalPoints,
    };
  }
}

class DestinationData {
  static List<Destination> getSampleDestinations() {
    return [
      Destination(
        id: '1',
        name: 'Curug Cantel',
        address: 'Jl. Raya Tegal, Tegal',
        distanceKm: 5,
        description: 'Tersembunyi di balik lebatnya hutan kaki Gunung Slamet, air terjun ini telah menjadi bagian dari kehidupan masyarakat Tegal selama berabad-abad.\n\n'
            '🏛️ Latar Belakang & Sejarah\n'
            'Air terjun ini pertama kali tercatat dalam naskah kuno abad ke-16 sebagai tempat semedi para tokoh spiritual Tegal. Pada masa kolonial Belanda, kawasan ini dijadikan sumber air bersih untuk perkebunan teh di lereng Slamet dan menjadi titik penting jalur perdagangan antara pesisir utara dan pedalaman.\n\n'
            '🌿 Legenda\n'
            'Konon, air terjun ini ditemukan oleh Ki Ageng Sutawijaya — seorang petapa sakti yang sedang mencari tempat bertapa. Ia dipandu oleh seekor rusa putih yang tiba-tiba menghilang tepat di depan guyuran air. Masyarakat setempat meyakini bahwa rusa putih itu adalah jelmaan penjaga alam yang menyambut kedatangan sang petapa. Hingga kini, air terjun ini dipercaya memiliki energi penyucian jiwa dan kerap menjadi lokasi ritual tolak bala pada malam Satu Suro.',
        imageUrl: 'img/tegal_waterfall.webp',
        latitude: -7.1282,
        longitude: 109.1347,
        websiteUrl: 'https://www.tegaltourism.id/waterfall',
        trivia: [],
      ),
      Destination(
        id: '2',
        name: 'Guci Hot Springs',
        address: 'Jl. Raya Guci, Tegal',
        distanceKm: 25,
        description: 'Berada di lereng barat Gunung Slamet pada ketinggian sekitar 1.050 mdpl, Guci adalah surga air panas alami yang telah memikat wisatawan selama lebih dari satu abad.\n\n'
            '🏛️ Latar Belakang & Sejarah\n'
            'Nama "Guci" berasal dari bahasa Jawa Kuno yang berarti wadah atau tempat penyimpanan — merujuk pada cekungan batu alami tempat air panas berkumpul. Kawasan ini mulai ramai dikunjungi pada masa pemerintahan Hindia Belanda ketika pejabat kolonial menjadikannya tempat peristirahatan resmi. Pada era 1920-an, dibangunlah fasilitas mandi pertama yang kini jejaknya masih bisa dilihat dari struktur batu kuno di area utama.\n\n'
            '🌿 Legenda\n'
            'Legenda setempat menceritakan bahwa sumber air panas Guci berasal dari tangisan Dewi Nawang Wulan, bidadari yang turun ke bumi dan kehilangan selendangnya. Air matanya yang bercampur panas bumi menyembur menjadi sumber-sumber panas yang tersebar di kawasan ini. Dipercaya bahwa mandi di sini pada hari Kamis Wage akan membawa keberuntungan dan menyembuhkan penyakit kulit.',
        imageUrl: 'img/guci_hot_springs.jpg',
        latitude: -7.2142,
        longitude: 109.0891,
        websiteUrl: 'https://www.gucihotsprings.id',
        trivia: [],
      ),
      Destination(
        id: '3',
        name: 'Guci Forest',
        address: 'Jalan Lingkar, Bojong, Tegal',
        distanceKm: 26,
        description: 'Hamparan hutan pinus dan damar yang menyelimuti lereng Gunung Slamet di kawasan Guci ini menawarkan pengalaman alam yang sunyi, segar, dan penuh misteri.\n\n'
            '🏛️ Latar Belakang & Sejarah\n'
            'Hutan Guci merupakan bagian dari kawasan hutan lindung yang dikelola Perum Perhutani sejak zaman penjajahan. Pada masa perjuangan kemerdekaan, hutan ini menjadi persembunyian para pejuang Laskar Hisbullah dari Tegal yang menghindari patroli Belanda. Sebuah batu besar di tengah hutan yang kini dijuluki "Batu Perjuangan" masih berdiri sebagai penanda sejarah.\n\n'
            '🌿 Legenda\n'
            'Warga sekitar meyakini hutan ini dijaga oleh sosok yang disebut "Mbah Slamet Wana" — roh leluhur penjaga gunung yang berwujud kakek tua berambut putih. Siapa pun yang masuk hutan dengan niat buruk, seperti menebang pohon sembarangan atau berburu liar, konon akan tersesat meskipun hanya beberapa langkah dari jalan utama. Para penebang kayu ilegal kerap bersaksi menemukan jejak kaki raksasa di tanah basah setelah malam hari.',
        imageUrl: 'img/guci_forest.jpg',
        latitude: -7.2200,
        longitude: 109.0850,
        websiteUrl: 'https://www.guciforest.id',
        trivia: [],
      ),
      Destination(
        id: '4',
        name: 'Pantai Alam Indah',
        address: 'Pantai Alam Indah, Tegal',
        distanceKm: 5,
        description: 'Membentang di tepi utara Kota Tegal, Pantai Alam Indah (PAI) adalah wajah maritim kota ini — tempat nelayan pulang berlabuh, anak-anak bermain, dan matahari perlahan tenggelam di cakrawala Laut Jawa.\n\n'
            '🏛️ Latar Belakang & Sejarah\n'
            'Pantai ini telah menjadi pusat kehidupan nelayan Tegal sejak abad ke-17 ketika Tegal berkembang sebagai pelabuhan niaga penting di pesisir utara Jawa. Pada masa VOC, kapal-kapal dagang Belanda kerap berlabuh di perairan ini untuk mengangkut hasil bumi dari daerah pedalaman. Kawasan pantai kemudian ditata menjadi ruang publik pada era 1980-an dan kini menjadi ikon wisata kota.\n\n'
            '🌿 Legenda\n'
            'Nelayan tua Tegal menuturkan kisah Nyai Roro Kidul versi lokal yang disebut "Nyi Blorong Segara" — penguasa laut utara yang berwujud wanita cantik berambut panjang. Setiap malam Jumat Kliwon, nelayan dilarang melaut karena dipercaya Nyi Blorong sedang berpatroli. Mereka yang mengabaikan pantangan ini konon tidak akan pernah kembali ke daratan. Sebuah sesaji bunga tujuh rupa masih rutin dilarung ke laut setiap tahun sebagai bentuk rasa syukur dan permohonan keselamatan.',
        imageUrl: 'img/pantai_alam_indah.jpeg',
        latitude: -6.8614,
        longitude: 109.1250,
        websiteUrl: 'https://www.pantaialamindah.id',
        trivia: [],
        isFavorite: true,
      ),
      Destination(
        id: '5',
        name: 'Taman Rakyat Slawi',
        address: 'Slawi, Tegal',
        distanceKm: 15,
        description: 'Terletak di jantung Kota Slawi, ibu kota Kabupaten Tegal, taman ini adalah paru-paru kota sekaligus saksi bisu perjalanan panjang masyarakat Slawi dari masa ke masa.\n\n'
            '🏛️ Latar Belakang & Sejarah\n'
            'Kawasan ini dahulu merupakan alun-alun yang dibangun pada era pemerintahan Bupati Tegal pertama di abad ke-18. Fungsi alun-alun sebagai pusat kegiatan sosial, politik, dan budaya masyarakat bertahan hingga ratusan tahun. Pada masa kemerdekaan, lapangan ini menjadi tempat pembacaan proklamasi oleh pejuang lokal dan pengibaran bendera merah putih pertama di Tegal. Kini taman ini direvitalisasi dengan taman bermain, jogging track, dan panggung hiburan.\n\n'
            '🌿 Legenda\n'
            'Pohon beringin tua di sudut taman dipercaya sebagai tempat bersemayamnya roh Ki Gede Sebayu — tokoh pembabat pertama Kota Tegal. Warga tidak berani menebang pohon ini meski telah berusia ratusan tahun. Konon, setiap kali ada rencana pembangunan yang akan mengorbankan pohon tersebut, selalu terjadi halangan tak terduga hingga akhirnya rencana itu dibatalkan.',
        imageUrl: 'img/taman_rakyat_slawi.jpeg',
        latitude: -6.9987,
        longitude: 109.1400,
        websiteUrl: 'https://www.tamanrakyatslawi.id',
        trivia: [],
        isFavorite: true,
      ),
      Destination(
        id: '6',
        name: 'Waduk Cacaban',
        address: 'Cacaban, Tegal',
        distanceKm: 20,
        description: 'Dikelilingi bukit-bukit hijau dan hutan tropis, Waduk Cacaban adalah bendungan tua yang menyimpan kisah pengorbanan sebuah desa demi kemakmuran ribuan hektar sawah di Tegal.\n\n'
            '🏛️ Latar Belakang & Sejarah\n'
            'Waduk Cacaban dibangun antara tahun 1952–1958 sebagai proyek irigasi besar pertama setelah kemerdekaan Indonesia di Jawa Tengah. Pembangunannya menenggelamkan Desa Cacaban Lama beserta seluruh sawah, kebun, dan rumah penduduknya. Ribuan warga terpaksa dipindahkan ke desa-desa baru di sekitar area genangan. Waduk ini kemudian menjadi tulang punggung irigasi yang mengairi lebih dari 24.000 hektar lahan pertanian di Kabupaten Tegal.\n\n'
            '🌿 Legenda\n'
            'Di kalangan warga, beredar kepercayaan bahwa di kedalaman waduk masih berdiri "Desa Gaib Cacaban" — desa yang tenggelam namun tidak musnah, hanya berpindah dimensi. Pada malam-malam tertentu, nelayan yang melempar jala mengaku mendengar suara azan dan kokok ayam dari bawah permukaan air. Ada pula yang mengaku melihat cahaya kekuningan bergerak di dasar waduk saat bulan purnama. Para leluhur yang tinggal di desa tersebut dipercaya masih menjaga kesuburan tanah di sekitar waduk hingga kini.',
        imageUrl: 'img/waduk_cacaban.jpg',
        latitude: -7.0500,
        longitude: 109.2200,
        websiteUrl: 'https://www.wadukcacaban.id',
        trivia: [],
        isFavorite: true,
      ),
    ];
  }
}
