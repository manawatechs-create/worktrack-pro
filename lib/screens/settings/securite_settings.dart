import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';

class SecuriteSettings extends StatefulWidget {
  const SecuriteSettings({super.key});
  @override
  State<SecuriteSettings> createState() => _SecuriteSettingsState();
}

class _SecuriteSettingsState extends State<SecuriteSettings> {
  bool _2faEnabled = false, _ssoEnabled = false;
  int _sessionTimeout = 30, _tentativesMax = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🔒 Sécurité'), backgroundColor: AppColors.primary),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _section('Authentification'),
          SwitchListTile(title: const Text('Double authentification (2FA)'), subtitle: const Text('Code temporaire par application'), value: _2faEnabled, onChanged: (v) => setState(() => _2faEnabled = v)),
          if (_2faEnabled)
            Card(color: AppColors.success.withOpacity(0.1), child: const Padding(padding: EdgeInsets.all(16), child: Text('✅ Scannez le QR code dans votre application d\'authentification'))),
          SwitchListTile(title: const Text('SSO / LDAP'), subtitle: const Text('Authentification unique'), value: _ssoEnabled, onChanged: (v) => setState(() => _ssoEnabled = v)),
          const SizedBox(height: 16),
          _section('Politiques'),
          ListTile(title: const Text('Expiration session'), subtitle: Text('$_sessionTimeout minutes'), trailing: SizedBox(width: 100, child: DropdownButton<int>(value: _sessionTimeout, items: [15, 30, 60, 120, 240].map((m) => DropdownMenuItem(value: m, child: Text('${m}min'))).toList(), onChanged: (v) => setState(() => _sessionTimeout = v!)))),
          ListTile(title: const Text('Tentatives max'), subtitle: Text('$_tentativesMax essais'), trailing: SizedBox(width: 100, child: DropdownButton<int>(value: _tentativesMax, items: [3, 5, 10].map((m) => DropdownMenuItem(value: m, child: Text('$m'))).toList(), onChanged: (v) => setState(() => _tentativesMax = v!)))),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity, height: 50, child: ElevatedButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Sécurité mise à jour'), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating)), icon: const Icon(Icons.save), label: const Text('Enregistrer'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
        ]),
      ),
    );
  }

  Widget _section(String title) => Row(children: [Container(width: 4, height: 20, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))), const SizedBox(width: 8), Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]);
}
