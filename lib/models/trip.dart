class Trip {
  int id;
  String nama;
  String daerah; 
  DateTime berangkat;
  DateTime pulang;
  String deskripsi;

  
  bool selesaiManual;
  String? alasanSelesai;

  List<String> ruteDestinasi;

  Trip({
    required this.id,
    required this.nama,
    required this.daerah,
    required this.berangkat,
    required this.pulang,
    required this.deskripsi,
    this.selesaiManual = false,
    this.alasanSelesai,
    List<String>? ruteDestinasi,
  }) : ruteDestinasi = ruteDestinasi ?? [];

  
  String get status {
    if (selesaiManual) return 'selesai';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final mulai = DateTime(berangkat.year, berangkat.month, berangkat.day);
    final akhir = DateTime(pulang.year, pulang.month, pulang.day);

    if (today.isBefore(mulai)) return 'akan_datang';
    if (today.isAfter(akhir)) return 'selesai';
    return 'aktif';
  }


  bool get selesaiLebihAwal {
    if (!selesaiManual) return false;
    final now = DateTime.now();
    final akhir = DateTime(pulang.year, pulang.month, pulang.day);
    return DateTime(now.year, now.month, now.day).isBefore(akhir);
  }

  int get jumlahHari => pulang.difference(berangkat).inDays + 1;

  int get jumlahMalam => jumlahHari > 1 ? jumlahHari - 1 : 0;

  String get durasiLabel => '$jumlahHari hari $jumlahMalam malam';

  List<DateTime> get tanggalPerHari {
    final mulai = DateTime(berangkat.year, berangkat.month, berangkat.day);
    return List.generate(jumlahHari, (i) => mulai.add(Duration(days: i)));
  }
}
