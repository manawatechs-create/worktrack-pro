import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../widgets/common/app_card.dart';
import '../../widgets/common/status_badge.dart';

class RetardsScreen extends StatelessWidget {
  const RetardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final retards = const [
      {'employe': 'Awa Koné', 'departement': 'Comptabilité', 'date': '05/06/2026', 'heure_prevue': '08:00', 'heure_arrivee': '08:15', 'duree': '15 min', 'statut': 'Justifié'},
      {'employe': 'Koffi N\'Guessan', 'departement': 'Production', 'date': '05/06/2026', 'heure_prevue': '08:00', 'heure_arrivee': '08:05', 'duree': '5 min', 'statut': 'Non justifié'},
      {'employe': 'Alice Dubois', 'departement': 'Marketing', 'date': '04/06/2026', 'heure_prevue': '08:00', 'heure_arrivee': '08:30', 'duree': '30 min', 'statut': 'Justifié'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.1), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.access_time, color: AppColors.warning, size: 28)),
          const SizedBox(width: 16),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Analyse des Retards', style: Theme.of(context).textTheme.headlineMedium),
            const Text('Suivi et gestion des retards', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          ]),
        ]),
        const SizedBox(height: 24),

        Row(children: [
          _statCard('Total Retards', '3', 'Aujourd\'hui', AppColors.warning),
          const SizedBox(width: 12),
          _statCard('Retard Moyen', '16 min', 'Cette semaine', AppColors.secondary),
          const SizedBox(width: 12),
          _statCard('Fréquence', '2.5%', 'Ce mois', AppColors.info),
        ]),
        const SizedBox(height: 24),

        AppCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Liste des Retards', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Employé')),
                  DataColumn(label: Text('Département')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Prévue')),
                  DataColumn(label: Text('Arrivée')),
                  DataColumn(label: Text('Durée')),
                  DataColumn(label: Text('Statut')),
                  DataColumn(label: Text('Action')),
                ],
                rows: retards.map((r) => DataRow(cells: [
                  DataCell(Text(r['employe']!, style: const TextStyle(fontWeight: FontWeight.w500))),
                  DataCell(Text(r['departement']!)),
                  DataCell(Text(r['date']!)),
                  DataCell(Text(r['heure_prevue']!)),
                  DataCell(Text(r['heure_arrivee']!, style: const TextStyle(color: AppColors.warning, fontWeight: FontWeight.bold))),
                  DataCell(Text(r['duree']!)),
                  DataCell(r['statut'] == 'Justifié' ? StatusBadge.validated() : StatusBadge.pending()),
                  DataCell(ElevatedButton(onPressed: () {}, child: const Text('Justifier'), style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), textStyle: const TextStyle(fontSize: 11)))),
                ])).toList(),
              ),
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
