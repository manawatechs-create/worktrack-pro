import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../widgets/common/app_card.dart';
import '../../widgets/common/status_badge.dart';

class AbsencesScreen extends StatelessWidget {
  const AbsencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final absences = const [
      {'employe': 'Marie Diallo', 'departement': 'RH', 'date': '05/06/2026', 'type': 'Injustifiée', 'duree': '1 jour', 'statut': 'Non justifié'},
      {'employe': 'Paul Zadi', 'departement': 'IT', 'date': '04/06/2026', 'type': 'Maladie', 'duree': '3 jours', 'statut': 'Justifié'},
      {'employe': 'Emma Touré', 'departement': 'Finance', 'date': '03/06/2026', 'type': 'Formation', 'duree': '5 jours', 'statut': 'Justifié'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.cancel, color: AppColors.error, size: 28)),
          const SizedBox(width: 16),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Gestion des Absences', style: Theme.of(context).textTheme.headlineMedium),
            const Text('Suivi et analyse des absences', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          ]),
        ]),
        const SizedBox(height: 24),

        Row(children: [
          _statCard('Total Absences', '8', 'Ce mois', AppColors.error),
          const SizedBox(width: 12),
          _statCard('Justifiées', '5', '62.5%', AppColors.success),
          const SizedBox(width: 12),
          _statCard('Injustifiées', '3', '37.5%', AppColors.warning),
        ]),
        const SizedBox(height: 24),

        AppCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Liste des Absences', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(columns: const [
                DataColumn(label: Text('Employé')), DataColumn(label: Text('Département')),
                DataColumn(label: Text('Date')), DataColumn(label: Text('Type')),
                DataColumn(label: Text('Durée')), DataColumn(label: Text('Statut')),
                DataColumn(label: Text('Action')),
              ], rows: absences.map((a) => DataRow(cells: [
                DataCell(Text(a['employe']!, style: const TextStyle(fontWeight: FontWeight.w500))),
                DataCell(Text(a['departement']!)),
                DataCell(Text(a['date']!)),
                DataCell(Text(a['type']!)),
                DataCell(Text(a['duree']!)),
                DataCell(a['statut'] == 'Justifié' ? StatusBadge.validated() : StatusBadge.refused()),
                DataCell(ElevatedButton(onPressed: () {}, child: const Text('Détails'), style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), textStyle: const TextStyle(fontSize: 11)))),
              ])).toList()),
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _statCard(String title, String value, String subtitle, Color color) {
    return Expanded(
      child: AppCard(
        child: Column(children: [
          Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ]),
      ),
    );
  }
}
