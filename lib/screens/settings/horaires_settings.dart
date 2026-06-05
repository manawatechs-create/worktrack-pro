import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';

class HorairesSettings extends StatefulWidget {
  const HorairesSettings({super.key});

  @override
  State<HorairesSettings> createState() => _HorairesSettingsState();
}

class _HorairesSettingsState extends State<HorairesSettings> {
  String _horaireType = 'Fixe';
  TimeOfDay _debutMatin = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _finMatin = const TimeOfDay(hour: 12, minute: 0);
  TimeOfDay _debutAprem = const TimeOfDay(hour: 14, minute: 0);
  TimeOfDay _finAprem = const TimeOfDay(hour: 17, minute: 0);
  int _toleranceRetard = 15;
  bool _samediTravail = false;
  bool _dimancheTravail = false;
  List<String> _joursFeries = ['01/01', '01/05', '25/12'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🕐 Horaires & Plannings'), backgroundColor: AppColors.primary),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _sectionTitle('Type d\'Horaire'),
          const SizedBox(height: 12),
          Row(children: [
            _horaireTypeCard('Fixe', '08:00 - 17:00', Icons.lock, _horaireType == 'Fixe', () => setState(() => _horaireType = 'Fixe')),
            const SizedBox(width: 12),
            _horaireTypeCard('Flexible', 'Plage variable', Icons.auto_fix_high, _horaireType == 'Flexible', () => setState(() => _horaireType = 'Flexible')),
            const SizedBox(width: 12),
            _horaireTypeCard('Équipes', 'Rotation', Icons.swap_horiz, _horaireType == 'Équipes', () => setState(() => _horaireType = 'Équipes')),
          ]),
          const SizedBox(height: 24),

          _sectionTitle('Plages Horaires'),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                Row(children: [
                  Expanded(child: _timeField('Début matin', _debutMatin, (t) => setState(() => _debutMatin = t))),
                  const SizedBox(width: 12),
                  Expanded(child: _timeField('Fin matin', _finMatin, (t) => setState(() => _finMatin = t))),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: _timeField('Début aprèm', _debutAprem, (t) => setState(() => _debutAprem = t))),
                  const SizedBox(width: 12),
                  Expanded(child: _timeField('Fin aprèm', _finAprem, (t) => setState(() => _finAprem = t))),
                ]),
              ]),
            ),
          ),
          const SizedBox(height: 24),

          _sectionTitle('Tolérance de Retard'),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                const Text('Tolérance:'),
                Expanded(
                  child: Slider(value: _toleranceRetard.toDouble(), min: 0, max: 60, divisions: 12, label: '$_toleranceRetard min', onChanged: (v) => setState(() => _toleranceRetard = v.round())),
                ),
                Text('$_toleranceRetard min', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ]),
            ),
          ),
          const SizedBox(height: 24),

          _sectionTitle('Jours Travaillés'),
          const SizedBox(height: 12),
          SwitchListTile(title: const Text('Samedi travaillé'), value: _samediTravail, onChanged: (v) => setState(() => _samediTravail = v)),
          SwitchListTile(title: const Text('Dimanche travaillé'), value: _dimancheTravail, onChanged: (v) => setState(() => _dimancheTravail = v)),
          const SizedBox(height: 24),

          _sectionTitle('Jours Fériés'),
          const SizedBox(height: 12),
          Card(
            child: Column(children: [
              ..._joursFeries.map((date) => ListTile(
                leading: const Icon(Icons.today, color: AppColors.primary),
                title: Text(date),
                trailing: IconButton(icon: const Icon(Icons.delete, color: AppColors.error), onPressed: () => setState(() => _joursFeries.remove(date))),
              )),
              ListTile(
                leading: const Icon(Icons.add, color: AppColors.success),
                title: const Text('Ajouter un jour férié'),
                onTap: () {
                  setState(() => _joursFeries.add('01/08'));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Jour férié ajouté'), behavior: SnackBarBehavior.floating));
                },
              ),
            ]),
          ),
          const SizedBox(height: 24),

          SizedBox(width: double.infinity, height: 50, child: ElevatedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Horaires enregistrés'), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating)),
            icon: const Icon(Icons.save), label: const Text('Enregistrer'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          )),
        ]),
      ),
    );
  }

  Widget _sectionTitle(String title) => Row(children: [
    Container(width: 4, height: 20, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
    const SizedBox(width: 8),
    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
  ]);

  Widget _horaireTypeCard(String title, String subtitle, IconData icon, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selected ? AppColors.primary : AppColors.border, width: 2),
          ),
          child: Column(children: [
            Icon(icon, color: selected ? AppColors.primary : AppColors.textSecondary, size: 32),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: selected ? AppColors.primary : AppColors.textPrimary)),
            Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ]),
        ),
      ),
    );
  }

  Widget _timeField(String label, TimeOfDay value, Function(TimeOfDay) onChanged) {
    return InkWell(
      onTap: () async {
        final t = await showTimePicker(context: context, initialTime: value);
        if (t != null) onChanged(t);
      },
      child: InputDecorator(
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), suffixIcon: const Icon(Icons.access_time)),
        child: Text('${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}'),
      ),
    );
  }
}
