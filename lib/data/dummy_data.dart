import '../models/anggota.dart';
import '../models/trip.dart';
import '../models/destinasi.dart';
import '../models/itinerary.dart';

List<Anggota> dummyAnggota = [
  Anggota(id: 1, nama: 'Aulia', nim: '12345678', tanggalLahir: '12 Mei 2005'),
  Anggota(id: 2, nama: 'Bima', nim: '12345679', tanggalLahir: '3 Agustus 2004'),
  Anggota(id: 3, nama: 'Citra', nim: '12345680', tanggalLahir: '27 Januari 2005'),
];

List<Trip> dummyTrips = [
  Trip(
    id: 1,
    nama: 'Liburan Akhir Semester',
    daerah: 'Jogja',
    berangkat: DateTime(2026, 10, 20),
    pulang: DateTime(2026, 10, 22),
    deskripsi:
        'Jelajah budaya dan kuliner Jogja bareng anggota kelompok selama 3 hari.',
    ruteDestinasi: ['Malioboro', 'Keraton Yogyakarta', 'Taman Sari'],
  ),
];

List<Itinerary> dummyItinerary = [
  Itinerary(
    id: 1,
    tripId: 1,
    tanggal: DateTime(2026, 10, 20),
    urutan: 1,
    waktu: '07:00',
    tujuan: 'Kampus',
    kegiatan: 'Keberangkatan',
  ),
  Itinerary(
    id: 2,
    tripId: 1,
    tanggal: DateTime(2026, 10, 20),
    urutan: 2,
    waktu: '10:00',
    tujuan: 'Malioboro',
    kegiatan: 'Jalan-jalan',
  ),
  Itinerary(
    id: 3,
    tripId: 1,
    tanggal: DateTime(2026, 10, 20),
    urutan: 3,
    waktu: '13:00',
    tujuan: 'Keraton Yogyakarta',
    kegiatan: 'Wisata',
  ),
  Itinerary(
    id: 4,
    tripId: 1,
    tanggal: DateTime(2026, 10, 20),
    urutan: 4,
    waktu: '16:00',
    tujuan: 'Taman Sari',
    kegiatan: 'Wisata',
  ),
  Itinerary(
    id: 5,
    tripId: 1,
    tanggal: DateTime(2026, 10, 20),
    urutan: 5,
    waktu: '19:00',
    tujuan: 'Malioboro',
    kegiatan: 'Makan malam',
  ),
];

