import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../widgets/common/premium_table.dart';
import '../../widgets/common/action_button.dart';
import '../../services/notification_service.dart';
import 'employee_form_dialog.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});
  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  List<Map<String, String>> _employees = [];
  int _nextId = 1;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _employees = [
      {'id': '1', 'name': 'Nathanael Kouassi', 'email': 'n.kouassi@email.com', 'phone': '+22501000001', 'dept': 'Informatique', 'pos': 'Développeur Senior', 'status': 'Actif'},
      {'id': '2', 'name': 'Awa Koné', 'email': 'a.kone@email.com', 'phone': '+22501000002', 'dept': 'Comptabilité', 'pos': 'Comptable', 'status': 'Actif'},
      {'id': '3', 'name': 'Jean Yao', 'email': 'j.yao@email.com', 'phone': '+22501000003', 'dept': 'Logistique', 'pos': 'Responsable', 'status': 'Actif'},
      {'id': '4', 'name': 'Marie Diallo', 'email': 'm.diallo@email.com', 'phone': '+22501000004', 'dept': 'RH', 'pos': 'Manager RH', 'status': 'Inactif'},
      {'id': '5', 'name': 'Koffi N\'Guessan', 'email': 'k.nguessan@email.com', 'phone': '+22501000005', 'dept': 'Production', 'pos': 'Technicien', 'status': 'Actif'},
      {'id': '6', 'name': 'Alice Dubois', 'email': 'a.dubois@email.com', 'phone': '+22501000006', 'dept': 'Marketing', 'pos': 'Chargée Marketing', 'status': 'Actif'},
      {'id': '7', 'name': 'Paul Zadi', 'email': 'p.zadi@email.com', 'phone': '+22501000007', 'dept': 'IT', 'pos': 'Développeur', 'status': 'Actif'},
      {'id': '8', 'name': 'Emma Touré', 'email': 'e.toure@email.com', 'phone': '+22501000008', 'dept': 'Finance', 'pos': 'Comptable', 'status': 'Inactif'},
    ];
    _nextId = 9;
  }

  Future<void> _showForm({Map<String, String>? emp}) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => EmployeeFormDialog(employee: emp != null ? {
        'firstName': emp['name']?.split(' ').first ?? '',
        'lastName': emp['name']?.split(' ').last ?? '',
        'email': emp['email'],
        'phone': emp['phone'],
        'department': emp['dept'],
        'position': emp['pos'],
        'status': emp['status'],
      } : null),
    );
    if (result != null) {
      setState(() {
        if (emp != null) {
          final idx = _employees.indexWhere((e) => e['id'] == emp['id']);
          if (idx != -1) _employees[idx]['status'] = result['status'] ?? emp['status'];
        } else {
          _employees.add({'id': '${_nextId++}', 'name': '${result['firstName']} ${result['lastName']}', 'email': result['email'], 'phone': result['phone'], 'dept': result['department'], 'pos': result['position'], 'status': 'Actif'});
        }
      });
      NotificationService.success(context, emp != null ? '✏️ Employé modifié' : '✅ Employé ajouté');
    }
  }

  @override
  Widget build(BuildContext context) {
    final actifs = _employees.where((e) => e['status'] == 'Actif').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.people, color: AppColors.primary, size: 24)),
          const SizedBox(width: 12),
          Text('Gestion des Employés', style: Theme.of(context).textTheme.headlineMedium),
        ]),
        const SizedBox(height: 20),
        Row(children: [
          _kpi('Total', '${_employees.length}', AppColors.primary),
          const SizedBox(width: 10),
          _kpi('Actifs', '$actifs', AppColors.success),
          const SizedBox(width: 10),
          _kpi('Inactifs', '${_employees.length - actifs}', AppColors.error),
        ]),
        const SizedBox(height: 20),
        PremiumTable(
          title: 'Liste des Employés',
          subtitle: '${_employees.length} employés',
          columns: const [
            PremiumColumn(label: 'Employé', icon: Icons.person),
            PremiumColumn(label: 'Email', icon: Icons.email),
            PremiumColumn(label: 'Téléphone', icon: Icons.phone),
            PremiumColumn(label: 'Département', icon: Icons.business),
            PremiumColumn(label: 'Poste', icon: Icons.assignment),
            PremiumColumn(label: 'Statut'),
            PremiumColumn(label: 'Actions'),
          ],
          rows: _employees.map((e) {
            final initials = e['name']!.split(' ').map((n) => n[0]).join('');
            return PremiumRow(cells: [
              PremiumCell(widget: Row(children: [
                CircleAvatar(radius: 14, backgroundColor: AppColors.primary.withOpacity(0.1), child: Text(initials, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12))),
                const SizedBox(width: 8),
                Text(e['name']!, style: const TextStyle(fontWeight: FontWeight.w500)),
              ]), value: e['name']!),
              PremiumCell(widget: Text(e['email']!), value: e['email']!),
              PremiumCell(widget: Text(e['phone']!), value: e['phone']!),
              PremiumCell(widget: Text(e['dept']!), value: e['dept']!),
              PremiumCell(widget: Text(e['pos']!), value: e['pos']!),
              PremiumCell(widget: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: (e['status'] == 'Actif' ? AppColors.success : AppColors.error).withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Text(e['status']!, style: TextStyle(color: e['status'] == 'Actif' ? AppColors.success : AppColors.error, fontSize: 11, fontWeight: FontWeight.bold)),
              ), value: e['status']!),
              PremiumCell(widget: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(icon: const Icon(Icons.edit, size: 16, color: AppColors.secondary), onPressed: () => _showForm(emp: e)),
                IconButton(icon: const Icon(Icons.delete, size: 16, color: AppColors.error), onPressed: () {
                  setState(() => _employees.removeWhere((x) => x['id'] == e['id']));
                  NotificationService.error(context, '🗑️ ${e['name']} supprimé');
                }),
              ]), value: ''),
            ]);
          }).toList(),
          onAdd: () => _showForm(),
          onExport: () => NotificationService.info(context, '📥 Export employés en cours...'),
          onRefresh: () { setState(() => _loadData()); NotificationService.info(context, '🔄 Liste actualisée'); },
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
}
