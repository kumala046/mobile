import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/destinasi.dart';
import '../models/trip.dart';
import '../utils/app_colors.dart';

class TripFormScreen extends StatefulWidget {
  final Trip? trip;

  const TripFormScreen({super.key, this.trip});

  @override
  State<TripFormScreen> createState() => _TripFormScreenState();
}

class _TripFormScreenState extends State<TripFormScreen> {
  final _namaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _alasanSelesaiController = TextEditingController();
  String _daerah = 'Jogja';
  DateTime? _berangkat;
  DateTime? _pulang;
  List<String> _rute = [];
  bool _selesaiManual = false;

  bool get isEdit => widget.trip != null;

  List<Destinasi> get _daftarDestinasi =>
      dummyDestinasi.where((d) => d.kota == _daerah).toList();

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      final t = widget.trip!;
      _namaController.text = t.nama;
      _deskripsiController.text = t.deskripsi;
      _daerah = t.daerah;
      _berangkat = t.berangkat;
      _pulang = t.pulang;
      _rute = [...t.ruteDestinasi];
      _selesaiManual = t.selesaiManual;
      _alasanSelesaiController.text = t.alasanSelesai ?? '';
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _alasanSelesaiController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isBerangkat}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isBerangkat ? (_berangkat ?? now) : (_pulang ?? _berangkat ?? now),
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
    );
    if (picked != null) {
      setState(() {
        if (isBerangkat) {
          _berangkat = picked;
          if (_pulang != null && _pulang!.isBefore(picked)) {
            _pulang = picked;
          }
        } else {
          _pulang = picked;
        }
      });
    }
  }

  void _toggleDestinasi(String nama, bool selected) {
    setState(() {
      if (selected) {
        if (!_rute.contains(nama)) _rute.add(nama);
      } else {
        _rute.remove(nama);
      }
    });
  }

  void _reorderRute(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = _rute.removeAt(oldIndex);
      _rute.insert(newIndex, item);
    });
  }

  void _save() {
    final nama = _namaController.text.trim();

    if (nama.isEmpty || _berangkat == null || _pulang == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Lengkapi dulu semua data wajib ya')));
      return;
    }

    if (_pulang!.isBefore(_berangkat!)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tanggal pulang tidak boleh sebelum tanggal berangkat')));
      return;
    }

    final alasan = _alasanSelesaiController.text.trim();

    if (isEdit) {
      final t = widget.trip!;
      t.nama = nama;
      t.daerah = _daerah;
      t.deskripsi = _deskripsiController.text.trim();
      t.berangkat = _berangkat!;
      t.pulang = _pulang!;
      t.ruteDestinasi = _rute;
      t.selesaiManual = _selesaiManual;
      t.alasanSelesai = _selesaiManual && alasan.isNotEmpty ? alasan : null;
    } else {
      final newId = dummyTrips.isEmpty
          ? 1
          : dummyTrips.map((t) => t.id).reduce((a, b) => a > b ? a : b) + 1;
      dummyTrips.add(Trip(
        id: newId,
        nama: nama,
        daerah: _daerah,
        berangkat: _berangkat!,
        pulang: _pulang!,
        deskripsi: _deskripsiController.text.trim(),
        ruteDestinasi: _rute,
      ));
    }

    Navigator.pop(context);
  }

  String _fmt(DateTime? d) {
    if (d == null) return 'Pilih tanggal';
    return '${d.day}/${d.month}/${d.year}';
  }

  String? get _durasiPreview {
    if (_berangkat == null || _pulang == null) return null;
    if (_pulang!.isBefore(_berangkat!)) return null;
    final hari = _pulang!.difference(_berangkat!).inDays + 1;
    final malam = hari > 1 ? hari - 1 : 0;
    return '$hari hari $malam malam';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Trip' : 'Tambah Trip')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const _Label('Nama Trip'),
          TextField(
              controller: _namaController,
              decoration: _decoration('contoh: Liburan Akhir Semester')),
          const SizedBox(height: 16),
          const _Label('Pilih Daerah'),
          Row(
            children: [
              Expanded(
                child: _DaerahOption(
                  label: 'Yogyakarta',
                  value: 'Jogja',
                  selected: _daerah,
                  onTap: (v) => setState(() {
                    _daerah = v;
                    final validNames =
                        dummyDestinasi.where((d) => d.kota == v).map((d) => d.nama).toSet();
                    _rute.removeWhere((n) => !validNames.contains(n));
                  }),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _DaerahOption(
                  label: 'Bali',
                  value: 'Bali',
                  selected: _daerah,
                  onTap: (v) => setState(() {
                    _daerah = v;
                    final validNames =
                        dummyDestinasi.where((d) => d.kota == v).map((d) => d.nama).toSet();
                    _rute.removeWhere((n) => !validNames.contains(n));
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Label('Tanggal Berangkat'),
                    OutlinedButton(
                      onPressed: () => _pickDate(isBerangkat: true),
                      child: Text(_fmt(_berangkat)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Label('Tanggal Pulang'),
                    OutlinedButton(
                      onPressed: () => _pickDate(isBerangkat: false),
                      child: Text(_fmt(_pulang)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_durasiPreview != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.event_available, size: 16, color: AppColors.primaryDark),
                  const SizedBox(width: 8),
                  Text('Durasi perjalanan: $_durasiPreview',
                      style: const TextStyle(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.5)),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          const _Label('Deskripsi'),
          TextField(
            controller: _deskripsiController,
            maxLines: 4,
            decoration: _decoration('Catatan singkat tentang trip ini...'),
          ),
          const SizedBox(height: 20),
          const _Label('Pilih Destinasi & Urutan Kunjungan'),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Centang tempat yang mau dikunjungi, lalu geser (drag) untuk atur urutan rutenya.',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 11.5),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: _daftarDestinasi.map((d) {
                final checked = _rute.contains(d.nama);
                return CheckboxListTile(
                  value: checked,
                  onChanged: (v) => _toggleDestinasi(d.nama, v ?? false),
                  activeColor: AppColors.primary,
                  dense: true,
                  title: Text(d.nama, style: const TextStyle(fontSize: 13.5)),
                  subtitle: Text(d.kategori,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 11.5)),
                  controlAffinity: ListTileControlAffinity.leading,
                );
              }).toList(),
            ),
          ),
          if (_rute.isNotEmpty) ...[
            const SizedBox(height: 14),
            const _Label('Urutan Rute'),
            ReorderableListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              onReorder: _reorderRute,
              children: [
                for (int i = 0; i < _rute.length; i++)
                  Container(
                    key: ValueKey(_rute[i]),
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface2,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.drag_indicator,
                            size: 18, color: AppColors.textSecondary),
                        const SizedBox(width: 8),
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
                            child: Text(_rute[i],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13))),
                        IconButton(
                          onPressed: () => _toggleDestinasi(_rute[i], false),
                          icon: const Icon(Icons.close, size: 17, color: AppColors.danger),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
          if (isEdit) ...[
            const SizedBox(height: 20),
            const _Label('Status Penyelesaian'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    value: _selesaiManual,
                    activeColor: AppColors.danger,
                    onChanged: (v) => setState(() => _selesaiManual = v),
                    title: const Text('Tandai trip ini selesai secara manual',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    subtitle: const Text(
                        'Aktifkan kalau trip berhenti/selesai lebih cepat dari jadwal',
                        style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                  ),
                  if (_selesaiManual)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
                      child: TextField(
                        controller: _alasanSelesaiController,
                        maxLines: 3,
                        decoration:
                            _decoration('Alasan selesai lebih cepat (opsional)'),
                      ),
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Simpan',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5)),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.surface2,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary)),
    );
  }
}

class _DaerahOption extends StatelessWidget {
  final String label;
  final String value;
  final String selected;
  final ValueChanged<String> onTap;

  const _DaerahOption(
      {required this.label, required this.value, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool active = selected == value;
    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.primary.withOpacity(0.1) : AppColors.surface,
          border: Border.all(color: active ? AppColors.primary : AppColors.border),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? AppColors.primaryDark : AppColors.textSecondary,
            fontWeight: FontWeight.bold,
            fontSize: 13.5,
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text,
          style: const TextStyle(
              color: AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 12.5)),
    );
  }
}
