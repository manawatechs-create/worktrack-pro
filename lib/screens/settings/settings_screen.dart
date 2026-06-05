import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import 'entreprise_settings.dart';
import 'horaires_settings.dart';
import 'notifications_settings.dart';
import 'securite_settings.dart';
import 'apparence_settings.dart';
import 'backup_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.settings, color: AppColors.primary, size: 28)),
          const SizedBox(width: 16),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Paramètres du Système', style: Theme.of(context).textTheme.headlineMedium),
            const Text('Configuration avancée', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          ]),
        ]),
        const SizedBox(height: 24),
        _menuItem('🏢 Informations Entreprise', 'Nom, logo, adresse', Icons.business, Colors.blue, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EntrepriseSettings()))),
        _menuItem('🕐 Horaires & Jours Fériés', 'Heures, plages, jours fériés', Icons.schedule, Colors.green, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HorairesSettings()))),
        _menuItem('🔔 Notifications & Alertes', 'Email, SMS, Push', Icons.notifications_active, Colors.orange, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsSettings()))),
        _menuItem('🔒 Sécurité & Authentification', '2FA, SSO, politiques', Icons.security, Colors.red, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SecuriteSettings()))),
        _menuItem('🎨 Apparence & Thème', 'Couleurs, mode sombre', Icons.palette, Colors.purple, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ApparenceSettings()))),
        _menuItem('💾 Sauvegarde & Restauration', 'Backup, export, logs', Icons.backup, Colors.teal, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BackupSettings()))),
        _menuItem('📧 Configuration Email', 'SMTP, templates', Icons.email, Colors.indigo, _showComingSoon),
        _menuItem('🔌 Intégrations & API', 'Webhooks, API keys', Icons.api, Colors.cyan, _showComingSoon),
        _menuItem('👥 Rôles & Permissions', 'Accès et autorisations', Icons.admin_panel_settings, Colors.amber, _showComingSoon),
        _menuItem('📊 Rapports Automatiques', 'Planification', Icons.auto_graph, Colors.deepOrange, _showComingSoon),
      ]),
    );
  }

  Widget _menuItem(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 24)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 13)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🚧 Module en développement'), behavior: SnackBarBehavior.floating));
  }
}
