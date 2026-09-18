import 'package:flutter/material.dart';

class KalkulatorPage extends StatefulWidget {
  const KalkulatorPage({super.key});
  @override
  State<KalkulatorPage> createState() => _KalkulatorPageState();
}

class _KalkulatorPageState extends State<KalkulatorPage> {
  final TextEditingController jumlahOrangController = TextEditingController();
  final TextEditingController transportasiController = TextEditingController();
  final TextEditingController penginapanController = TextEditingController();
  final TextEditingController makanController = TextEditingController();

  String totalBiaya = 'Rp0';
  String biayaPerOrang = 'Rp0';

  int ambilAngka(String input) {
    String angka = input.replaceAll(RegExp(r'[^0-9]'), '');
    if (angka.isEmpty) {
      return 0;
    }
    return int.parse(angka);
  }

  void hitungBiaya() {
    int jumlahOrang = ambilAngka(jumlahOrangController.text);
    int transportasi = ambilAngka(transportasiController.text);
    int penginapan = ambilAngka(penginapanController.text);
    int makan = ambilAngka(makanController.text);

    int total = transportasi + penginapan + makan;

    setState(() {
      totalBiaya = 'Rp$total';

      if (jumlahOrang > 0) {
        biayaPerOrang = 'Rp${total ~/ jumlahOrang}';
      } else {
        biayaPerOrang = 'Rp0';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text(
          'Kalkulator',
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
                'Trip Calculator',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172B4D),
                ),
              ),

              const SizedBox(height: 5),
              const Text(
                'Hitung perkiraan biaya perjalananmu',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),

              const SizedBox(height: 25),

              // Jumlah orang
              const Text(
                'Jumlah Orang',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172B4D),
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: jumlahOrangController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Masukkan jumlah orang',
                  prefixIcon: const Icon(Icons.people),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Transportasi
              const Text(
                'Biaya Transportasi',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172B4D),
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: transportasiController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Contoh: 200000',
                  prefixIcon: const Icon(Icons.directions_bus),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Penginapan
              const Text(
                'Biaya Penginapan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172B4D),
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: penginapanController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Contoh: 500000',
                  prefixIcon: const Icon(Icons.hotel),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Makan
              const Text(
                'Biaya Makan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172B4D),
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: makanController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Contoh: 300000',
                  prefixIcon: const Icon(Icons.restaurant),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Tombol hitung
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: hitungBiaya,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'HITUNG',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Hasil
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
                      'Hasil Perhitungan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF172B4D),
                      ),
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      'Total Biaya',
                      style: TextStyle(color: Colors.grey),
                    ),

                    Text(
                      totalBiaya,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      'Biaya Per Orang',
                      style: TextStyle(color: Colors.grey),
                    ),

                    Text(
                      biayaPerOrang,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF172B4D),
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
