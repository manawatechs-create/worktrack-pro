import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../widgets/common/app_card.dart';
import '../../widgets/common/status_badge.dart';

class ValidationScreen extends StatelessWidget {
  const ValidationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final demandes = const [
      {'type': 'Congé', 'employe': 'Jean Yao', 'details': 'Congé annuel 15 jours', 'date': '05/06/2026', 'statut': 'en_attente'},
      {'type': 'Heures Sup.', 'employe': 'Awa Koné', 'details': '8h supplémentaires', 'date': '04/06/2026', 'statut': 'en_attente'},
      {'type': 'Mission', 'employe': 'Koffi N\'Guessan', 'details': 'Mission Abidjan', 'date': '03/06/2026', 'statut': 'en_attente'},
      {'type': 'Congé', 'employe': 'Marie Diallo', 'details': 'Congé maladie 3 jours', 'date': '02/06/2026', 'statut': 'valide'},
      {'type': 'Absence', 'employe': 'Paul Zadi', 'details': 'Justification absence', 'date': '01/06/2026', 'statut': 'refuse'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.fact_check, color: AppColors.primary, size: 28)),
          const SizedBox(width: 16),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Validation RH', style: Theme.of(context).textTheme.headlineMedium),
            const Text('Validation des demandes en attente', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          ]),
        ]),
        const SizedBox(height: 24),

        Row(children: [
          _statCard('En attente', '3', '', AppColors.warning),
          const SizedBox(width: 12),
          _statCard('Validées', '12', 'Ce mois', AppColors.success),
          const SizedBox(width: 12),
          _statCard('Refusées', '2', 'Ce mois', AppColors.error),
        ]),
        const SizedBox(height: 24),

        AppCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Demandes à Valider', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ...demandes.map((d) => ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: d['statut'] == 'en_attente' ? AppColors.warning.withOpacity(0.1) : 
                         d['statut'] == 'valide' ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  d['type'] == 'Congé' ? Icons.beach_access : 
                  d['type'] == 'Heures Sup.' ? Icons.add_alarm : 
                  d['type'] == 'Mission' ? Icons.flight : Icons.cancel,
                  color: d['statut'] == 'en_attente' ? AppColors.warning : 
                         d['statut'] == 'valide' ? AppColors.success : AppColors.error,
                ),
              ),
              title: Text('${d['type']} - ${d['employe']}', style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(d['details']!),
              trailing: d['statut'] == 'en_attente' 
                ? Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(icon: const Icon(Icons.check, color: AppColors.success), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.close, color: AppColors.error), onPressed: () {}),
                  ])
                : d['statut'] == 'valide' ? StatusBadge.validated() : StatusBadge.refused(),
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
        if (subtitle.isNotEmpty) Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ])),
    );
  }
}
