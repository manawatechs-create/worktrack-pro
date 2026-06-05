import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';

class DatabaseManagement extends StatefulWidget {
  const DatabaseManagement({super.key});
  @override
  State<DatabaseManagement> createState() => _DatabaseManagementState();
}

class _DatabaseManagementState extends State<DatabaseManagement> {
  bool _isBackingUp = false;
  bool _isOptimizing = false;

  final List<Map<String, String>> _tables = [
    {'name': 'users', 'rows': '50', 'size': '2.3 MB', 'status': 'OK'},
    {'name': 'presences', 'rows': '12,450', 'size': '8.7 MB', 'status': 'OK'},
    {'name': 'leaves', 'rows': '230', 'size': '1.2 MB', 'status': 'OK'},
    {'name': 'departments', 'rows': '7', 'size': '0.1 MB', 'status': 'OK'},
    {'name': 'notifications', 'rows': '3,200', 'size': '4.5 MB', 'status': 'OK'},
    {'name': 'activity_logs', 'rows': '25,600', 'size': '15.2 MB', 'status': '⚠️ Large'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🗄️ Base de Données'), backgroundColor: AppColors.sidebarColor),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: _actionCard('💾 Sauvegarder', 'Créer une sauvegarde complète', _isBackingUp, () async {
              setState(() => _isBackingUp = true);
              await Future.delayed(const Duration(seconds: 2));
              setState(() => _isBackingUp = false);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Sauvegarde terminée (32.1 MB)'), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating));
            })),
            const SizedBox(width: 12),
            Expanded(child: _actionCard('🔄 Restaurer', 'Restaurer depuis une sauvegarde', false, () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('⚠️ Fonctionnalité avancée - Contactez l\'administrateur'), behavior: SnackBarBehavior.floating));
            })),
            const SizedBox(width: 12),
            Expanded(child: _actionCard('⚡ Optimiser', 'Nettoyer et optimiser les tables', _isOptimizing, () async {
              setState(() => _isOptimizing = true);
              await Future.delayed(const Duration(seconds: 1));
              setState(() => _isOptimizing = false);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Optimisation terminée'), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating));
            })),
          ]),
          const SizedBox(height: 24),
          Text('Tables de la base de données', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: DataTable(columns: const [
              DataColumn(label: Text('Table')),
              DataColumn(label: Text('Lignes')),
              DataColumn(label: Text('Taille')),
              DataColumn(label: Text('Statut')),
            ], rows: _tables.map((t) => DataRow(cells: [
              DataCell(Text(t['name']!, style: const TextStyle(fontWeight: FontWeight.w500, fontFamily: 'monospace'))),
              DataCell(Text(t['rows']!)),
              DataCell(Text(t['size']!)),
              DataCell(t['status'] == 'OK' ? const Icon(Icons.check_circle, color: AppColors.success, size: 20) : const Icon(Icons.warning, color: AppColors.warning, size: 20)),
            ])).toList()),
          ),
        ]),
      ),
    );
  }

  Widget _actionCard(String title, String subtitle, bool loading, VoidCallback onTap) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: loading ? null : onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            loading ? const SizedBox(width: 32, height: 32, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.storage, size: 32, color: AppColors.primary),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary), textAlign: TextAlign.center),
          ]),
        ),
      ),
    );
  }
}
