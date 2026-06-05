import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../widgets/common/app_card.dart';
import '../../widgets/common/status_badge.dart';

class MissionsScreen extends StatelessWidget {
  const MissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.info.withOpacity(0.1), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.flight, color: AppColors.info, size: 28)),
          const SizedBox(width: 16),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Missions & Déplacements', style: Theme.of(context).textTheme.headlineMedium),
            const Text('Suivi des missions professionnelles', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          ]),
        ]),
        const SizedBox(height: 24),

        Row(children: [
          _missionCard('Mission Abidjan', 'Nathanael Kouassi', '05/06 - 10/06/2026', 'En cours', AppColors.info),
          const SizedBox(width: 12),
          _missionCard('Formation Dakar', 'Awa Koné', '15/06 - 20/06/2026', 'Planifiée', AppColors.warning),
          const SizedBox(width: 12),
          _missionCard('Séminaire Paris', 'Jean Yao', '01/05 - 05/05/2026', 'Terminée', AppColors.success),
        ]),
        const SizedBox(height: 24),

        AppCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Historique des Missions', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ...List.generate(5, (i) => ListTile(
              leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.info.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.flight, color: AppColors.info, size: 18)),
              title: Text('Mission ${i+1} - ${['Abidjan', 'Dakar', 'Paris', 'Lagos', 'Accra'][i]}'),
              subtitle: Text('${10+i}/06/2026 - ${15+i}/06/2026'),
              trailing: StatusBadge.validated(),
            )),
          ]),
        ),
      ]),
    );
  }

  Widget _missionCard(String title, String employe, String dates, String statut, Color color) {
    return Expanded(
      child: AppCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Icon(Icons.flight, color: color, size: 18)),
            const Spacer(),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Text(statut, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold))),
          ]),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(employe, style: const TextStyle(fontSize: 13)),
          Text(dates, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ]),
      ),
    );
  }
}
