import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../widgets/common/app_card.dart';
import '../../widgets/common/status_badge.dart';

class OvertimeScreen extends StatelessWidget {
  const OvertimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.secondary.withOpacity(0.1), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.add_alarm, color: AppColors.secondary, size: 28)),
          const SizedBox(width: 16),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Heures Supplémentaires', style: Theme.of(context).textTheme.headlineMedium),
            const Text('Suivi et validation des heures sup.', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          ]),
        ]),
        const SizedBox(height: 24),

        Row(children: [
          _statCard('Total H. Sup.', '25h', 'Ce mois', AppColors.secondary),
          const SizedBox(width: 12),
          _statCard('Validées', '18h', '72%', AppColors.success),
          const SizedBox(width: 12),
          _statCard('En attente', '7h', '28%', AppColors.warning),
        ]),
        const SizedBox(height: 24),

        AppCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Dernières Heures Supplémentaires', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ...List.generate(5, (i) => ListTile(
              leading: CircleAvatar(backgroundColor: AppColors.secondary.withOpacity(0.1), child: const Icon(Icons.add_alarm, color: AppColors.secondary)),
              title: Text('Employé ${i+1}'),
              subtitle: Text('${8+i}h supplémentaires - ${5+i}/06/2026'),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                Text('+${2+i}h', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(width: 8),
                i % 2 == 0 ? StatusBadge.validated() : StatusBadge.pending(),
              ]),
            )),
          ]),
        ),
      ]),
    );
  }

  Widget _statCard(String title, String value, String subtitle, Color color) {
    return Expanded(
      child: AppCard(child: Column(children: [
        Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ])),
    );
  }
}
