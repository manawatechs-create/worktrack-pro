import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import 'user_management.dart';
import 'role_permissions.dart';
import 'system_logs.dart';
import 'database_management.dart';
import 'maintenance_mode.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});
  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final Map<String, String> _systemInfo = {
    'version': '3.44.1', 'uptime': '15j 7h 32min', 'cpu': '34%',
    'memory': '2.1 GB / 8 GB', 'disk': '45 GB / 120 GB',
    'database': 'PostgreSQL 15', 'users': '50',
    'active_sessions': '12', 'last_backup': 'Il y a 2 heures',
  };

  void _navigate(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.sidebarColor.withOpacity(0.1), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.admin_panel_settings, color: AppColors.sidebarColor, size: 28)),
          const SizedBox(width: 16),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Administration Système', style: Theme.of(context).textTheme.headlineMedium),
            const Text('Gestion avancée du système', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          ]),
        ]),
        const SizedBox(height: 24),

        // État système
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [const Icon(Icons.monitor_heart, color: AppColors.success), const SizedBox(width: 8), Text('État du Système', style: Theme.of(context).textTheme.titleLarge)]),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 4, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 2.5, mainAxisSpacing: 12, crossAxisSpacing: 12,
                children: _systemInfo.entries.map((e) => _sysStat(e.key.replaceAll('_', ' '), e.value)).toList(),
              ),
            ]),
          ),
        ),
        const SizedBox(height: 24),

        // Outils
        Text('Outils d\'Administration', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 3, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.3,
          children: [
            _tool('👥 Gestion Utilisateurs', 'Créer, modifier, désactiver', Icons.people, AppColors.primary, () => _navigate(const UserManagement())),
            _tool('🔐 Rôles & Permissions', 'Configurer les accès', Icons.security, AppColors.success, () => _navigate(const RolePermissions())),
            _tool('📋 Logs Système', 'Journal d\'activité', Icons.history, AppColors.info, () => _navigate(const SystemLogs())),
            _tool('🗄️ Base de Données', 'Sauvegarde, optimisation', Icons.storage, AppColors.warning, () => _navigate(const DatabaseManagement())),
            _tool('🔧 Maintenance', 'Mode maintenance', Icons.build, AppColors.error, () => _navigate(const MaintenanceMode())),
            _tool('📊 Métriques', 'Statistiques système', Icons.analytics, AppColors.secondary, () {}),
          ],
        ),
      ]),
    );
  }

  Widget _sysStat(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.03), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ]),
    );
  }

  Widget _tool(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap, borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 32)),
            const SizedBox(height: 14),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), textAlign: TextAlign.center),
          ]),
        ),
      ),
    );
  }
}
