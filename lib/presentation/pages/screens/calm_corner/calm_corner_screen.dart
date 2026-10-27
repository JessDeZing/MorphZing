import 'calm_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/localization/translation_keys.dart' as translation;

class CalmCornerScreen extends StatelessWidget {
  const CalmCornerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CalmColors.bg,
      appBar: AppBar(
        backgroundColor: CalmColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: CalmColors.lavender),
          onPressed: () => Get.back(),
        ),
        title: Text(
          translation.calmCorner.tr,
          style: TextStyle(color: CalmColors.title, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              translation.takeAMomentForYourself.tr,
              style: TextStyle(color: CalmColors.body, fontSize: 15),
            ),
            const SizedBox(height: 32),
            _CalmTile(
              icon: Icons.self_improvement,
              iconColor: CalmColors.blue,
              title: translation.groundingExercise.tr,
              subtitle: translation.groundingExerciseSubtitle.tr,
              onTap: () => Get.toNamed(groundingRoute),
            ),
            const SizedBox(height: 16),
            _CalmTile(
              icon: Icons.air,
              iconColor: CalmColors.lavender,
              title: translation.breathingExercise.tr,
              subtitle: translation.breathingExerciseSubtitle.tr,
              onTap: () => Get.toNamed(breathingRoute),
            ),
            const SizedBox(height: 16),
            _CalmTile(
              icon: Icons.palette_outlined,
              iconColor: CalmColors.rose,
              title: translation.colorAndDiscover.tr,
              subtitle: translation.comingSoonZingPhotography.tr,
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
          color: CalmColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: CalmColors.border, width: 0.5),
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
                      color: locked ? CalmColors.dim : CalmColors.title,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(subtitle, style: TextStyle(color: CalmColors.muted, fontSize: 12)),
                ],
              ),
            ),
            Icon(locked ? Icons.lock_outline : Icons.chevron_right, color: CalmColors.dim, size: 20),
          ],
        ),
      ),
    );
  }
}
