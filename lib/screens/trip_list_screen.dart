import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/trip.dart';
import '../utils/app_colors.dart';
import '../utils/formatters.dart';
import 'trip_form_screen.dart';
import 'trip_detail_screen.dart';

class TripListScreen extends StatefulWidget {
  const TripListScreen({super.key});

  @override
  State<TripListScreen> createState() => _TripListScreenState();
}

class _TripListScreenState extends State<TripListScreen> {
  String filter = 'semua';

  // Trip yang belum selesai diurutkan tanggal berangkat paling dekat lebih dulu.
  // Trip yang sudah selesai ditaruh di bagian bawah (bukan ikut campur di atas).
  List<Trip> get _sortedTrips {
    final belumSelesai = dummyTrips.where((t) => t.status != 'selesai').toList()
      ..sort((a, b) => a.berangkat.compareTo(b.berangkat));
    final sudahSelesai = dummyTrips.where((t) => t.status == 'selesai').toList()
      ..sort((a, b) => b.pulang.compareTo(a.pulang)); // yang baru selesai duluan
    return [...belumSelesai, ...sudahSelesai];
  }

  List<Trip> get filteredTrips {
    final sorted = _sortedTrips;
    if (filter == 'semua') return sorted;
    return sorted.where((t) => t.status == filter).toList();
  }

  // Trip yang jadwalnya paling dekat (belum selesai) -> dikasih background beda.
  Trip? get _nearestTrip {
    final upcoming = _sortedTrips.where((t) => t.status != 'selesai');
    return upcoming.isEmpty ? null : upcoming.first;
  }

  int _count(String status) =>
      status == 'semua' ? dummyTrips.length : dummyTrips.where((t) => t.status == status).length;

  Future<void> _openForm({Trip? trip}) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (_) => TripFormScreen(trip: trip)));
    setState(() {});
  }

  void _confirmDelete(Trip trip) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yakin ingin menghapus?'),
        content: Text('"${trip.nama}" akan dihapus permanen dari daftar trip.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              setState(() {
                dummyTrips.removeWhere((t) => t.id == trip.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Trip berhasil dihapus')));
            },
            child: const Text('Ya, Hapus', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nearest = _nearestTrip;

    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Trip')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _openForm(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterPill(
                      label: 'Semua',
                      count: _count('semua'),
                      value: 'semua',
                      current: filter,
                      color: AppColors.primary,
                      onTap: (v) => setState(() => filter = v)),
                  const SizedBox(width: 8),
                  _FilterPill(
                      label: 'Akan Datang',
                      count: _count('akan_datang'),
                      value: 'akan_datang',
                      current: filter,
                      color: AppColors.akanDatang,
                      onTap: (v) => setState(() => filter = v)),
                  const SizedBox(width: 8),
                  _FilterPill(
                      label: 'Aktif',
                      count: _count('aktif'),
                      value: 'aktif',
                      current: filter,
                      color: AppColors.aktif,
                      onTap: (v) => setState(() => filter = v)),
                  const SizedBox(width: 8),
                  _FilterPill(
                      label: 'Selesai',
                      count: _count('selesai'),
                      value: 'selesai',
                      current: filter,
                      color: AppColors.selesai,
                      onTap: (v) => setState(() => filter = v)),
                ],
              ),
            ),
          ),
          Expanded(
            child: filteredTrips.isEmpty
                ? const Center(child: Text('Belum ada trip di kategori ini'))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                    itemCount: filteredTrips.length,
                    itemBuilder: (context, index) {
                      final t = filteredTrips[index];
                      final isNearest = nearest != null && t.id == nearest.id;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isNearest ? AppColors.highlight : AppColors.surface,
                          border: Border.all(
                              color: isNearest ? AppColors.primary : AppColors.border,
                              width: isNearest ? 1.4 : 1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isNearest)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    const Icon(Icons.bolt, size: 14, color: AppColors.primary),
                                    const SizedBox(width: 4),
                                    Text(
                                      t.status == 'aktif' ? 'Sedang berlangsung' : 'Jadwal terdekat',
                                      style: const TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(t.nama,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 15.5)),
                                      const SizedBox(height: 4),
                                      Text(t.daerah,
                                          style: const TextStyle(
                                              color: AppColors.textSecondary,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12.5)),
                                      const SizedBox(height: 2),
                                      Text(formatRange(t.berangkat, t.pulang),
                                          style: const TextStyle(
                                              color: AppColors.textSecondary, fontSize: 12)),
                                    ],
                                  ),
                                ),
                                _StatusBadge(status: t.status),
                              ],
                            ),
                            if (t.selesaiLebihAwal) ...[
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.info_outline,
                                      size: 13, color: AppColors.danger),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      t.alasanSelesai == null || t.alasanSelesai!.isEmpty
                                          ? 'Dihentikan lebih awal dari jadwal'
                                          : 'Dihentikan lebih awal: ${t.alasanSelesai}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 11.5, color: AppColors.danger),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => TripDetailScreen(trip: t)));
                                    },
                                    child: const Text('Detail'),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                        foregroundColor: AppColors.primary,
                                        side: const BorderSide(color: AppColors.primary)),
                                    onPressed: () => _openForm(trip: t),
                                    child: const Text('Edit'),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                        foregroundColor: AppColors.danger,
                                        side: const BorderSide(color: AppColors.danger)),
                                    onPressed: () => _confirmDelete(t),
                                    child: const Text('Hapus'),
                                  ),
                                ),
                              ],
                            ),
                          ],
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

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    late final Color color;
    late final String label;
    switch (status) {
      case 'akan_datang':
        color = AppColors.akanDatang;
        label = 'Akan Datang';
        break;
      case 'aktif':
        color = AppColors.aktif;
        label = 'Aktif';
        break;
      default:
        color = AppColors.selesai;
        label = 'Selesai';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final int count;
  final String value;
  final String current;
  final Color color;
  final ValueChanged<String> onTap;

  const _FilterPill({
    required this.label,
    required this.count,
    required this.value,
    required this.current,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool active = current == value;
    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        decoration: BoxDecoration(
          color: active ? color.withOpacity(0.12) : AppColors.surface,
          border: Border.all(color: active ? color : AppColors.border),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: active ? color : AppColors.textSecondary,
                fontWeight: FontWeight.bold,
                fontSize: 12.5,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: active ? color : AppColors.border,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color: active ? Colors.white : AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
