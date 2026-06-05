import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../widgets/common/premium_table.dart';
import '../../widgets/common/action_button.dart';
import '../../services/notification_service.dart';

class PresencesScreen extends StatefulWidget {
  const PresencesScreen({super.key});
  @override
  State<PresencesScreen> createState() => _PresencesScreenState();
}

class _PresencesScreenState extends State<PresencesScreen> {
  List<Map<String, dynamic>> _data = [];
  String _filter = 'tous';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final now = DateTime.now();
    _data = [
      {'name': 'Nathanael Kouassi', 'dept': 'Informatique', 'entree': '07:55', 'sortie': '17:30', 'date': '05/06/2026', 'statut': 'present', 'valid': 'valide'},
      {'name': 'Awa Koné', 'dept': 'Comptabilité', 'entree': '08:15', 'sortie': '17:00', 'date': '05/06/2026', 'statut': 'retard', 'valid': 'en_attente'},
      {'name': 'Jean Yao', 'dept': 'Logistique', 'entree': '07:48', 'sortie': '17:45', 'date': '05/06/2026', 'statut': 'present', 'valid': 'valide'},
      {'name': 'Marie Diallo', 'dept': 'RH', 'entree': '—', 'sortie': '—', 'date': '05/06/2026', 'statut': 'absent', 'valid': 'non_valide'},
      {'name': 'Koffi N\'Guessan', 'dept': 'Production', 'entree': '08:05', 'sortie': '17:15', 'date': '05/06/2026', 'statut': 'retard', 'valid': 'valide'},
      {'name': 'Alice Dubois', 'dept': 'Marketing', 'entree': '08:00', 'sortie': '17:00', 'date': '04/06/2026', 'statut': 'present', 'valid': 'valide'},
      {'name': 'Paul Zadi', 'dept': 'IT', 'entree': '08:30', 'sortie': '17:00', 'date': '04/06/2026', 'statut': 'retard', 'valid': 'en_attente'},
      {'name': 'Emma Touré', 'dept': 'Finance', 'entree': '08:00', 'sortie': '16:30', 'date': '04/06/2026', 'statut': 'present', 'valid': 'valide'},
      {'name': 'David Koffi', 'dept': 'Production', 'entree': '—', 'sortie': '—', 'date': '03/06/2026', 'statut': 'absent', 'valid': 'non_valide'},
      {'name': 'Sarah Bah', 'dept': 'RH', 'entree': '08:00', 'sortie': '17:00', 'date': '03/06/2026', 'statut': 'present', 'valid': 'valide'},
      {'name': 'Michel Coulibaly', 'dept': 'Logistique', 'entree': '08:10', 'sortie': '17:30', 'date': '02/06/2026', 'statut': 'retard', 'valid': 'valide'},
      {'name': 'Fatou Soro', 'dept': 'Informatique', 'entree': '07:50', 'sortie': '17:45', 'date': '02/06/2026', 'statut': 'present', 'valid': 'valide'},
    ];
  }

  Color _statutColor(String s) => s == 'present' ? AppColors.success : s == 'retard' ? AppColors.warning : AppColors.error;
  String _statutLabel(String s) => s == 'present' ? 'Présent' : s == 'retard' ? 'Retard' : 'Absent';

  @override
  Widget build(BuildContext context) {
    final presents = _data.where((d) => d['statut'] == 'present').length;
    final retards = _data.where((d) => d['statut'] == 'retard').length;
    final absents = _data.where((d) => d['statut'] == 'absent').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header
        Row(children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.check_circle, color: AppColors.success, size: 24)),
          const SizedBox(width: 12),
          Text('Tableau des Présences', style: Theme.of(context).textTheme.headlineMedium),
        ]),
        const SizedBox(height: 20),

        // KPIs
        Row(children: [
          _kpi('Présents', '$presents', AppColors.success),
          const SizedBox(width: 10),
          _kpi('Retards', '$retards', AppColors.warning),
          const SizedBox(width: 10),
          _kpi('Absents', '$absents', AppColors.error),
          const SizedBox(width: 10),
          _kpi('Total', '${_data.length}', AppColors.primary),
        ]),
        const SizedBox(height: 16),

        // Filtres rapides
        Row(children: [
          _chip('Tous', 'tous'),
          const SizedBox(width: 6),
          _chip('🟢 Présents', 'present'),
          const SizedBox(width: 6),
          _chip('🟠 Retards', 'retard'),
          const SizedBox(width: 6),
          _chip('🔴 Absents', 'absent'),
        ]),
        const SizedBox(height: 20),

        // Tableau premium
        PremiumTable(
          title: 'Liste des Présences',
          subtitle: '${_data.length} enregistrements',
          columns: const [
            PremiumColumn(label: 'Employé', icon: Icons.person_outline),
            PremiumColumn(label: 'Département', icon: Icons.business),
            PremiumColumn(label: 'Entrée', icon: Icons.login),
            PremiumColumn(label: 'Sortie', icon: Icons.logout),
            PremiumColumn(label: 'Date', icon: Icons.calendar_today),
            PremiumColumn(label: 'Statut'),
            PremiumColumn(label: 'Validation'),
            PremiumColumn(label: 'Actions'),
          ],
          rows: _data.where((d) => _filter == 'tous' || d['statut'] == _filter).map((d) {
            final sc = _statutColor(d['statut']);
            return PremiumRow(cells: [
              PremiumCell(widget: Row(children: [
                CircleAvatar(radius: 14, backgroundColor: AppColors.primary.withOpacity(0.1), child: Text(d['name'][0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12))),
                const SizedBox(width: 8),
                Text(d['name'], style: const TextStyle(fontWeight: FontWeight.w500)),
              ]), value: d['name']),
              PremiumCell(widget: Text(d['dept']), value: d['dept']),
              PremiumCell(widget: Text(d['entree'], style: TextStyle(color: d['entree'] == '—' ? AppColors.error : null)), value: d['entree']),
              PremiumCell(widget: Text(d['sortie'], style: TextStyle(color: d['sortie'] == '—' ? AppColors.error : null)), value: d['sortie']),
              PremiumCell(widget: Text(d['date']), value: d['date']),
              PremiumCell(widget: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: sc.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: sc.withOpacity(0.3))),
                child: Text(_statutLabel(d['statut']), style: TextStyle(color: sc, fontSize: 11, fontWeight: FontWeight.bold)),
              ), value: d['statut']),
              PremiumCell(widget: Icon(d['valid'] == 'valide' ? Icons.check_circle : d['valid'] == 'en_attente' ? Icons.pending : Icons.cancel, color: d['valid'] == 'valide' ? AppColors.success : d['valid'] == 'en_attente' ? AppColors.warning : AppColors.error, size: 20), value: d['valid']),
              PremiumCell(widget: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(icon: const Icon(Icons.visibility, size: 16, color: AppColors.info), onPressed: () => NotificationService.info(context, '👁️ Détails de ${d['name']}')),
                IconButton(icon: const Icon(Icons.edit, size: 16, color: AppColors.secondary), onPressed: () => NotificationService.success(context, '✏️ ${d['name']} modifié')),
                IconButton(icon: const Icon(Icons.delete, size: 16, color: AppColors.error), onPressed: () {
                  setState(() => _data.removeWhere((x) => x['name'] == d['name']));
                  NotificationService.error(context, '🗑️ ${d['name']} supprimé');
                }),
              ]), value: ''),
            ]);
          }).toList(),
          onAdd: () => NotificationService.success(context, '➕ Nouvelle présence ajoutée'),
          onExport: () => NotificationService.info(context, '📥 Export en cours...'),
          onRefresh: () { setState(() => _loadData()); NotificationService.info(context, '🔄 Données actualisées'); },
          emptyMessage: 'Aucune présence enregistrée',
        ),
      ]),
    );
  }

  Widget _kpi(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(color: color.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.1))),
        child: Column(children: [
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ]),
      ),
    );
  }

  Widget _chip(String label, String value) {
    final selected = _filter == value;
    return InkWell(
      onTap: () => setState(() => _filter = value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withOpacity(0.1) : AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: selected ? AppColors.primary : AppColors.border),
        ),
        child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: selected ? AppColors.primary : AppColors.textSecondary)),
      ),
    );
  }
}
