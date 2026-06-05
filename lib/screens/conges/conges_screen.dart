import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';

class Conge {
  String id;
  String employeeName;
  String type;
  DateTime dateDebut;
  DateTime dateFin;
  String motif;
  String statut; // en_attente, valide, refuse
  int jours;

  Conge({
    required this.id,
    required this.employeeName,
    required this.type,
    required this.dateDebut,
    required this.dateFin,
    required this.motif,
    this.statut = 'en_attente',
  }) : jours = dateFin.difference(dateDebut).inDays + 1;
}

class CongesScreen extends StatefulWidget {
  const CongesScreen({super.key});

  @override
  State<CongesScreen> createState() => _CongesScreenState();
}

class _CongesScreenState extends State<CongesScreen> {
  List<Conge> _conges = [];
  int _nextId = 1;
  String _filter = 'tous'; // tous, en_attente, valide, refuse

  final _typesConge = ['Annuel', 'Maladie', 'Maternité', 'Paternité', 'Exceptionnel', 'Sans solde'];

  @override
  void initState() {
    super.initState();
    _loadDemoData();
  }

  void _loadDemoData() {
    _conges = [
      Conge(id: '1', employeeName: 'Jean Dupont', type: 'Annuel', dateDebut: DateTime(2026, 6, 10), dateFin: DateTime(2026, 6, 25), motif: 'Vacances famille', statut: 'en_attente'),
      Conge(id: '2', employeeName: 'Marie Martin', type: 'Maladie', dateDebut: DateTime(2026, 6, 5), dateFin: DateTime(2026, 6, 7), motif: 'Consultation médicale', statut: 'valide'),
      Conge(id: '3', employeeName: 'Pierre Durand', type: 'Annuel', dateDebut: DateTime(2026, 7, 1), dateFin: DateTime(2026, 7, 15), motif: 'Voyage', statut: 'refuse'),
    ];
    _nextId = 4;
  }

  List<Conge> get _filteredConges {
    if (_filter == 'tous') return _conges;
    return _conges.where((c) => c.statut == _filter).toList();
  }

  int get _soldeAnnuel => 25;
  int get _soldeUtilise => _conges.where((c) => c.type == 'Annuel' && c.statut == 'valide').fold(0, (sum, c) => sum + c.jours);
  int get _soldeRestant => _soldeAnnuel - _soldeUtilise;

