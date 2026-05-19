# Guideline Menegal

Menegal adalah aplikasi panduan wisata berbasis mobile yang dikembangkan khusus untuk wilayah Tegal, Jawa Tengah. Aplikasi ini dirancang menggunakan Flutter untuk memberikan akses informasi destinasi wisata yang cepat, praktis, dan interaktif bagi wisatawan maupun masyarakat lokal.

## Latar Belakang
Wisatawan sering kesulitan mencari informasi lengkap mengenai objek wisata di Tegal karena data yang tersebar di berbagai platform. Menegal hadir untuk merangkum data lokasi, sejarah, dan fasilitas wisata dalam satu platform yang mudah diakses kapan saja melalui ponsel.

## Fitur Utama
* **Halaman Home**: Menampilkan daftar rekomendasi destinasi wisata populer di wilayah Tegal.
* **Halaman Materi**: Berisi deskripsi detail, sejarah, serta galeri foto dari setiap objek wisata.
* **Navigasi Antar Halaman**: Perpindahan menu yang lancar untuk meningkatkan kenyamanan kamu.
* **Fitur Kuis**: Uji pengetahuan kamu tentang Tegal melalui fitur kuis interaktif.
* **Tampilan Responsif**: Antarmuka aplikasi otomatis menyesuaikan berbagai ukuran layar ponsel.

## Deskripsi Fitur Kuis
* Format soal berupa pilihan ganda.
* Penilaian otomatis dihitung berdasarkan jumlah jawaban benar.
* Feedback berupa skor akhir ditampilkan langsung setelah kuis selesai.
* Navigasi soal menggunakan tombol kontrol yang sederhana.

## Teknologi yang Digunakan
* **Framework**: Flutter
* **Bahasa Pemrograman**: Dart
* **API**: Google Maps

## Alur Penggunaan
1. Buka aplikasi Menegal.
2. Pilih destinasi wisata pada halaman utama.
3. Baca informasi lengkap pada halaman materi.
4. Kerjakan kuis pengetahuan wisata.
5. Lihat hasil skor akhir kamu.

## Cara Menjalankan Proyek
Pastikan kamu sudah menginstal Flutter SDK dan Java Development Kit (JDK) 17 di komputer kamu.

1. Salin repositori ini ke komputer kamu.
2. Buka terminal di dalam folder proyek.
3. Jalankan perintah `flutter pub get` untuk mengunduh paket yang diperlukan.
4. Pastikan file `android/app/build.gradle.kts` menggunakan `minSdk = 23`.
5. Jalankan aplikasi dengan perintah `flutter run`.

## Metode Pengembangan
Proyek ini dikembangkan menggunakan metode **Agile**. Pendekatan ini memungkinkan pengembangan dilakukan secara bertahap dan fleksibel terhadap perubahan fitur atau masukan pengguna selama proses pembuatan aplikasi.

## Kelebihan dan Kekurangan
* **Kelebihan**: Aplikasi sangat ringan, cepat, dan tidak membebani memori ponsel.
* **Kekurangan**: Data saat ini terbatas pada wilayah Tegal dan memerlukan koneksi internet untuk fitur peta.

---
**Pengembang**: Januar Atmaja
**Status Proyek**: Pengembangan Aktif

