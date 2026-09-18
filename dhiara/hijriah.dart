import 'package:flutter/material.dart';

class HijriahPage extends StatefulWidget {
  const HijriahPage({super.key});

  @override
  State<HijriahPage> createState() => _HijriahPageState();
}

class _HijriahPageState extends State<HijriahPage> {
  DateTime? tanggalMasehi;

  String tanggalHijriah = '';

  final List<String> namaBulan = [
    'Muharram',
    'Safar',
    'Rabiul Awal',
    'Rabiul Akhir',
    'Jumadil Awal',
    'Jumadil Akhir',
    'Rajab',
    'Syakban',
    'Ramadan',
    'Syawal',
    'Zulkaidah',
    'Zulhijah',
  ];

  // Awal bulan Hijriah berdasarkan Kalender Hijriah Indonesia 2026
  final Map<String, DateTime> awalBulan2026 = {
    'Muharram 1448': DateTime(2025, 6, 26),
    'Safar 1448': DateTime(2025, 7, 25),
    'Rabiul Awal 1448': DateTime(2025, 8, 24),
    'Rabiul Akhir 1448': DateTime(2025, 9, 13),
    'Jumadil Awal 1448': DateTime(2025, 10, 13),
    'Jumadil Akhir 1448': DateTime(2025, 11, 12),
    'Rajab 1448': DateTime(2025, 12, 12),
    'Syakban 1448': DateTime(2026, 1, 11),
    'Ramadan 1447': DateTime(2025, 3, 1),
    'Syawal 1447': DateTime(2025, 3, 30),
    'Zulkaidah 1447': DateTime(2025, 4, 29),
    'Zulhijah 1447': DateTime(2025, 5, 28),
  };

  Future<void> pilihTanggal() async {
    DateTime? tanggal = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2026, 1, 1),
      lastDate: DateTime(2026, 12, 31),
    );

    if (tanggal != null) {
      konversiHijriah(tanggal);
    }
  }

  void konversiHijriah(DateTime tanggal) {
    DateTime awalRabiulAkhir = DateTime(2026, 9, 13);

    if (!tanggal.isBefore(awalRabiulAkhir) &&
        tanggal.isBefore(DateTime(2026, 10, 13))) {
      int hari = tanggal.difference(awalRabiulAkhir).inDays + 1;

      setState(() {
        tanggalMasehi = tanggal;
        tanggalHijriah = '$hari Rabiul Akhir 1448 H';
      });

      return;
    }

    setState(() {
      tanggalMasehi = tanggal;
      tanggalHijriah =
          'Data kalender Indonesia untuk tanggal ini belum tersedia';
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
          'Konversi Hijriah',
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
                'Konversi Kalender Hijriah',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172B4D),
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Mengikuti Kalender Hijriah Indonesia 2026',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),

              const SizedBox(height: 25),

              const Text(
                'Tanggal Masehi',
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
                    tanggalMasehi == null
                        ? 'Pilih tanggal'
                        : formatTanggal(tanggalMasehi!),
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

              if (tanggalMasehi != null)
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
                        'Hasil Konversi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF172B4D),
                        ),
                      ),

                      const SizedBox(height: 15),

                      const Text(
                        'Tanggal Hijriah',
                        style: TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        tanggalHijriah,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
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
