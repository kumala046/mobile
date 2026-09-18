import 'package:flutter/material.dart';

class TanggalLahirPage extends StatefulWidget {
  const TanggalLahirPage({super.key});

  @override
  State<TanggalLahirPage> createState() => _TanggalLahirPageState();
}

class _TanggalLahirPageState extends State<TanggalLahirPage> {
  DateTime? tanggalLahir;

  int tahun = 0;
  int bulan = 0;
  int hari = 0;
  int totalHari = 0;
  int totalJam = 0;
  int totalMenit = 0;
  int totalDetik = 0;

  Future<void> pilihTanggal() async {
    DateTime? tanggal = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (tanggal != null) {
      hitungUmur(tanggal);
    }
  }

  void hitungUmur(DateTime tanggal) {
    DateTime sekarang = DateTime.now();

    int umurTahun = sekarang.year - tanggal.year;
    int umurBulan = sekarang.month - tanggal.month;
    int umurHari = sekarang.day - tanggal.day;

    if (umurHari < 0) {
      umurBulan--;
      DateTime bulanSebelumnya = DateTime(sekarang.year, sekarang.month, 0);
      umurHari += bulanSebelumnya.day;
    }

    if (umurBulan < 0) {
      umurTahun--;
      umurBulan += 12;
    }

    int jumlahHari = sekarang.difference(tanggal).inDays;

    setState(() {
      tanggalLahir = tanggal;

      tahun = umurTahun;
      bulan = umurBulan;
      hari = umurHari;

      totalHari = jumlahHari;
      totalJam = jumlahHari * 24;
      totalMenit = totalJam * 60;
      totalDetik = totalMenit * 60;
    });
  }

  String formatTanggal(DateTime tanggal) {
    return '${tanggal.day}/${tanggal.month}/${tanggal.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text(
          'Tanggal Lahir',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Age Calculator',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172B4D),
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Hitung umur berdasarkan tanggal lahir',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),

              const SizedBox(height: 25),

              const Text(
                'Tanggal Lahir',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172B4D),
                ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: pilihTanggal,
                  icon: const Icon(Icons.calendar_month),
                  label: Text(
                    tanggalLahir == null
                        ? 'Pilih tanggal lahir'
                        : formatTanggal(tanggalLahir!),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              if (tanggalLahir != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF3FF),
                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Umur Saat Ini',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF172B4D),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        '$tahun tahun $bulan bulan $hari hari',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),

                      const SizedBox(height: 25),

                      const Text(
                        'Konversi Umur',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF172B4D),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text('Total hari: $totalHari hari'),

                      const SizedBox(height: 8),

                      Text('Total jam: $totalJam jam'),

                      const SizedBox(height: 8),

                      Text('Total menit: $totalMenit menit'),

                      const SizedBox(height: 8),

                      Text('Total detik: $totalDetik detik'),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
