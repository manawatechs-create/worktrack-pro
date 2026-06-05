import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';

class SystemLogs extends StatefulWidget {
  const SystemLogs({super.key});
  @override
  State<SystemLogs> createState() => _SystemLogsState();
}

class _SystemLogsState extends State<SystemLogs> {
  String _filter = 'Tous';
  String _search = '';

  final List<Map<String, String>> _logs = [
    {'date': '05/06/2026 08:30', 'user': 'Admin', 'action': 'Connexion', 'type': 'Info', 'details': 'Connexion réussie depuis IP 192.168.1.1'},
    {'date': '05/06/2026 08:15', 'user': 'Système', 'action': 'Backup', 'type': 'Succès', 'details': 'Sauvegarde automatique terminée (2.3 MB)'},
    {'date': '05/06/2026 07:55', 'user': 'Jean Yao', 'action': 'Pointage', 'type': 'Info', 'details': 'Pointage entrée - Méthode QR Code'},
    {'date': '04/06/2026 17:30', 'user': 'Awa Koné', 'action': 'Validation', 'type': 'Succès', 'details': 'Congé validé pour Marie Diallo'},
    {'date': '04/06/2026 14:20', 'user': 'Système', 'action': 'Erreur', 'type': 'Erreur', 'details': 'Tentative de connexion échouée IP 10.0.0.5'},
    {'date': '04/06/2026 09:00', 'user': 'Admin', 'action': 'Modification', 'type': 'Info', 'details': 'Paramètres entreprise modifiés'},
  ];

  List<Map<String, String>> get _filtered => _logs.where((l) {
    if (_filter != 'Tous' && l['type'] != _filter) return false;
    if (_search.isNotEmpty && !l['details']!.toLowerCase().contains(_search.toLowerCase())) return false;
    return true;
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📋 Logs Système'), backgroundColor: AppColors.sidebarColor),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: TextField(
              decoration: const InputDecoration(hintText: 'Rechercher dans les logs...', prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),
              onChanged: (v) => setState(() => _search = v),
            )),
            const SizedBox(width: 12),
            SizedBox(width: 180, child: DropdownButtonFormField<String>(
              value: _filter, items: ['Tous', 'Info', 'Succès', 'Erreur'].map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
              onChanged: (v) => setState(() => _filter = v!),
              decoration: const InputDecoration(labelText: 'Filtre', border: OutlineInputBorder()),
            )),
          ]),
          const SizedBox(height: 16),
          Text('${_filtered.length} logs', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(columns: const [
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Utilisateur')),
                DataColumn(label: Text('Action')),
                DataColumn(label: Text('Type')),
                DataColumn(label: Text('Détails')),
              ], rows: _filtered.map((l) {
                Color c = l['type'] == 'Erreur' ? AppColors.error : l['type'] == 'Succès' ? AppColors.success : AppColors.info;
                return DataRow(cells: [
                  DataCell(Text(l['date']!, style: const TextStyle(fontSize: 12))),
                  DataCell(Text(l['user']!, style: const TextStyle(fontWeight: FontWeight.w500))),
                  DataCell(Text(l['action']!)),
                  DataCell(Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Text(l['type']!, style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.bold)))),
                  DataCell(Text(l['details']!, style: const TextStyle(fontSize: 12))),
                ]);
              }).toList()),
            ),
          ),
        ]),
      ),
    );
  }
}
