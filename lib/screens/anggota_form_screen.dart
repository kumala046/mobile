import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/anggota.dart';
import '../utils/app_colors.dart';

class AnggotaFormScreen extends StatefulWidget {
  final Anggota? anggota;

  const AnggotaFormScreen({super.key, this.anggota});

  @override
  State<AnggotaFormScreen> createState() => _AnggotaFormScreenState();
}

class _AnggotaFormScreenState extends State<AnggotaFormScreen> {
  final _namaController = TextEditingController();
  final _nimController = TextEditingController();
  final _tanggalLahirController = TextEditingController();

  bool get isEdit => widget.anggota != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      final a = widget.anggota!;
      _namaController.text = a.nama;
      _nimController.text = a.nim;
      _tanggalLahirController.text = a.tanggalLahir;
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _tanggalLahirController.dispose();
    super.dispose();
  }

  void _save() {
    final nama = _namaController.text.trim();
    final nim = _nimController.text.trim();
    final tanggalLahir = _tanggalLahirController.text.trim();

    if (nama.isEmpty || nim.isEmpty || tanggalLahir.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Lengkapi dulu semua data ya')));
      return;
    }

    if (isEdit) {
      final a = widget.anggota!;
      a.nama = nama;
      a.nim = nim;
      a.tanggalLahir = tanggalLahir;
    } else {
      final newId = dummyAnggota.isEmpty
          ? 1
          : dummyAnggota.map((a) => a.id).reduce((a, b) => a > b ? a : b) + 1;
      dummyAnggota.add(Anggota(id: newId, nama: nama, nim: nim, tanggalLahir: tanggalLahir));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Anggota' : 'Tambah Anggota')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const _Label('Nama'),
          TextField(controller: _namaController, decoration: _decoration('contoh: Aulia')),
          const SizedBox(height: 16),
          const _Label('NIM'),
          TextField(
              controller: _nimController,
              keyboardType: TextInputType.number,
              decoration: _decoration('contoh: 12345678')),
          const SizedBox(height: 16),
          const _Label('Tanggal Lahir'),
          TextField(
              controller: _tanggalLahirController,
              decoration: _decoration('contoh: 12 Mei 2005')),
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
