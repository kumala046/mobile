import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/itinerary.dart';
import '../models/trip.dart';
import '../utils/app_colors.dart';
import '../utils/formatters.dart';

const String _lainnya = '__lainnya__';

class ItineraryFormScreen extends StatefulWidget {
  final Trip trip;
  final DateTime tanggal;
  final Itinerary? itinerary;

  const ItineraryFormScreen({
    super.key,
    required this.trip,
    required this.tanggal,
    this.itinerary,
  });

  @override
  State<ItineraryFormScreen> createState() => _ItineraryFormScreenState();
}

class _ItineraryFormScreenState extends State<ItineraryFormScreen> {
  final _kegiatanController = TextEditingController();
  final _tujuanManualController = TextEditingController();
  TimeOfDay? _waktu;
  String? _tujuanDropdown;

  bool get isEdit => widget.itinerary != null;

  List<String> get _pilihanTujuan =>
      dummyDestinasi.where((d) => d.kota == widget.trip.daerah).map((d) => d.nama).toList();

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      final it = widget.itinerary!;
      _kegiatanController.text = it.kegiatan;
      final parts = it.waktu.split(':');
      if (parts.length == 2) {
        _waktu = TimeOfDay(
            hour: int.tryParse(parts[0]) ?? 0, minute: int.tryParse(parts[1]) ?? 0);
      }
      if (_pilihanTujuan.contains(it.tujuan)) {
        _tujuanDropdown = it.tujuan;
      } else {
        _tujuanDropdown = _lainnya;
        _tujuanManualController.text = it.tujuan;
      }
    }
  }

  @override
  void dispose() {
    _kegiatanController.dispose();
    _tujuanManualController.dispose();
    super.dispose();
  }

  Future<void> _pickWaktu() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _waktu ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _waktu = picked);
  }

  String _fmtWaktu(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  void _save() {
    final kegiatan = _kegiatanController.text.trim();
    final tujuan = _tujuanDropdown == _lainnya
        ? _tujuanManualController.text.trim()
        : (_tujuanDropdown ?? '');

    if (_waktu == null || tujuan.isEmpty || kegiatan.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Lengkapi dulu semua data wajib ya')));
      return;
    }

    if (isEdit) {
      final it = widget.itinerary!;
      it.waktu = _fmtWaktu(_waktu!);
      it.tujuan = tujuan;
      it.kegiatan = kegiatan;
    } else {
      final itemHariIni = dummyItinerary
          .where((it) =>
              it.tripId == widget.trip.id && _isSameDay(it.tanggal, widget.tanggal))
          .toList();
      final urutanBaru = itemHariIni.isEmpty
          ? 1
          : itemHariIni.map((it) => it.urutan).reduce((a, b) => a > b ? a : b) + 1;
      final newId = dummyItinerary.isEmpty
          ? 1
          : dummyItinerary.map((it) => it.id).reduce((a, b) => a > b ? a : b) + 1;

      dummyItinerary.add(Itinerary(
        id: newId,
        tripId: widget.trip.id,
        tanggal: widget.tanggal,
        urutan: urutanBaru,
        waktu: _fmtWaktu(_waktu!),
        tujuan: tujuan,
        kegiatan: kegiatan,
      ));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Jadwal' : 'Tambah Jadwal')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 15, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(formatDate(widget.tanggal),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const _Label('Waktu'),
          OutlinedButton(
            onPressed: _pickWaktu,
            child: Text(_waktu == null ? 'Pilih waktu' : _fmtWaktu(_waktu!)),
          ),
          const SizedBox(height: 16),
          const _Label('Tujuan / Tempat'),
          DropdownButtonFormField<String>(
            value: _tujuanDropdown,
            decoration: _decoration('Pilih tempat'),
            items: [
              ..._pilihanTujuan.map((n) => DropdownMenuItem(value: n, child: Text(n))),
              const DropdownMenuItem(value: _lainnya, child: Text('Lainnya (isi manual)')),
            ],
            onChanged: (v) => setState(() => _tujuanDropdown = v),
          ),
          if (_tujuanDropdown == _lainnya) ...[
            const SizedBox(height: 10),
            TextField(
              controller: _tujuanManualController,
              decoration: _decoration('contoh: Kampus, Hotel, Bandara'),
            ),
          ],
          const SizedBox(height: 16),
          const _Label('Kegiatan'),
          TextField(
            controller: _kegiatanController,
            decoration: _decoration('contoh: Jalan-jalan, Wisata, Makan malam'),
          ),
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
      fillColor: AppColors.surface,
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

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

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
