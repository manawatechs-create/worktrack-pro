import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';

class ApparenceSettings extends StatefulWidget {
  const ApparenceSettings({super.key});
  @override
  State<ApparenceSettings> createState() => _ApparenceSettingsState();
}

class _ApparenceSettingsState extends State<ApparenceSettings> {
  bool _darkMode = false;
  String _themeColor = 'Bleu';
  String _font = 'Inter';
  String _density = 'Confortable';

  @override
  Widget build(BuildContext context) {
    final colors = ['Bleu', 'Vert', 'Rouge', 'Violet', 'Orange'];
    final colorMap = {'Bleu': Colors.blue, 'Vert': Colors.green, 'Rouge': Colors.red, 'Violet': Colors.purple, 'Orange': Colors.orange};

    return Scaffold(
      appBar: AppBar(title: const Text('🎨 Apparence'), backgroundColor: AppColors.primary),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _section('Mode d\'affichage'),
          SwitchListTile(title: const Text('🌙 Mode Sombre'), value: _darkMode, onChanged: (v) => setState(() => _darkMode = v)),
          const SizedBox(height: 16),
          _section('Couleur Principale'),
          const SizedBox(height: 12),
          Wrap(spacing: 12, children: colors.map((c) => GestureDetector(
            onTap: () => setState(() => _themeColor = c),
            child: Container(width: 50, height: 50, decoration: BoxDecoration(
              color: colorMap[c], shape: BoxShape.circle,
              border: Border.all(color: _themeColor == c ? Colors.black : Colors.transparent, width: 3),
            ), child: _themeColor == c ? const Icon(Icons.check, color: Colors.white) : null),
          )).toList()),
          const SizedBox(height: 24),
          _section('Typographie'),
          const SizedBox(height: 12),
          _dropdown('Police', _font, ['Inter', 'Poppins', 'Roboto', 'Open Sans'], (v) => _font = v!),
          const SizedBox(height: 12),
          _dropdown('Densité', _density, ['Compact', 'Confortable', 'Aéré'], (v) => _density = v!),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity, height: 50, child: ElevatedButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Apparence mise à jour'), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating)), icon: const Icon(Icons.save), label: const Text('Appliquer'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
        ]),
      ),
    );
  }

  Widget _section(String title) => Row(children: [Container(width: 4, height: 20, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))), const SizedBox(width: 8), Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]);

  Widget _dropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(value: value, items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(), onChanged: onChanged, decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))));
  }
}
