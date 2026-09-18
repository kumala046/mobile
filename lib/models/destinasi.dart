class Destinasi {
  final int id;
  final String nama;
  final String kota; // 'Jogja' atau 'Bali'
  final String kategori;
  final String hargaTiket;
  final String deskripsi;
  final String gambar; // path asset foto

  Destinasi({
    required this.id,
    required this.nama,
    required this.kota,
    required this.kategori,
    required this.hargaTiket,
    required this.deskripsi,
    required this.gambar,
  });
}
