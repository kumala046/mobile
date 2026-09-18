import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class BantuanScreen extends StatelessWidget {
  const BantuanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Bantuan', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
        const Text('Panduan pakai Travel Planner',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
        const SizedBox(height: 16),
        const _HelpItem(
          emoji: '👥',
          title: 'Daftar Anggota',
          body:
              'Menampilkan anggota kelompok. Ketuk salah satu anggota untuk melihat detail seperti NIM dan tanggal lahir.',
        ),
        const _HelpItem(
          emoji: '🗺️',
          title: 'Kelola Trip',
          body:
              'Tempat membuat, mengubah, dan menghapus data trip (CRUD). Ketuk tombol + untuk menambah trip baru.',
        ),
        const _HelpItem(
          emoji: '⏱️',
          title: 'Stopwatch',
          body:
              'Fitur bantu untuk mengukur waktu, misalnya saat latihan presentasi atau diskusi checklist sebelum berangkat.',
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Yakin mau keluar dari aplikasi?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Ya, Logout', style: TextStyle(color: AppColors.danger)),
                    ),
                  ],
                ),
              );
            },
            style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.danger, side: const BorderSide(color: AppColors.danger)),
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ),
      ],
    );
  }
}

class _HelpItem extends StatelessWidget {
  final String emoji;
  final String title;
  final String body;

  const _HelpItem({required this.emoji, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$emoji  $title', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 6),
          Text(body,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5, height: 1.5)),
        ],
      ),
    );
  }
}
