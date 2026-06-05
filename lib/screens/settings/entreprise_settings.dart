import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';

class EntrepriseSettings extends StatefulWidget {
  const EntrepriseSettings({super.key});
  @override
  State<EntrepriseSettings> createState() => _EntrepriseSettingsState();
}

class _EntrepriseSettingsState extends State<EntrepriseSettings> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController(text: 'Friendly HR');
  final _emailCtrl = TextEditingController(text: 'contact@friendlyhr.com');
  final _phoneCtrl = TextEditingController(text: '+2250100000000');
  final _addressCtrl = TextEditingController(text: 'Abidjan, Cocody');
  final _siretCtrl = TextEditingController(text: '123456789');
  String _secteur = 'Technologie';
  String _taille = '50-100';
  String _pays = "Côte d'Ivoire";
  String _devise = 'FCFA';
  String _fuseau = 'UTC+0';
  String _langue = 'Français';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose(); _phoneCtrl.dispose();
    _addressCtrl.dispose(); _siretCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🏢 Informations Entreprise'), backgroundColor: AppColors.primary),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(
              child: Container(width: 100, height: 100, decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(20)), child: const Icon(Icons.business, size: 50, color: AppColors.primary)),
            ),
            const SizedBox(height: 24),
            _section('Informations Générales'),
            const SizedBox(height: 12),
            _field('Nom entreprise *', Icons.business, _nameCtrl, (v) => v?.isEmpty == true ? 'Requis' : null),
            const SizedBox(height: 12),
            _field('Email *', Icons.email, _emailCtrl, (v) => v?.isEmpty == true ? 'Requis' : v?.contains('@') != true ? 'Email invalide' : null),
            const SizedBox(height: 12),
            _field('Téléphone', Icons.phone, _phoneCtrl, null),
            const SizedBox(height: 12),
            _field('Adresse', Icons.location_on, _addressCtrl, null),
            const SizedBox(height: 12),
            _field('SIRET', Icons.description, _siretCtrl, null),
            const SizedBox(height: 24),
            _section('Classification'),
            const SizedBox(height: 12),
            _dropdown('Secteur', _secteur, ['Technologie', 'Finance', 'Santé', 'Éducation', 'Industrie'], (v) => setState(() => _secteur = v!)),
            const SizedBox(height: 12),
            _dropdown('Taille', _taille, ['1-10', '10-50', '50-100', '100-500', '500+'], (v) => setState(() => _taille = v!)),
            const SizedBox(height: 24),
            _section('Région'),
            const SizedBox(height: 12),
            _dropdown('Pays', _pays, ["Côte d'Ivoire", 'Sénégal', 'Mali', 'France'], (v) => setState(() => _pays = v!)),
            const SizedBox(height: 12),
            _dropdown('Devise', _devise, ['FCFA', 'EUR', 'USD'], (v) => setState(() => _devise = v!)),
            const SizedBox(height: 12),
            _dropdown('Fuseau horaire', _fuseau, ['UTC+0', 'UTC+1', 'UTC+2'], (v) => setState(() => _fuseau = v!)),
            const SizedBox(height: 12),
            _dropdown('Langue', _langue, ['Français', 'English', 'Español'], (v) => setState(() => _langue = v!)),
            const SizedBox(height: 32),
            SizedBox(width: double.infinity, height: 50, child: ElevatedButton.icon(
              onPressed: _isLoading ? null : () {
                if (_formKey.currentState!.validate()) {
                  setState(() => _isLoading = true);
                  Future.delayed(const Duration(seconds: 1), () {
                    setState(() => _isLoading = false);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Paramètres enregistrés'), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating));
                  });
                }
              },
              icon: _isLoading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.save),
              label: const Text('Enregistrer'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            )),
          ]),
        ),
      ),
    );
  }

  Widget _section(String title) => Row(children: [
    Container(width: 4, height: 20, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
    const SizedBox(width: 8),
    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
  ]);

  Widget _field(String label, IconData icon, TextEditingController ctrl, String? Function(String?)? validator) {
    return TextFormField(
      controller: ctrl, validator: validator,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, size: 18), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
    );
  }

  Widget _dropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value, items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(), onChanged: onChanged,
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
    );
  }
}
