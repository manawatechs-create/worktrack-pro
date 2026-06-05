import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';

class NotificationsSettings extends StatefulWidget {
  const NotificationsSettings({super.key});
  @override
  State<NotificationsSettings> createState() => _NotificationsSettingsState();
}

class _NotificationsSettingsState extends State<NotificationsSettings> {
  bool _emailNotif = true, _smsNotif = false, _pushNotif = true;
  bool _retardNotif = true, _absenceNotif = true, _congeNotif = true, _validationNotif = true;
  String _emailTemplate = 'Standard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🔔 Notifications'), backgroundColor: AppColors.primary),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _section('Canaux'),
          SwitchListTile(title: const Text('📧 Notifications Email'), value: _emailNotif, onChanged: (v) => setState(() => _emailNotif = v)),
          SwitchListTile(title: const Text('📱 Notifications SMS'), value: _smsNotif, onChanged: (v) => setState(() => _smsNotif = v)),
          SwitchListTile(title: const Text('🔔 Notifications Push'), value: _pushNotif, onChanged: (v) => setState(() => _pushNotif = v)),
          const SizedBox(height: 16),
          _section('Événements'),
          SwitchListTile(title: const Text('⚠️ Alerte Retard'), subtitle: const Text('Notifier en cas de retard'), value: _retardNotif, onChanged: (v) => setState(() => _retardNotif = v)),
          SwitchListTile(title: const Text('❌ Alerte Absence'), value: _absenceNotif, onChanged: (v) => setState(() => _absenceNotif = v)),
          SwitchListTile(title: const Text('🏖️ Demande Congé'), value: _congeNotif, onChanged: (v) => setState(() => _congeNotif = v)),
          SwitchListTile(title: const Text('✅ Validation'), value: _validationNotif, onChanged: (v) => setState(() => _validationNotif = v)),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity, height: 50, child: ElevatedButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Notifications enregistrées'), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating)), icon: const Icon(Icons.save), label: const Text('Enregistrer'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
        ]),
      ),
    );
  }

  Widget _section(String title) => Row(children: [Container(width: 4, height: 20, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))), const SizedBox(width: 8), Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]);
}
