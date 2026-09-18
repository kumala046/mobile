class Itinerary {
  int id;
  int tripId;
  DateTime tanggal;
  int urutan;
  String waktu; // format "HH:mm"
  String tujuan;
  String kegiatan;

  Itinerary({
    required this.id,
    required this.tripId,
    required this.tanggal,
    required this.urutan,
    required this.waktu,
    required this.tujuan,
    required this.kegiatan,
  });
}
