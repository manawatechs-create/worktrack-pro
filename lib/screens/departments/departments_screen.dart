import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../widgets/common/app_card.dart';
import '../../widgets/common/data_table_widget.dart';

class DepartmentsScreen extends StatefulWidget {
  const DepartmentsScreen({super.key});

  @override
  State<DepartmentsScreen> createState() => _DepartmentsScreenState();
}

class _DepartmentsScreenState extends State<DepartmentsScreen> {
  final List<Map<String, dynamic>> _departments = [
    {'name': 'Informatique', 'chef': 'Nathanael Kouassi', 'effectif': 12, 'status': 'Actif', 'budget': '25M FCFA'},
    {'name': 'Ressources Humaines', 'chef': 'Marie Diallo', 'effectif': 8, 'status': 'Actif', 'budget': '15M FCFA'},
    {'name': 'Finance', 'chef': 'Pierre Durand', 'effectif': 6, 'status': 'Actif', 'budget': '20M FCFA'},
    {'name': 'Marketing', 'chef': 'Sophie Bernard', 'effectif': 5, 'status': 'Inactif', 'budget': '18M FCFA'},
    {'name': 'Production', 'chef': 'Koffi N\'Guessan', 'effectif': 20, 'status': 'Actif', 'budget': '50M FCFA'},
    {'name': 'Logistique', 'chef': 'Jean Yao', 'effectif': 10, 'status': 'Actif', 'budget': '22M FCFA'},
    {'name': 'Commercial', 'chef': 'Awa Koné', 'effectif': 15, 'status': 'Actif', 'budget': '30M FCFA'},
  ];

  @override
  Widget build(BuildContext context) {
    final actifs = _departments.where((d) => d['status'] == 'Actif').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.business, color: AppColors.primary, size: 28)),
          const SizedBox(width: 16),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Départements', style: Theme.of(context).textTheme.headlineMedium),
            Text('${_departments.length} départements - $actifs actifs', style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          ]),
        ]),
        const SizedBox(height: 24),

        // Vue en cartes
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: _departments.map((d) => AppCard(
            onTap: () {},
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.business, color: AppColors.primary)),
                const Spacer(),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: d['status'] == 'Actif' ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Text(d['status'], style: TextStyle(color: d['status'] == 'Actif' ? AppColors.success : AppColors.error, fontSize: 11, fontWeight: FontWeight.bold))),
              ]),
              const SizedBox(height: 16),
              Text(d['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _infoRow('👤 Chef', d['chef']),
              _infoRow('👥 Effectif', '${d['effectif']} employés'),
              _infoRow('💰 Budget', d['budget']),
            ]),
          )).toList(),
        ),
      ]),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Text('$label: $value', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
    );
  }
}
