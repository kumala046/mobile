import 'package:flutter/material.dart';
import '../models/anggota.dart';
import '../utils/app_colors.dart';
import '../utils/formatters.dart';
import 'anggota_form_screen.dart';

class AnggotaDetailScreen extends StatefulWidget {
  final Anggota anggota;
  final int index;

  const AnggotaDetailScreen({super.key, required this.anggota, required this.index});

  @override
  State<AnggotaDetailScreen> createState() => _AnggotaDetailScreenState();
}

class _AnggotaDetailScreenState extends State<AnggotaDetailScreen> {
  Future<void> _edit() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AnggotaFormScreen(anggota: widget.anggota)),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final anggota = widget.anggota;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Anggota'),
        actions: [
          IconButton(onPressed: _edit, icon: const Icon(Icons.edit_outlined)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 42,
                  backgroundColor: avatarColors[widget.index % avatarColors.length],
                  child: Text(initials(anggota.nama),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
                ),
                const SizedBox(height: 12),
                Text(anggota.nama,
                    style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                const Text('Anggota Travel Planner',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _DetailField(label: 'Nama', value: anggota.nama),
          _DetailField(label: 'NIM', value: anggota.nim),
          _DetailField(label: 'Tanggal Lahir', value: anggota.tanggalLahir),
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
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
        ],
      ),
    );
  }
}
