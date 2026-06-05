import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../utils/validators.dart';

class EmployeeFormDialog extends StatefulWidget {
  final Map<String, dynamic>? employee;
  const EmployeeFormDialog({super.key, this.employee});

  @override
  State<EmployeeFormDialog> createState() => _EmployeeFormDialogState();
}

class _EmployeeFormDialogState extends State<EmployeeFormDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controllers
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _matriculeCtrl = TextEditingController();

  // Dropdowns
  String _gender = 'M';
  String _department = 'Informatique';
  String _position = 'Développeur';
  String _contractType = 'CDI';
  String _status = 'Actif';
  DateTime _birthDate = DateTime(1990, 1, 1);
  DateTime _hireDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      _firstNameCtrl.text = widget.employee!['firstName'] ?? '';
      _lastNameCtrl.text = widget.employee!['lastName'] ?? '';
      _emailCtrl.text = widget.employee!['email'] ?? '';
      _phoneCtrl.text = widget.employee!['phone'] ?? '';
      _department = widget.employee!['department'] ?? 'Informatique';
      _position = widget.employee!['position'] ?? 'Développeur';
      _status = widget.employee!['status'] ?? 'Actif';
    }
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose(); _lastNameCtrl.dispose(); _emailCtrl.dispose();
    _phoneCtrl.dispose(); _addressCtrl.dispose(); _matriculeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.employee != null;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 650, maxHeight: 750),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            child: Row(children: [
              const Icon(Icons.person_add, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(isEdit ? 'Modifier l\'Employé' : 'Nouvel Employé', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const Text('Les champs * sont obligatoires', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ]),
            ]),
          ),
          // Formulaire
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(children: [
                  _sectionTitle('Informations Personnelles', Icons.person),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: _field('Prénom *', Icons.person, _firstNameCtrl, (v) => AppValidators.name(v, 'Le prénom'))),
                    const SizedBox(width: 12),
                    Expanded(child: _field('Nom *', Icons.person_outline, _lastNameCtrl, (v) => AppValidators.name(v, 'Le nom'))),
                  ]),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: _dropdown('Genre *', Icons.wc, _gender, ['M', 'F'], ['👨 Masculin', '👩 Féminin'], (v) => _gender = v!)),
                    const SizedBox(width: 12),
                    Expanded(child: _dateField('Date naissance *', Icons.cake, _birthDate, (v) => _birthDate = v)),
                  ]),
                  const SizedBox(height: 16),
                  
                  _sectionTitle('Coordonnées', Icons.contact_phone),
                  const SizedBox(height: 12),
                  _field('Email professionnel *', Icons.email, _emailCtrl, AppValidators.email, keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 12),
                  _field('Téléphone *', Icons.phone, _phoneCtrl, AppValidators.phone, keyboardType: TextInputType.phone),
                  const SizedBox(height: 12),
                  _field('Adresse', Icons.location_on, _addressCtrl, null, maxLines: 2),
                  const SizedBox(height: 16),
                  
                  _sectionTitle('Informations Professionnelles', Icons.work),
                  const SizedBox(height: 12),
                  _field('Matricule', Icons.badge, _matriculeCtrl, AppValidators.matricule),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: _dropdown('Département *', Icons.business, _department, ['Informatique', 'RH', 'Finance', 'Marketing', 'Direction', 'Production'], null, (v) => _department = v!)),
                    const SizedBox(width: 12),
                    Expanded(child: _dropdown('Poste *', Icons.assignment, _position, ['Développeur', 'Manager', 'Comptable', 'Assistant', 'Directeur', 'Technicien'], null, (v) => _position = v!)),
                  ]),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: _dropdown('Contrat *', Icons.article, _contractType, ['CDI', 'CDD', 'Stage', 'Freelance'], null, (v) => _contractType = v!)),
                    const SizedBox(width: 12),
                    Expanded(child: _dateField('Embauche *', Icons.today, _hireDate, (v) => _hireDate = v)),
                  ]),
                  if (isEdit) ...[
                    const SizedBox(height: 12),
                    _dropdown('Statut *', Icons.toggle_on, _status, ['Actif', 'Inactif', 'Suspendu'], null, (v) => _status = v!),
                  ],
                  const SizedBox(height: 24),
                  Row(children: [
                    Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: const Text('Annuler'))),
                    const SizedBox(width: 16),
                    Expanded(flex: 2, child: ElevatedButton(
                      onPressed: _isLoading ? null : () {
                        if (_formKey.currentState!.validate()) {
                          setState(() => _isLoading = true);
                          Future.delayed(const Duration(milliseconds: 500), () {
                            Navigator.pop(context, {'firstName': _firstNameCtrl.text, 'lastName': _lastNameCtrl.text, 'email': _emailCtrl.text, 'phone': _phoneCtrl.text, 'department': _department, 'position': _position, 'status': _status});
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      child: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text(isEdit ? 'Mettre à jour' : 'Enregistrer', style: const TextStyle(fontWeight: FontWeight.w600)),
                    )),
                  ]),
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Row(children: [
      Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(6)), child: Icon(icon, size: 16, color: AppColors.primary)),
      const SizedBox(width: 10),
      Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
    ]);
  }

  Widget _field(String label, IconData icon, TextEditingController ctrl, String? Function(String?)? validator, {TextInputType? keyboardType, int maxLines = 1}) {
    return TextFormField(
      controller: ctrl, keyboardType: keyboardType, maxLines: maxLines, validator: validator,
      decoration: InputDecoration(
        labelText: label, prefixIcon: Icon(icon, size: 18),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), isDense: true,
      ),
    );
  }

  Widget _dropdown(String label, IconData icon, String value, List<String> items, List<String>? labels, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value, items: items.asMap().entries.map((e) => DropdownMenuItem(value: e.value, child: Text(labels != null ? labels[e.key] : e.value))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, size: 18), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), isDense: true),
    );
  }

  Widget _dateField(String label, IconData icon, DateTime value, Function(DateTime) onChanged) {
    return InkWell(
      onTap: () async { final d = await showDatePicker(context: context, initialDate: value, firstDate: DateTime(1950), lastDate: DateTime(2100)); if (d != null) { onChanged(d); setState(() {}); } },
      child: InputDecorator(
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, size: 18), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), isDense: true, suffixIcon: const Icon(Icons.calendar_today, size: 16)),
        child: Text('${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}'),
      ),
    );
  }
}
