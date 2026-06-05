import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';

class RolePermissions extends StatefulWidget {
  const RolePermissions({super.key});
  @override
  State<RolePermissions> createState() => _RolePermissionsState();
}

class _RolePermissionsState extends State<RolePermissions> {
  String _selectedRole = 'Manager';
  
  final Map<String, Map<String, bool>> _permissions = {
    'Super Admin': {'dashboard': true, 'employees': true, 'presences': true, 'conges': true, 'reports': true, 'settings': true, 'admin': true},
    'Admin RH': {'dashboard': true, 'employees': true, 'presences': true, 'conges': true, 'reports': true, 'settings': false, 'admin': false},
    'Manager': {'dashboard': true, 'employees': true, 'presences': true, 'conges': true, 'reports': false, 'settings': false, 'admin': false},
    'Employé': {'dashboard': true, 'employees': false, 'presences': true, 'conges': true, 'reports': false, 'settings': false, 'admin': false},
    'Auditeur': {'dashboard': true, 'employees': false, 'presences': true, 'conges': false, 'reports': true, 'settings': false, 'admin': false},
  };

  final Map<String, IconData> _moduleIcons = {
    'dashboard': Icons.dashboard, 'employees': Icons.people, 'presences': Icons.check_circle,
    'conges': Icons.beach_access, 'reports': Icons.assessment, 'settings': Icons.settings, 'admin': Icons.admin_panel_settings,
  };

  @override
  Widget build(BuildContext context) {
    final perms = _permissions[_selectedRole]!;

    return Scaffold(
      appBar: AppBar(title: const Text('🔐 Rôles & Permissions'), backgroundColor: AppColors.sidebarColor),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Sélecteur de rôle
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                const Text('Rôle :', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedRole,
                    items: _permissions.keys.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                    onChanged: (v) => setState(() => _selectedRole = v!),
                    decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12)),
                  ),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          Text('Permissions du rôle $_selectedRole', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          ...perms.entries.map((e) => Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SwitchListTile(
              secondary: Icon(_moduleIcons[e.key]!, color: e.value ? AppColors.success : AppColors.textSecondary, size: 24),
              title: Text(_moduleName(e.key), style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(_moduleDesc(e.key), style: const TextStyle(fontSize: 12)),
              value: e.value,
              onChanged: (v) => setState(() => _permissions[_selectedRole]![e.key] = v),
              activeColor: AppColors.success,
            ),
          )),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, height: 48, child: ElevatedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Permissions enregistrées'), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating)),
            icon: const Icon(Icons.save), label: const Text('Enregistrer les permissions'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.sidebarColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          )),
        ]),
      ),
    );
  }

  String _moduleName(String key) {
    switch (key) {
      case 'dashboard': return 'Tableau de bord';
      case 'employees': return 'Employés';
      case 'presences': return 'Présences';
      case 'conges': return 'Congés';
      case 'reports': return 'Rapports';
      case 'settings': return 'Paramètres';
      case 'admin': return 'Administration';
      default: return key;
    }
  }

  String _moduleDesc(String key) {
    switch (key) {
      case 'dashboard': return 'Accès au tableau de bord principal';
      case 'employees': return 'Gestion des employés (CRUD)';
      case 'presences': return 'Suivi et pointage';
      case 'conges': return 'Gestion des congés et absences';
      case 'reports': return 'Génération de rapports';
      case 'settings': return 'Configuration du système';
      case 'admin': return 'Accès complet à l\'administration';
      default: return '';
    }
  }
}
