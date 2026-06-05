import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../widgets/common/app_card.dart';

class PlanningsScreen extends StatelessWidget {
  const PlanningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.schedule, color: AppColors.primary, size: 28)),
          const SizedBox(width: 16),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Horaires & Plannings', style: Theme.of(context).textTheme.headlineMedium),
            const Text('Gestion des horaires de travail', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          ]),
        ]),
        const SizedBox(height: 24),

        Row(children: [
          Expanded(child: _horaireCard('Horaire Standard', '08:00 - 17:00', 'Lun-Ven', AppColors.success)),
          const SizedBox(width: 12),
          Expanded(child: _horaireCard('Équipe A', '06:00 - 14:00', 'Rotation', AppColors.info)),
          const SizedBox(width: 12),
          Expanded(child: _horaireCard('Équipe B', '14:00 - 22:00', 'Rotation', AppColors.warning)),
          const SizedBox(width: 12),
          Expanded(child: _horaireCard('Nuit', '22:00 - 06:00', 'Lun-Dim', AppColors.secondary)),
        ]),
        const SizedBox(height: 24),

        AppCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Planning Hebdomadaire', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(columns: const [
                DataColumn(label: Text('Employé')),
                DataColumn(label: Text('Lun')), DataColumn(label: Text('Mar')),
                DataColumn(label: Text('Mer')), DataColumn(label: Text('Jeu')),
                DataColumn(label: Text('Ven')), DataColumn(label: Text('Sam')),
              ], rows: List.generate(8, (i) => DataRow(cells: [
                DataCell(Text('Employé ${i+1}')),
                ...List.generate(6, (j) => DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: j < 5 ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(j < 5 ? '08-17' : 'Off', style: TextStyle(fontSize: 11, color: j < 5 ? AppColors.success : AppColors.error)),
                  ),
                )),
              ]))),
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _horaireCard(String title, String horaires, String jours, Color color) {
    return AppCard(
      child: Column(children: [
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(Icons.schedule, color: color, size: 24)),
        const SizedBox(height: 12),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(horaires, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        Text(jours, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ]),
    );
  }
}
