import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});
  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  List<Map<String, String>> _users = [];
  int _nextId = 1;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    _users = [
      {'id': '1', 'name': 'Nathanael Kouassi', 'email': 'admin@worktrack.pro', 'role': 'Super Admin', 'status': 'Actif', 'lastLogin': 'Aujourd\'hui 08:30'},
      {'id': '2', 'name': 'Awa Koné', 'email': 'manager@worktrack.pro', 'role': 'Manager', 'status': 'Actif', 'lastLogin': 'Hier 17:45'},
      {'id': '3', 'name': 'Jean Yao', 'email': 'jean@worktrack.pro', 'role': 'Employé', 'status': 'Actif', 'lastLogin': '05/06/2026'},
      {'id': '4', 'name': 'Marie Diallo', 'email': 'marie@worktrack.pro', 'role': 'Employé', 'status': 'Inactif', 'lastLogin': 'Jamais'},
    ];
    _nextId = 5;
  }

  void _showUserDialog({Map<String, String>? user}) {
    final isEdit = user != null;
    final nameCtrl = TextEditingController(text: user?['name'] ?? '');
    final emailCtrl = TextEditingController(text: user?['email'] ?? '');
    String role = user?['role'] ?? 'Employé';
    String status = user?['status'] ?? 'Actif';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) => AlertDialog(
          title: Text(isEdit ? 'Modifier Utilisateur' : 'Nouvel Utilisateur', style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nom complet', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            DropdownButtonFormField(value: role, items: ['Super Admin', 'Admin RH', 'Manager', 'Employé', 'Auditeur'].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(), onChanged: (v) => setDlg(() => role = v!), decoration: const InputDecoration(labelText: 'Rôle', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            DropdownButtonFormField(value: status, items: ['Actif', 'Inactif', 'Suspendu'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(), onChanged: (v) => setDlg(() => status = v!), decoration: const InputDecoration(labelText: 'Statut', border: OutlineInputBorder())),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
            ElevatedButton(
              onPressed: () {
                final name = nameCtrl.text;
                final email = emailCtrl.text;
                final lastLogin = user?['lastLogin'] ?? 'Jamais';
                if (isEdit) {
                  final idx = _users.indexWhere((u) => u['id'] == user!['id']);
                  if (idx != -1) {
                    _users[idx] = {'id': user['id']!, 'name': name, 'email': email, 'role': role, 'status': status, 'lastLogin': lastLogin};
                  }
                } else {
                  _users.add({'id': '${_nextId++}', 'name': name, 'email': email, 'role': role, 'status': status, 'lastLogin': 'Jamais'});
                }
                setState(() {});
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isEdit ? '✅ Utilisateur modifié' : '✅ Utilisateur créé'), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating));
              },
              child: Text(isEdit ? 'Modifier' : 'Créer'),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleStatus(Map<String, String> user) {
    final newStatus = user['status'] == 'Actif' ? 'Inactif' : 'Actif';
    final idx = _users.indexWhere((u) => u['id'] == user['id']);
    if (idx != -1) {
      setState(() => _users[idx]['status'] = newStatus);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${user['name']} → $newStatus'), behavior: SnackBarBehavior.floating));
    }
  }

  void _resetPassword(Map<String, String> user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Réinitialiser mot de passe'),
        content: Text('Générer un nouveau mot de passe pour ${user['name']} ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          ElevatedButton(onPressed: () { Navigator.pop(ctx); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('🔑 Nouveau mot de passe envoyé à ${user['email']}'), behavior: SnackBarBehavior.floating)); }, child: const Text('Réinitialiser')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('👥 Gestion Utilisateurs'), backgroundColor: AppColors.sidebarColor),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('${_users.length} utilisateurs', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ElevatedButton.icon(onPressed: () => _showUserDialog(), icon: const Icon(Icons.add, size: 18), label: const Text('Ajouter'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.sidebarColor)),
          ]),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(columns: const [
                DataColumn(label: Text('Utilisateur')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Rôle')),
                DataColumn(label: Text('Statut')),
                DataColumn(label: Text('Dernière connexion')),
                DataColumn(label: Text('Actions')),
              ], rows: _users.map((u) => DataRow(cells: [
                DataCell(Text(u['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.w500))),
                DataCell(Text(u['email'] ?? '')),
                DataCell(Text(u['role'] ?? '')),
                DataCell(Switch(value: u['status'] == 'Actif', onChanged: (_) => _toggleStatus(u), activeColor: AppColors.success)),
                DataCell(Text(u['lastLogin'] ?? '', style: TextStyle(fontSize: 12, color: AppColors.textSecondary))),
                DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(icon: const Icon(Icons.edit, size: 18, color: AppColors.primary), onPressed: () => _showUserDialog(user: u)),
                  IconButton(icon: const Icon(Icons.lock_reset, size: 18, color: AppColors.warning), onPressed: () => _resetPassword(u)),
                ])),
              ])).toList()),
            ),
          ),
        ]),
      ),
    );
  }
}
