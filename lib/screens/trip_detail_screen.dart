import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/itinerary.dart';
import '../models/trip.dart';
import '../utils/app_colors.dart';
import '../utils/formatters.dart';
import 'itinerary_form_screen.dart';

class TripDetailScreen extends StatefulWidget {
  final Trip trip;

  const TripDetailScreen({super.key, required this.trip});

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  List<Itinerary> _itemsHari(DateTime tanggal) {
    final items = dummyItinerary
        .where((it) => it.tripId == widget.trip.id && _isSameDay(it.tanggal, tanggal))
        .toList();
    items.sort((a, b) => a.urutan.compareTo(b.urutan));
    return items;
  }

  void _reorderHari(List<Itinerary> items, int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = items.removeAt(oldIndex);
      items.insert(newIndex, item);
      for (int i = 0; i < items.length; i++) {
        items[i].urutan = i + 1;
      }
    });
  }

  Future<void> _tambahJadwal(DateTime tanggal) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ItineraryFormScreen(trip: widget.trip, tanggal: tanggal),
      ),
    );
    setState(() {});
  }

  Future<void> _editJadwal(Itinerary it) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ItineraryFormScreen(trip: widget.trip, tanggal: it.tanggal, itinerary: it),
      ),
    );
    setState(() {});
  }

  void _hapusJadwal(Itinerary it) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus jadwal ini?'),
        content: Text('"${it.kegiatan} - ${it.tujuan}" akan dihapus dari itinerary.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              setState(() {
                final hari = _itemsHari(it.tanggal)..removeWhere((x) => x.id == it.id);
                dummyItinerary.removeWhere((x) => x.id == it.id);
                for (int i = 0; i < hari.length; i++) {
                  hari[i].urutan = i + 1;
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Ya, Hapus', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }

  Future<void> _tandaiSelesai() async {
    final controller = TextEditingController();

    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tandai trip selesai'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Trip ini akan langsung ditandai selesai walau jadwalnya belum habis. Kasih alasannya ya (opsional).',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'contoh: Cuaca buruk, jadi pulang lebih awal',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Tandai Selesai',
                style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (konfirmasi == true) {
      setState(() {
        widget.trip.selesaiManual = true;
        final alasan = controller.text.trim();
        widget.trip.alasanSelesai = alasan.isEmpty ? null : alasan;
      });
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Trip ditandai selesai')));
      }
    }
  }

  void _batalkanTandaiSelesai() {
    setState(() {
      widget.trip.selesaiManual = false;
      widget.trip.alasanSelesai = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Status dikembalikan ke otomatis')));
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Trip')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _DetailField(label: 'Nama Trip', value: trip.nama),
          _DetailField(label: 'Daerah', value: trip.daerah),
          _DetailField(label: 'Berangkat', value: formatDate(trip.berangkat)),
          _DetailField(label: 'Pulang', value: formatDate(trip.pulang)),
          _DetailField(label: 'Durasi', value: trip.durasiLabel),
          _DetailField(label: 'Status', value: _statusLabel(trip.status)),
          if (trip.selesaiManual && trip.selesaiLebihAwal)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.danger.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, size: 16, color: AppColors.danger),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Trip ini dihentikan lebih awal dari jadwal aslinya.\n'
                      '${trip.alasanSelesai == null || trip.alasanSelesai!.isEmpty ? 'Tidak ada alasan dicantumkan.' : 'Alasan: ${trip.alasanSelesai}'}',
                      style: const TextStyle(
                          fontSize: 12.5, color: AppColors.danger, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 10),
          const Text('Deskripsi',
              style: TextStyle(
                  color: AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 12.5)),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(trip.deskripsi.isEmpty ? '-' : trip.deskripsi,
                style: const TextStyle(fontSize: 13, height: 1.5)),
          ),
          const SizedBox(height: 22),
          if (trip.ruteDestinasi.isNotEmpty) ...[
            const Text('Rute Perjalanan',
                style: TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.5)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  for (int i = 0; i < trip.ruteDestinasi.length; i++)
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: i == trip.ruteDestinasi.length - 1 ? 0 : 10),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 11,
                            backgroundColor: AppColors.primary.withOpacity(0.14),
                            child: Text('${i + 1}',
                                style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryDark)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Text(trip.ruteDestinasi[i],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 13.5))),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 22),
          ],
          const Text('Itinerary',
              style: TextStyle(
                  color: AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 12.5)),
          const SizedBox(height: 10),
          for (int i = 0; i < trip.tanggalPerHari.length; i++)
            _HariSection(
              nomorHari: i + 1,
              tanggal: trip.tanggalPerHari[i],
              items: _itemsHari(trip.tanggalPerHari[i]),
              onReorder: (oldIndex, newIndex) =>
                  _reorderHari(_itemsHari(trip.tanggalPerHari[i]), oldIndex, newIndex),
              onTambah: () => _tambahJadwal(trip.tanggalPerHari[i]),
              onEdit: _editJadwal,
              onHapus: _hapusJadwal,
            ),
          const SizedBox(height: 12),
          Text('Anggota ikut (${dummyAnggota.length})',
              style: const TextStyle(
                  color: AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 12.5)),
          const SizedBox(height: 10),
          ...dummyAnggota.asMap().entries.map((entry) {
            final i = entry.key;
            final m = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: avatarColors[i % avatarColors.length],
                    child: Text(initials(m.nama),
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                  const SizedBox(width: 13),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.nama,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5)),
                      Text('NIM ${m.nim}',
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 24),
          if (!trip.selesaiManual)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _tandaiSelesai,
                icon: const Icon(Icons.flag_outlined, size: 18),
                label: const Text('Tandai Trip Selesai'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.danger,
                  side: const BorderSide(color: AppColors.danger),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            )
          else
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _batalkanTandaiSelesai,
                icon: const Icon(Icons.undo, size: 18),
                label: const Text('Batalkan, Kembali ke Status Otomatis'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

String _statusLabel(String status) {
  switch (status) {
    case 'akan_datang':
      return 'Akan Datang';
    case 'aktif':
      return 'Aktif';
    default:
      return 'Selesai';
  }
}

class _HariSection extends StatelessWidget {
  final int nomorHari;
  final DateTime tanggal;
  final List<Itinerary> items;
  final void Function(int oldIndex, int newIndex) onReorder;
  final VoidCallback onTambah;
  final void Function(Itinerary it) onEdit;
  final void Function(Itinerary it) onHapus;

  const _HariSection({
    required this.nomorHari,
    required this.tanggal,
    required this.items,
    required this.onReorder,
    required this.onTambah,
    required this.onEdit,
    required this.onHapus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
            child: Row(
              children: [
                Text('Hari $nomorHari',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(width: 8),
                Text('· ${formatDate(tanggal)}',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: Text('Belum ada jadwal di hari ini',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
            )
          else
            ReorderableListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              buildDefaultDragHandles: false,
              onReorder: onReorder,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 4),
              children: [
                for (int i = 0; i < items.length; i++)
                  Container(
                    key: ValueKey(items[i].id),
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.surface2,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        ReorderableDragStartListener(
                          index: i,
                          child: const Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(Icons.drag_indicator,
                                size: 18, color: AppColors.textSecondary),
                          ),
                        ),
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: AppColors.primary.withOpacity(0.14),
                          child: Text('${items[i].urutan}',
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryDark)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${items[i].waktu} · ${items[i].tujuan}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 13)),
                              Text(items[i].kegiatan,
                                  style: const TextStyle(
                                      color: AppColors.textSecondary, fontSize: 12)),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => onEdit(items[i]),
                          icon: const Icon(Icons.edit_outlined,
                              size: 18, color: AppColors.primary),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          onPressed: () => onHapus(items[i]),
                          icon: const Icon(Icons.delete_outline,
                              size: 18, color: AppColors.danger),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onTambah,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Tambah Jadwal', style: TextStyle(fontSize: 12.5)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailField extends StatelessWidget {
  final String label;
  final String value;

  const _DetailField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontWeight: FontWeight.w600, fontSize: 12.5)),
          Flexible(
              child: Text(value,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5))),
        ],
      ),
    );
  }
}
