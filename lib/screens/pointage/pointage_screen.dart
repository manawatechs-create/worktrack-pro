import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../widgets/common/app_card.dart';

class PointageScreen extends StatefulWidget {
  const PointageScreen({super.key});

  @override
  State<PointageScreen> createState() => _PointageScreenState();
}

class _PointageScreenState extends State<PointageScreen> {
  bool _isPointedIn = false;
  String _currentTime = '--:--';
  String _lastPointage = 'Aucun';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.fingerprint, color: AppColors.primary, size: 28)),
          const SizedBox(width: 16),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Pointage Temps Réel', style: Theme.of(context).textTheme.headlineMedium),
            const Text('Pointer votre présence', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          ]),
        ]),
        const SizedBox(height: 24),

        // Horloge et bouton principal
        AppCard(
          padding: const EdgeInsets.all(32),
          child: Column(children: [
            Text(_currentTime, style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: AppColors.primary)),
            const Text('Heure actuelle', style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isPointedIn = !_isPointedIn;
                    final now = DateTime.now();
                    _currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
                    _lastPointage = _isPointedIn ? 'Entrée: $_currentTime' : 'Sortie: $_currentTime';
                  });
                },
                icon: Icon(_isPointedIn ? Icons.logout : Icons.login, size: 24),
                label: Text(_isPointedIn ? 'POINTER SORTIE' : 'POINTER ENTRÉE', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isPointedIn ? AppColors.error : AppColors.success,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text('Dernier pointage: $_lastPointage', style: const TextStyle(color: AppColors.textSecondary)),
          ]),
        ),
        const SizedBox(height: 20),

        // Méthodes de pointage
        Text('Méthodes de Pointage', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: _methodeCard(Icons.qr_code_scanner, 'QR Code', 'Scanner le QR code', AppColors.primary)),
          const SizedBox(width: 12),
          Expanded(child: _methodeCard(Icons.location_on, 'GPS', 'Géolocalisation', AppColors.success)),
          const SizedBox(width: 12),
          Expanded(child: _methodeCard(Icons.fingerprint, 'Biométrique', 'Empreinte digitale', AppColors.secondary)),
        ]),
        const SizedBox(height: 20),

        // Historique
        AppCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Historique Aujourd\'hui', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            ...List.generate(5, (i) => ListTile(
              leading: CircleAvatar(backgroundColor: AppColors.success.withOpacity(0.1), child: const Icon(Icons.check_circle, color: AppColors.success, size: 20)),
              title: Text(i == 0 ? 'Dernier pointage' : 'Pointage #${i+1}'),
              subtitle: Text('${8+i}:${(i*15).toString().padLeft(2, '0')} - ${17-i}:00'),
              trailing: Text('${9-i}h${(i*15)}min', style: const TextStyle(fontWeight: FontWeight.bold)),
            )),
          ]),
        ),
      ]),
    );
  }

  Widget _methodeCard(IconData icon, String title, String subtitle, Color color) {
    return AppCard(
      onTap: () {},
      child: Column(children: [
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 32)),
        const SizedBox(height: 12),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ]),
    );
  }
}
