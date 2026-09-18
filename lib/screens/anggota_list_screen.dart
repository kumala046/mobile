import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/anggota.dart';
import '../utils/app_colors.dart';
import '../utils/formatters.dart';
import 'anggota_detail_screen.dart';
import 'anggota_form_screen.dart';

class AnggotaListScreen extends StatefulWidget {
  const AnggotaListScreen({super.key});

  @override
  State<AnggotaListScreen> createState() => _AnggotaListScreenState();
}

class _AnggotaListScreenState extends State<AnggotaListScreen> {
  Future<void> _openForm({Anggota? anggota}) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (_) => AnggotaFormScreen(anggota: anggota)));
    setState(() {});
  }

  Future<void> _openDetail(Anggota anggota, int index) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => AnggotaDetailScreen(anggota: anggota, index: index)),
    );
    setState(() {});
  }

  void _confirmDelete(Anggota anggota) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yakin ingin menghapus?'),
        content: Text('"${anggota.nama}" akan dihapus dari daftar anggota.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              setState(() {
                dummyAnggota.removeWhere((a) => a.id == anggota.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Anggota berhasil dihapus')));
            },
            child: const Text('Ya, Hapus', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Anggota')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _openForm(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: dummyAnggota.isEmpty
          ? const Center(child: Text('Belum ada anggota terdaftar'))
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
              itemCount: dummyAnggota.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final m = dummyAnggota[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _openDetail(m, index),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: avatarColors[index % avatarColors.length],
                          child: Text(initials(m.nama),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                        ),
                        const SizedBox(width: 13),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(m.nama,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 14.5)),
                              const SizedBox(height: 2),
                              Text('NIM ${m.nim}',
                                  style: const TextStyle(
                                      color: AppColors.textSecondary, fontSize: 12)),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => _openForm(anggota: m),
                          icon: const Icon(Icons.edit_outlined,
                              size: 19, color: AppColors.primary),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 14),
                        IconButton(
                          onPressed: () => _confirmDelete(m),
                          icon: const Icon(Icons.delete_outline,
                              size: 19, color: AppColors.danger),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
