import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../utils/app_colors.dart';
import '../utils/formatters.dart';
import '../utils/user_session.dart';
import 'anggota_list_screen.dart';
import 'trip_list_screen.dart';
import 'destinasi_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _goTo(Widget screen) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    setState(() {}); // refresh data pas balik ke Home
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final upcomingTrips = dummyTrips
        .where((t) => t.berangkat.isAfter(now) || _isSameDay(t.berangkat, now))
        .toList()
      ..sort((a, b) => a.berangkat.compareTo(b.berangkat));
    final nextTrip = upcomingTrips.isNotEmpty ? upcomingTrips.first : null;
    final activeTripCount =
        dummyTrips.where((t) => t.status == 'aktif').length;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        Text(
          'Halo, ${UserSession.currentUserName} 👋',
          style: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 13),
        ),
        const SizedBox(height: 2),
        const Text(
          'Rencanakan trip kalian',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.5),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Trip berikutnya',
                  style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.5)),
              const SizedBox(height: 6),
              Text(
                nextTrip?.nama ?? 'Belum ada trip',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              const SizedBox(height: 2),
              Text(
                nextTrip != null
                    ? formatRange(nextTrip.berangkat, nextTrip.pulang)
                    : 'Tambahkan trip pertama kalian',
                style: const TextStyle(color: Colors.white70, fontSize: 12.5),
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: () => _goTo(const TripListScreen()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.16),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                ),
                child: const Text('Lihat detail →',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const Text('Menu utama',
            style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
                fontSize: 13)),
        const SizedBox(height: 10),
        _FeatureCard(
          icon: Icons.people_outline,
          iconColor: AppColors.primary,
          iconBg: AppColors.primary.withOpacity(0.12),
          title: 'Daftar Anggota',
          subtitle: '${dummyAnggota.length} anggota terdaftar',
          onTap: () => _goTo(const AnggotaListScreen()),
        ),
        const SizedBox(height: 12),
        _FeatureCard(
          icon: Icons.map_outlined,
          iconColor: AppColors.aktif,
          iconBg: AppColors.aktif.withOpacity(0.12),
          title: 'Kelola Trip',
          subtitle: '$activeTripCount trip aktif',
          onTap: () => _goTo(const TripListScreen()),
        ),
        const SizedBox(height: 12),
        _FeatureCard(
          icon: Icons.explore_outlined,
          iconColor: const Color(0xFF2E8CDB),
          iconBg: const Color(0xFF2E8CDB).withOpacity(0.12),
          title: 'Destinasi',
          subtitle: '${dummyDestinasi.length} tempat wisata',
          onTap: () => _goTo(const DestinasiListScreen()),
        ),
        const SizedBox(height: 24),
        const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Data masih dummy, belum tersambung database',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black26, fontSize: 11),
            ),
          ),
        ),
      ],
    );
  }
}

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration:
                  BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12.5)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
