import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  final double fontSize;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.fontSize = 12,
  });

  factory StatusBadge.present() => const StatusBadge(label: 'Présent', color: AppColors.success, icon: Icons.check_circle);
  factory StatusBadge.absent() => const StatusBadge(label: 'Absent', color: AppColors.error, icon: Icons.cancel);
  factory StatusBadge.late() => const StatusBadge(label: 'Retard', color: AppColors.warning, icon: Icons.access_time);
  factory StatusBadge.validated() => const StatusBadge(label: 'Validé', color: AppColors.success, icon: Icons.verified);
  factory StatusBadge.pending() => const StatusBadge(label: 'En attente', color: AppColors.warning, icon: Icons.pending);
  factory StatusBadge.refused() => const StatusBadge(label: 'Refusé', color: AppColors.error, icon: Icons.block);
  factory StatusBadge.active() => const StatusBadge(label: 'Actif', color: AppColors.success, icon: Icons.person);
  factory StatusBadge.inactive() => const StatusBadge(label: 'Inactif', color: AppColors.textSecondary, icon: Icons.person_off);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
          ],
          Text(label, style: TextStyle(color: color, fontSize: fontSize, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
