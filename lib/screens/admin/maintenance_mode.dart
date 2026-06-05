import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';

class MaintenanceMode extends StatefulWidget {
  const MaintenanceMode({super.key});
  @override
  State<MaintenanceMode> createState() => _MaintenanceModeState();
}

class _MaintenanceModeState extends State<MaintenanceMode> {
  bool _maintenanceMode = false;
  String _message = 'Le système est en maintenance. Veuillez réessayer plus tard.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🔧 Maintenance'), backgroundColor: AppColors.sidebarColor),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Mode maintenance
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            color: _maintenanceMode ? AppColors.error.withOpacity(0.05) : null,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Icon(_maintenanceMode ? Icons.warning : Icons.check_circle, color: _maintenanceMode ? AppColors.error : AppColors.success, size: 28),
                  const SizedBox(width: 12),
                  Expanded(child: Text(_maintenanceMode ? '⚠️ Mode Maintenance ACTIVÉ' : '✅ Système en fonctionnement normal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _maintenanceMode ? AppColors.error : AppColors.success))),
                  Switch(value: _maintenanceMode, onChanged: (v) => setState(() => _maintenanceMode = v), activeColor: AppColors.error),
                ]),
                if (_maintenanceMode) ...[
                  const SizedBox(height: 16),
                  TextField(
                    controller: TextEditingController(text: _message),
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Message de maintenance', border: OutlineInputBorder()),
                    onChanged: (v) => _message = v,
                  ),
                ],
              ]),
            ),
          ),
          const SizedBox(height: 20),

          // Actions
          Text('Actions de Maintenance', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          _actionTile('🗑️ Vider le cache', 'Nettoyer le cache applicatif', () => _confirmAction('Vider le cache ?')),
          _actionTile('📊 Régénérer les rapports', 'Recalculer toutes les statistiques', () => _confirmAction('Régénérer tous les rapports ?')),
          _actionTile('🔄 Redémarrer les services', 'Redémarrer les services backend', () => _confirmAction('Redémarrer les services ?')),
          _actionTile('📧 Tester l\'envoi d\'emails', 'Envoyer un email de test', () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('📧 Email de test envoyé'), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating))),
        ]),
      ),
    );
  }

  Widget _actionTile(String title, String subtitle, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)), subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)), trailing: const Icon(Icons.chevron_right), onTap: onTap),
    );
  }

  void _confirmAction(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmer'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          ElevatedButton(onPressed: () { Navigator.pop(ctx); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Action exécutée'), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating)); }, child: const Text('Confirmer')),
        ],
      ),
    );
  }
}
