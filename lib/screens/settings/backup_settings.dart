import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';

class BackupSettings extends StatefulWidget {
  const BackupSettings({super.key});
  @override
  State<BackupSettings> createState() => _BackupSettingsState();
}

class _BackupSettingsState extends State<BackupSettings> {
  bool _autoBackup = true;
  String _frequence = 'Quotidienne';
  String _retention = '30 jours';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('💾 Sauvegarde'), backgroundColor: AppColors.primary),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _section('Sauvegarde Automatique'),
          SwitchListTile(title: const Text('Activer sauvegarde automatique'), value: _autoBackup, onChanged: (v) => setState(() => _autoBackup = v)),
          _dropdown('Fréquence', _frequence, ['Horaire', 'Quotidienne', 'Hebdomadaire', 'Mensuelle'], (v) => _frequence = v!),
          const SizedBox(height: 12),
          _dropdown('Rétention', _retention, ['7 jours', '30 jours', '90 jours', '1 an'], (v) => _retention = v!),
          const SizedBox(height: 24),
          _section('Actions Manuelles'),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, height: 50, child: ElevatedButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Sauvegarde en cours...'), backgroundColor: AppColors.info, behavior: SnackBarBehavior.floating)), icon: const Icon(Icons.backup), label: const Text('Sauvegarder maintenant'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, height: 50, child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.restore), label: const Text('Restaurer une sauvegarde'), style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
          const SizedBox(height: 24),
          _section('Historique'),
          ...List.generate(3, (i) => ListTile(
            leading: const Icon(Icons.check_circle, color: AppColors.success),
            title: Text('Sauvegarde ${['Quotidienne', 'Hebdomadaire', 'Mensuelle'][i]}'),
            subtitle: Text('${DateTime.now().subtract(Duration(days: i)).toString().split('.')[0]} - 2.3 MB'),
            trailing: const Icon(Icons.download),
          )),
        ]),
      ),
    );
  }

  Widget _section(String title) => Row(children: [Container(width: 4, height: 20, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))), const SizedBox(width: 8), Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]);

  Widget _dropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(value: value, items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(), onChanged: onChanged, decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))));
  }
}