  void _showCongeDialog({Conge? conge}) {
    final isEdit = conge != null;
    final formKey = GlobalKey<FormState>();
    String employeeName = conge?.employeeName ?? '';
    String type = conge?.type ?? 'Annuel';
    DateTime dateDebut = conge?.dateDebut ?? DateTime.now();
    DateTime dateFin = conge?.dateFin ?? DateTime.now().add(const Duration(days: 5));
    String motif = conge?.motif ?? '';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEdit ? 'Modifier Congé' : 'Nouvelle Demande de Congé', style: const TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextFormField(
                  initialValue: employeeName,
                  decoration: const InputDecoration(labelText: 'Nom de l\'employé', border: OutlineInputBorder()),
                  validator: (v) => v?.isEmpty == true ? 'Requis' : null,
                  onChanged: (v) => employeeName = v,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: type,
                  decoration: const InputDecoration(labelText: 'Type de congé', border: OutlineInputBorder()),
                  items: _typesConge.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                  onChanged: (v) => setDialogState(() => type = v!),
                ),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final date = await showDatePicker(context: context, initialDate: dateDebut, firstDate: DateTime.now(), lastDate: DateTime(2027));
                        if (date != null) setDialogState(() => dateDebut = date);
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'Date début', border: OutlineInputBorder()),
                        child: Text('${dateDebut.day}/${dateDebut.month}/${dateDebut.year}'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final date = await showDatePicker(context: context, initialDate: dateFin, firstDate: dateDebut, lastDate: DateTime(2027));
                        if (date != null) setDialogState(() => dateFin = date);
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'Date fin', border: OutlineInputBorder()),
                        child: Text('${dateFin.day}/${dateFin.month}/${dateFin.year}'),
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: motif,
                  decoration: const InputDecoration(labelText: 'Motif', border: OutlineInputBorder()),
                  maxLines: 2,
                  onChanged: (v) => motif = v,
                ),
                if (dateFin.isBefore(dateDebut))
                  const Padding(padding: EdgeInsets.only(top: 8), child: Text('La date de fin doit être après la date de début', style: TextStyle(color: Colors.red, fontSize: 12))),
              ]),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate() && !dateFin.isBefore(dateDebut)) {
                  if (isEdit) {
                    final index = _conges.indexWhere((c) => c.id == conge.id);
                    if (index != -1) {
                      _conges[index] = Conge(id: conge.id, employeeName: employeeName, type: type, dateDebut: dateDebut, dateFin: dateFin, motif: motif, statut: conge.statut);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Congé modifié'), backgroundColor: Colors.green));
                  } else {
                    _conges.add(Conge(id: (_nextId++).toString(), employeeName: employeeName, type: type, dateDebut: dateDebut, dateFin: dateFin, motif: motif));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Demande de congé ajoutée'), backgroundColor: Colors.green));
                  }
                  setState(() {});
                  Navigator.pop(context);
                }
              },
              child: Text(isEdit ? 'Modifier' : 'Demander'),
            ),
          ],
        ),
      ),
    );
  }

  void _validerConge(Conge conge, String statut) {
    setState(() {
      final index = _conges.indexWhere((c) => c.id == conge.id);
      if (index != -1) _conges[index].statut = statut;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(statut == 'valide' ? 'Congé validé' : 'Congé refusé'),
      backgroundColor: statut == 'valide' ? Colors.green : Colors.red,
    ));
  }

  void _deleteConge(Conge conge) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer'),
        content: Text('Supprimer la demande de ${conge.employeeName} ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () { setState(() => _conges.removeWhere((c) => c.id == conge.id)); Navigator.pop(context); },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Gestion des Congés', style: Theme.of(context).textTheme.headlineMedium),
          ElevatedButton.icon(
            onPressed: () => _showCongeDialog(),
            icon: const Icon(Icons.add),
            label: const Text('Nouvelle demande'),
          ),
        ]),
        const SizedBox(height: 16),

        // Soldes
        Row(children: [
          _soldeCard('Solde Annuel', '$_soldeAnnuel jours', Icons.beach_access, AppColors.primary),
          const SizedBox(width: 12),
          _soldeCard('Utilisés', '$_soldeUtilise jours', Icons.trending_down, AppColors.warning),
          const SizedBox(width: 12),
          _soldeCard('Restants', '$_soldeRestant jours', Icons.trending_up, AppColors.success),
        ]),
        const SizedBox(height: 16),

        // Filtres
        Row(children: [
          _filterChip('Tous', 'tous'),
          const SizedBox(width: 8),
          _filterChip('En attente', 'en_attente'),
          const SizedBox(width: 8),
          _filterChip('Validés', 'valide'),
          const SizedBox(width: 8),
          _filterChip('Refusés', 'refuse'),
        ]),
        const SizedBox(height: 16),

        // Tableau
        Card(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Employé')),
                DataColumn(label: Text('Type')),
                DataColumn(label: Text('Du')),
                DataColumn(label: Text('Au')),
                DataColumn(label: Text('Jours')),
                DataColumn(label: Text('Motif')),
                DataColumn(label: Text('Statut')),
                DataColumn(label: Text('Actions')),
              ],
              rows: _filteredConges.map((c) {
                Color statutColor;
                switch (c.statut) {
                  case 'valide': statutColor = AppColors.success; break;
                  case 'refuse': statutColor = AppColors.error; break;
                  default: statutColor = AppColors.warning;
                }
                final statutLabel = c.statut == 'en_attente' ? 'En attente' : c.statut == 'valide' ? 'Validé' : 'Refusé';
                
                return DataRow(cells: [
                  DataCell(Text(c.employeeName, style: const TextStyle(fontWeight: FontWeight.w500))),
                  DataCell(Text(c.type)),
                  DataCell(Text('${c.dateDebut.day}/${c.dateDebut.month}/${c.dateDebut.year}')),
                  DataCell(Text('${c.dateFin.day}/${c.dateFin.month}/${c.dateFin.year}')),
                  DataCell(Text('${c.jours}j')),
                  DataCell(Text(c.motif.length > 20 ? '${c.motif.substring(0, 20)}...' : c.motif)),
                  DataCell(Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: statutColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: Text(statutLabel, style: TextStyle(color: statutColor, fontSize: 11, fontWeight: FontWeight.bold)),
                  )),
                  DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
                    if (c.statut == 'en_attente') ...[
                      IconButton(icon: const Icon(Icons.check, color: AppColors.success, size: 18), onPressed: () => _validerConge(c, 'valide'), tooltip: 'Valider'),
                      IconButton(icon: const Icon(Icons.close, color: AppColors.error, size: 18), onPressed: () => _validerConge(c, 'refuse'), tooltip: 'Refuser'),
                    ],
                    IconButton(icon: const Icon(Icons.edit, color: AppColors.secondary, size: 18), onPressed: () => _showCongeDialog(conge: c), tooltip: 'Modifier'),
                    IconButton(icon: const Icon(Icons.delete, color: AppColors.error, size: 18), onPressed: () => _deleteConge(c), tooltip: 'Supprimer'),
                  ])),
                ]);
              }).toList(),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _soldeCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
              Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ]),
          ]),
        ),
      ),
    );
  }

  Widget _filterChip(String label, String value) {
    final selected = _filter == value;
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => setState(() => _filter = value),
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
    );
  }
}
