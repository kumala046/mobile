import 'package:flutter/material.dart';

const List<String> bulanID = [
  'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
  'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
];

String formatDate(DateTime date) {
  return '${date.day} ${bulanID[date.month - 1]} ${date.year}';
}

String formatRange(DateTime start, DateTime end) {
  if (start.month == end.month && start.year == end.year) {
    return '${start.day} - ${end.day} ${bulanID[end.month - 1]} ${end.year}';
  }
  return '${formatDate(start)} - ${formatDate(end)}';
}

String initials(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  final letters = parts.map((p) => p.isNotEmpty ? p[0] : '').take(2).join();
  return letters.toUpperCase();
}

const List<Color> avatarColors = [
  Color(0xFFE1546B),
  Color(0xFF2E8CDB),
  Color(0xFF6D5BD0),
  Color(0xFF1FAF93),
  Color(0xFFE39A2E),
];
