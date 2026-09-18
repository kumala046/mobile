import 'package:flutter/material.dart';

class KonversiKalenderPage extends StatefulWidget {
  const KonversiKalenderPage({super.key});

  @override
  State<KonversiKalenderPage> createState() => _KonversiKalenderPageState();
}

class _KonversiKalenderPageState extends State<KonversiKalenderPage> {
  DateTime? tanggalDipilih;

  String weton = '';
  String sakaBali = '';

  Future<void> pilihTanggal() async {
    DateTime? tanggal = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (tanggal != null) {
      konversiTanggal(tanggal);
    }
  }

  void konversiTanggal(DateTime tanggal) {
    // ==========================================
    // WETON
    // ==========================================

    // 1 Januari 2024 = Senin Pahing
    DateTime acuan = DateTime(2024, 1, 1);

    int selisihHari = tanggal.difference(acuan).inDays;

    List<String> pasaran = ['Pahing', 'Pon', 'Wage', 'Kliwon', 'Legi'];

    int indexPasaran = selisihHari % 5;

    if (indexPasaran < 0) {
      indexPasaran += 5;
    }

    List<String> namaHari = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
    ];

    String hari = namaHari[tanggal.weekday % 7];
    String pasaranHari = pasaran[indexPasaran];

    // ==========================================
    // SAKA BALI
    // ==========================================

    int tahunSaka;

    /*
      Tahun Saka berganti saat Nyepi.
      Untuk penggunaan sederhana:
      sebelum Nyepi -> masih tahun Saka sebelumnya
      setelah Nyepi -> tahun Saka baru
    */

    Map<int, DateTime> nyepi = {
      2024: DateTime(2024, 3, 11),
      2025: DateTime(2025, 3, 29),
      2026: DateTime(2026, 3, 19),
      2027: DateTime(2027, 3, 9),
      2028: DateTime(2028, 2, 26),
      2029: DateTime(2029, 3, 16),
      2030: DateTime(2030, 3, 5),
      2031: DateTime(2031, 3, 26),
      2032: DateTime(2032, 3, 15),
      2033: DateTime(2033, 3, 4),
      2034: DateTime(2034, 3, 24),
      2035: DateTime(2035, 3, 13),
      2036: DateTime(2036, 3, 3),
      2037: DateTime(2037, 3, 21),
      2038: DateTime(2038, 3, 11),
      2039: DateTime(2039, 2, 28),
      2040: DateTime(2040, 3, 19),
    };

    DateTime? tanggalNyepi = nyepi[tanggal.year];

    if (tanggalNyepi != null && !tanggal.isBefore(tanggalNyepi)) {
      tahunSaka = tanggal.year - 78;
    } else {
      tahunSaka = tanggal.year - 79;
    }

    setState(() {
      tanggalDipilih = tanggal;

      weton = '$hari $pasaranHari';

      sakaBali = 'Tahun Saka $tahunSaka';
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
          'Kalender Budaya',
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
                'Kalender Budaya',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172B4D),
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Konversi tanggal Masehi ke Weton dan Saka Bali',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),

              const SizedBox(height: 25),

              const Text(
                'Pilih Tanggal',
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
                    tanggalDipilih == null
                        ? 'Pilih tanggal'
                        : formatTanggal(tanggalDipilih!),
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

              if (tanggalDipilih != null)
                Column(
                  children: [
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
                            'Weton',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF172B4D),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            weton,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

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
                            'Saka Bali',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF172B4D),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            sakaBali,
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
            ],
          ),
        ),
      ),
    );
  }
}
