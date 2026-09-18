import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/destinasi.dart';
import '../utils/app_colors.dart';
import 'destinasi_detail_screen.dart';

class DestinasiListScreen extends StatefulWidget {
  const DestinasiListScreen({super.key});

  @override
  State<DestinasiListScreen> createState() => _DestinasiListScreenState();
}

class _DestinasiListScreenState extends State<DestinasiListScreen> {
  String filter = 'Jogja';

  List<Destinasi> get filteredDestinasi =>
      dummyDestinasi.where((d) => d.kota == filter).toList();

  static const Map<String, IconData> _kategoriIcon = {
    'Budaya': Icons.account_balance,
    'Kuliner': Icons.restaurant,
    'Alam': Icons.terrain,
    'Pantai': Icons.beach_access,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Destinasi Wisata')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                _FilterPill(
                    label: 'Jogja',
                    value: 'Jogja',
                    current: filter,
                    onTap: (v) => setState(() => filter = v)),
                const SizedBox(width: 8),
                _FilterPill(
                    label: 'Bali',
                    value: 'Bali',
                    current: filter,
                    onTap: (v) => setState(() => filter = v)),
              ],
            ),
          ),
          Expanded(
            child: filteredDestinasi.isEmpty
                ? const Center(child: Text('Belum ada destinasi di kota ini'))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    itemCount: filteredDestinasi.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final d = filteredDestinasi[index];
                      return InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => DestinasiDetailScreen(destinasi: d)),
                          );
                        },
                        child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.asset(
                                d.gambar,
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  // Fallback kalau foto belum di-download/dipasang
                                  return Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(
                                      _kategoriIcon[d.kategori] ?? Icons.place,
                                      color: AppColors.primary,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 13),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(d.nama,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 14.5)),
                                  const SizedBox(height: 2),
                                  Text(
                                    d.kategori,
                                    style: const TextStyle(
                                        color: AppColors.textSecondary, fontSize: 12),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    d.hargaTiket,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: AppColors.primaryDark),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final String value;
  final String current;
  final ValueChanged<String> onTap;

  const _FilterPill(
      {required this.label, required this.value, required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool active = current == value;
    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.primary.withOpacity(0.1) : AppColors.surface,
          border: Border.all(color: active ? AppColors.primary : AppColors.border),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? AppColors.primaryDark : AppColors.textSecondary,
            fontWeight: FontWeight.bold,
            fontSize: 12.5,
          ),
        ),
      ),
    );
  }
}