// 10 destinasi Yogyakarta + 10 destinasi Bali, sesuai studi kasus.
List<Destinasi> dummyDestinasi = [
  // ================= YOGYAKARTA =================
  Destinasi(
    id: 1,
    nama: 'Malioboro',
    kota: 'Jogja',
    kategori: 'Kuliner',
    hargaTiket: 'Gratis (bayar parkir jika bawa kendaraan)',
    deskripsi:
        'Jalan legendaris di jantung Jogja, ramai dengan pedagang kaki lima, oleh-oleh khas, dan kuliner malam seperti angkringan. Cocok buat jalan santai sore hingga malam sambil belanja batik dan cinderamata.',
    gambar: 'assets/images/malioboro.jpg',
  ),
  Destinasi(
    id: 2,
    nama: 'Keraton Yogyakarta',
    kota: 'Jogja',
    kategori: 'Budaya',
    hargaTiket: 'Rp15.000',
    deskripsi:
        'Istana resmi Kesultanan Yogyakarta yang masih berfungsi hingga sekarang. Pengunjung bisa melihat koleksi kerajaan, arsitektur Jawa klasik, dan kadang pertunjukan gamelan atau tari tradisional.',
    gambar: 'assets/images/keraton.jpg',
  ),
  Destinasi(
    id: 3,
    nama: 'Taman Sari',
    kota: 'Jogja',
    kategori: 'Budaya',
    hargaTiket: 'Rp15.000',
    deskripsi:
        'Bekas taman air kerajaan peninggalan Keraton Yogyakarta dengan arsitektur kolam dan lorong bawah tanah yang unik. Spot foto favorit karena nuansa klasiknya yang kental.',
    gambar: 'assets/images/taman_sari.jpg',
  ),
  Destinasi(
    id: 4,
    nama: 'Candi Prambanan',
    kota: 'Jogja',
    kategori: 'Budaya',
    hargaTiket: 'Rp50.000 (Hari Biasa) / Rp65.000 (Akhir Pekan)',
    deskripsi:
        'Kompleks candi Hindu terbesar di Indonesia dan situs warisan dunia UNESCO. Candi utama menjulang setinggi 47 meter dengan relief cerita Ramayana di dindingnya, paling indah dilihat saat matahari terbenam.',
    gambar: 'assets/images/prambanan.jpg',
  ),
  Destinasi(
    id: 5,
    nama: 'HeHa Sky View',
    kota: 'Jogja',
    kategori: 'Alam',
    hargaTiket: 'Rp30.000 (Hari Biasa) / Rp40.000 (Akhir Pekan)',
    deskripsi:
        'Kafe dan taman rekreasi di ketinggian bukit dengan pemandangan Kota Jogja dan Gunung Merapi. Banyak spot foto instagramable, cocok dikunjungi sore hari sambil menikmati sunset.',
    gambar: 'assets/images/heha_sky_view.jpg',
  ),
  Destinasi(
    id: 6,
    nama: 'Pantai Parangtritis',
    kota: 'Jogja',
    kategori: 'Pantai',
    hargaTiket: 'Rp10.000',
    deskripsi:
        'Pantai berpasir landai dengan ombak besar khas Laut Selatan dan gumuk pasir di sekitarnya. Populer buat naik andong atau ATV menyusuri pantai sambil menikmati sunset.',
    gambar: 'assets/images/parangtritis.jpg',
  ),
  Destinasi(
    id: 7,
    nama: 'Tebing Breksi',
    kota: 'Jogja',
    kategori: 'Alam',
    hargaTiket: 'Rp10.000 (Hari Biasa) / Rp15.000 (Akhir Pekan)',
    deskripsi:
        'Bekas tambang batu kapur yang disulap jadi destinasi wisata dengan ukiran relief raksasa di tebingnya. Spot favorit buat menikmati sunset dan pemandangan Jogja dari ketinggian.',
    gambar: 'assets/images/tebing_breksi.jpg',
  ),
  Destinasi(
    id: 8,
    nama: 'Hutan Pinus Mangunan',
    kota: 'Jogja',
    kategori: 'Alam',
    hargaTiket: 'Rp5.000',
    deskripsi:
        'Kawasan hutan pinus asri dengan udara sejuk di perbukitan Dlingo. Banyak gardu pandang dan spot foto unik di antara pepohonan pinus yang tinggi.',
    gambar: 'assets/images/hutan_pinus_mangunan.jpg',
  ),
  Destinasi(
    id: 9,
    nama: 'Alun-Alun Kidul',
    kota: 'Jogja',
    kategori: 'Budaya',
    hargaTiket: 'Gratis',
    deskripsi:
        'Alun-alun selatan Keraton yang ramai di malam hari dengan sepeda hias berlampu dan permainan tradisional masangin. Tempat nongkrong santai sambil menikmati suasana Jogja malam hari.',
    gambar: 'assets/images/alun_alun_kidul.jpg',
  ),
  Destinasi(
    id: 10,
    nama: 'Museum Benteng Vredeburg',
    kota: 'Jogja',
    kategori: 'Budaya',
    hargaTiket: 'Rp3.000',
    deskripsi:
        'Benteng peninggalan Belanda yang kini jadi museum sejarah perjuangan kemerdekaan Indonesia. Cocok buat wisata edukasi sambil mengenal sejarah lewat diorama dan koleksi bendanya.',
    gambar: 'assets/images/benteng_vredeburg.jpg',
  ),

  // ================= BALI =================
  Destinasi(
    id: 11,
    nama: 'Pantai Kuta',
    kota: 'Bali',
    kategori: 'Pantai',
    hargaTiket: 'Gratis',
    deskripsi:
        'Pantai paling ikonik di Bali dengan pasir putih landai dan ombak yang cocok buat belajar surfing. Ramai wisatawan terutama saat sore untuk menikmati sunset di tepi pantai.',
    gambar: 'assets/images/kuta.jpg',
  ),
  Destinasi(
    id: 12,
    nama: 'Tanah Lot',
    kota: 'Bali',
    kategori: 'Budaya',
    hargaTiket: 'Rp30.000',
    deskripsi:
        'Pura ikonik yang berdiri di atas batu karang di tengah laut, salah satu ikon wisata Bali yang paling terkenal. Waktu terbaik berkunjung saat sore hari untuk melihat siluet pura dengan latar matahari terbenam.',
    gambar: 'assets/images/tanah_lot.jpg',
  ),
  Destinasi(
    id: 13,
    nama: 'Uluwatu',
    kota: 'Bali',
    kategori: 'Budaya',
    hargaTiket: 'Rp40.000',
    deskripsi:
        'Pura yang berdiri megah di atas tebing setinggi 70 meter menghadap Samudra Hindia. Terkenal dengan pertunjukan Tari Kecak saat senja dan kawanan monyet liar yang menghuni area sekitar pura.',
    gambar: 'assets/images/uluwatu.jpg',
  ),
  Destinasi(
    id: 14,
    nama: 'Pantai Pandawa',
    kota: 'Bali',
    kategori: 'Pantai',
    hargaTiket: 'Rp15.000 (termasuk parkir kendaraan)',
    deskripsi:
        'Pantai tersembunyi di balik tebing kapur berukir patung Pandawa di sepanjang jalan masuknya. Air lautnya jernih dan tenang, cocok buat berenang atau sekadar bersantai di pinggir pantai.',
    gambar: 'assets/images/pandawa.jpg',
  ),
  Destinasi(
    id: 15,
    nama: 'Pantai Sanur',
    kota: 'Bali',
    kategori: 'Pantai',
    hargaTiket: 'Gratis',
    deskripsi:
        'Pantai tenang di sisi timur Bali dengan ombak landai, populer untuk lihat sunrise dan bersepeda di sepanjang pesisirnya. Suasananya lebih santai dibanding kawasan Kuta.',
    gambar: 'assets/images/sanur.jpg',
  ),
  Destinasi(
    id: 16,
    nama: 'Ubud',
    kota: 'Bali',
    kategori: 'Budaya',
    hargaTiket: 'Gratis (tiket masuk beda-beda tiap objek di dalamnya)',
    deskripsi:
        'Pusat seni dan budaya Bali dengan galeri lukisan, pasar seni, dan suasana pedesaan yang asri dikelilingi sawah. Cocok buat yang mau menikmati Bali dari sisi budaya dan ketenangannya.',
    gambar: 'assets/images/ubud.jpg',
  ),
  Destinasi(
    id: 17,
    nama: 'Tegallalang',
    kota: 'Bali',
    kategori: 'Alam',
    hargaTiket: 'Rp15.000',
    deskripsi:
        'Terasering sawah hijau berundak yang jadi salah satu pemandangan paling khas dari Bali. Ada juga ayunan raksasa di beberapa titik untuk foto dengan latar sawah.',
    gambar: 'assets/images/tegallalang.jpg',
  ),
  Destinasi(
    id: 18,
    nama: 'Bedugul',
    kota: 'Bali',
    kategori: 'Alam',
    hargaTiket: 'Rp75.000',
    deskripsi:
        'Kawasan pegunungan sejuk dengan Danau Beratan dan Pura Ulun Danu yang jadi ikon wisata di lembaran uang Rp50.000. Udaranya dingin, cocok buat healing jauh dari panasnya pesisir.',
    gambar: 'assets/images/bedugul.jpg',
  ),
  Destinasi(
    id: 19,
    nama: 'Kintamani',
    kota: 'Bali',
    kategori: 'Alam',
    hargaTiket: 'Rp50.000 (retribusi kawasan)',
    deskripsi:
        'Kawasan dataran tinggi dengan pemandangan Gunung dan Danau Batur yang megah. Udara sejuk sepanjang hari, cocok buat sarapan sambil menikmati pemandangan kaldera dari kejauhan.',
    gambar: 'assets/images/kintamani.jpg',
  ),
  Destinasi(
    id: 20,
    nama: 'Tirta Empul',
    kota: 'Bali',
    kategori: 'Budaya',
    hargaTiket: 'Rp50.000',
    deskripsi:
        'Pura mata air suci tempat umat Hindu Bali melakukan ritual penyucian diri (melukat). Wisatawan juga boleh ikut mencoba ritual ini dengan tetap mengenakan pakaian dan sarung yang sopan.',
    gambar: 'assets/images/tirta_empul.jpg',
  ),
];
