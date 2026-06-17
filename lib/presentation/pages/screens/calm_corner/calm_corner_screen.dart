import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';

class CalmCornerScreen extends StatelessWidget {
  const CalmCornerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1f30),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141828),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFb8a8d8)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Calm Corner',
          style: TextStyle(color: Color(0xFFeceaf8), fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Take a moment for yourself.',
              style: TextStyle(color: Color(0xFF8a8aaa), fontSize: 15),
            ),
            const SizedBox(height: 32),
            _CalmTile(
              icon: Icons.self_improvement,
              iconColor: const Color(0xFF89b4e8),
              title: 'Grounding Exercise',
              subtitle: '5-4-3-2-1  •  Brings you back to the present',
              onTap: () => Get.toNamed(groundingRoute),
            ),
            const SizedBox(height: 16),
            _CalmTile(
              icon: Icons.air,
              iconColor: const Color(0xFFb8a8d8),
              title: 'Breathing Exercise',
              subtitle: 'Coming soon',
              onTap: null,
              locked: true,
            ),
            const SizedBox(height: 16),
            _CalmTile(
              icon: Icons.palette_outlined,
              iconColor: const Color(0xFFd4a0b8),
              title: 'Color & Discover',
              subtitle: 'Coming soon — Zing Photography',
              onTap: null,
              locked: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _CalmTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool locked;

  const _CalmTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.locked = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF141828),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF252a3a), width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: locked ? const Color(0xFF4a4a62) : const Color(0xFFeceaf8),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(subtitle, style: const TextStyle(color: Color(0xFF6a6a88), fontSize: 12)),
                ],
              ),
            ),
            Icon(locked ? Icons.lock_outline : Icons.chevron_right, color: const Color(0xFF4a4a62), size: 20),
          ],
        ),
      ),
    );
  }
}
