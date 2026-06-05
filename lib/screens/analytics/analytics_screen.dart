import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../widgets/common/app_card.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.analytics, color: AppColors.primary, size: 28)),
          const SizedBox(width: 16),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Analytics & Statistiques', style: Theme.of(context).textTheme.headlineMedium),
            const Text('Analyse avancée des données RH', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          ]),
        ]),
        const SizedBox(height: 24),

        // KPIs analytics
        Row(children: [
          _kpiCard('Taux Présence', '94%', '+2%', Icons.trending_up, AppColors.success),
          const SizedBox(width: 12),
          _kpiCard('Productivité', '87%', '+5%', Icons.speed, AppColors.info),
          const SizedBox(width: 12),
          _kpiCard('Absentéisme', '6%', '-1%', Icons.trending_down, AppColors.error),
          const SizedBox(width: 12),
          _kpiCard('Satisfaction', '82%', '+3%', Icons.thumb_up, AppColors.secondary),
        ]),
        const SizedBox(height: 24),

        // Graphiques simulés
        Row(children: [
          Expanded(
            child: AppCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Présence par Département', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 16),
                ...['Informatique', 'RH', 'Finance', 'Marketing', 'Production'].map((d) => 
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text(d, style: const TextStyle(fontSize: 13)),
                        Text('${85 + d.length}%', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ]),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: (85 + d.length) / 100,
                        backgroundColor: AppColors.border,
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ]),
                  ),
                ),
              ]),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: AppCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Évolution Mensuelle', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 16),
                ...List.generate(6, (i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(children: [
                    SizedBox(width: 30, child: Text('${["Jan","Fév","Mar","Avr","Mai","Juin"][i]}', style: const TextStyle(fontSize: 11))),
                    const SizedBox(width: 8),
                    Expanded(child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      width: double.infinity,
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: [0.88, 0.91, 0.85, 0.94, 0.92, 0.96][i],
                        child: Container(decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(4))),
                      ),
                    )),
                    const SizedBox(width: 8),
                    Text('${[88,91,85,94,92,96][i]}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ]),
                )),
              ]),
            ),
          ),
        ]),
      ]),
    );
  }

  Widget _kpiCard(String title, String value, String variation, IconData icon, Color color) {
    return Expanded(
      child: AppCard(
        child: Column(children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 24)),
          const SizedBox(height: 12),
          Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
          Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          Text(variation, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }
}
