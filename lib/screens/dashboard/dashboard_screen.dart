import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../utils/responsive.dart';
import '../../services/notification_service.dart';
import '../../widgets/layout/responsive_layout.dart';
import '../../widgets/common/action_button.dart';
import '../pointage/pointage_screen.dart';
import '../employees/employees_screen.dart';
import '../departments/departments_screen.dart';
import '../plannings/plannings_screen.dart';
import '../presences/presences_screen.dart';
import '../retards/retards_screen.dart';
import '../absences/absences_screen.dart';
import '../conges/conges_screen.dart';
import '../missions/missions_screen.dart';
import '../overtime/overtime_screen.dart';
import '../validation/validation_screen.dart';
import '../reports/reports_screen.dart';
import '../analytics/analytics_screen.dart';
import '../settings/settings_screen.dart';
import '../admin/admin_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  final _pointages = const [
    {'employe': 'Nathanael Kouassi', 'departement': 'Informatique', 'entree': '07:55', 'sortie': '17:30', 'duree': '9h35', 'statut': 'Présent'},
    {'employe': 'Awa Koné', 'departement': 'Comptabilité', 'entree': '08:15', 'sortie': '17:00', 'duree': '8h45', 'statut': 'Retard'},
    {'employe': 'Jean Yao', 'departement': 'Logistique', 'entree': '07:48', 'sortie': '17:45', 'duree': '9h57', 'statut': 'Présent'},
    {'employe': 'Marie Diallo', 'departement': 'RH', 'entree': '—', 'sortie': '—', 'duree': '—', 'statut': 'Absent'},
  ];

  @override
  void initState() {
    super.initState();
    _pages = [
      _buildDashboardContent(),
      const PointageScreen(), const EmployeesScreen(), const DepartmentsScreen(),
      const PlanningsScreen(), const PresencesScreen(), const RetardsScreen(),
      const AbsencesScreen(), const CongesScreen(), const MissionsScreen(),
      const OvertimeScreen(), const ValidationScreen(), const ReportsScreen(),
      const AnalyticsScreen(), const SettingsScreen(), const AdminScreen(),
    ];
  }

  Widget _buildDashboardContent() {
    return SingleChildScrollView(
      padding: Responsive.getPadding(context),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.dashboard, color: AppColors.primary, size: 24)),
          const SizedBox(width: 12),
          Text('Tableau de Bord', style: TextStyle(fontSize: Responsive.getFontSize(context, 22), fontWeight: FontWeight.bold)),
        ]),
        SizedBox(height: Responsive.isMobile(context) ? 16 : 24),
        // Boutons d'action rapides
        Row(children: [
          ActionButton(label: 'Pointer', icon: Icons.fingerprint, color: AppColors.success, onPressed: () => NotificationService.success(context, '✅ Pointage enregistré - 08:00', title: 'Pointage Réussi')),
          const SizedBox(width: 8),
          ActionButton(label: 'Exporter', icon: Icons.download, color: AppColors.info, isOutlined: true, onAsyncPressed: () async {
            await Future.delayed(const Duration(seconds: 1));
            return true;
          }, successMessage: '📥 Rapport exporté avec succès'),
          const SizedBox(width: 8),
          ActionButton(label: 'Actualiser', icon: Icons.refresh, color: AppColors.secondary, isOutlined: true, onPressed: () => NotificationService.info(context, '🔄 Données actualisées')),
        ]),
        const SizedBox(height: 20),
        // KPIs
        GridView.count(
          crossAxisCount: Responsive.getKpiColumns(context), shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: Responsive.isMobile(context) ? 2.0 : 1.6,
          children: [
            _kpi('Présents', '45', '+12%', Icons.people, AppColors.success),
            _kpi('Absents', '8', '-5%', Icons.person_off, AppColors.error),
            _kpi('Retards', '3', '-2%', Icons.access_time, AppColors.warning),
            _kpi('Congés', '5', '0%', Icons.beach_access, AppColors.info),
          ],
        ),
        const SizedBox(height: 24),
        // Tableau
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Derniers Pointages', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                ActionButton(label: 'Voir tout', icon: Icons.arrow_forward, color: AppColors.primary, isOutlined: true, onPressed: () => setState(() => _currentIndex = 5)),
              ]),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(AppColors.background),
                  columnSpacing: 20,
                  columns: const [
                    DataColumn(label: Text('Employé')), DataColumn(label: Text('Département')),
                    DataColumn(label: Text('Entrée')), DataColumn(label: Text('Sortie')),
                    DataColumn(label: Text('Statut')), DataColumn(label: Text('Actions')),
                  ],
                  rows: _pointages.map((p) {
                    final isPresent = p['statut'] == 'Présent';
                    final color = isPresent ? AppColors.success : p['statut'] == 'Retard' ? AppColors.warning : AppColors.error;
                    return DataRow(cells: [
                      DataCell(Text(p['employe']!, style: const TextStyle(fontWeight: FontWeight.w500))),
                      DataCell(Text(p['departement']!)),
                      DataCell(Text(p['entree']!)),
                      DataCell(Text(p['sortie']!)),
                      DataCell(Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                        child: Text(p['statut']!, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
                      )),
                      DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
                        ViewButton(onPressed: () => NotificationService.info(context, '👁️ Détails de ${p['employe']}')),
                        const SizedBox(width: 4),
                        EditButton(onPressed: () => NotificationService.success(context, '✏️ ${p['employe']} modifié')),
                      ])),
                    ]);
                  }).toList(),
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _kpi(String title, String value, String var_, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)]),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: 22)),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Text(var_, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold))),
        ]),
        const Spacer(),
        Text(value, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        Text(title, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return ResponsiveLayout(
      currentIndex: _currentIndex,
      onItemSelected: (i) => setState(() => _currentIndex = i),
      userName: auth.fullName,
      userRole: auth.role.replaceAll('_', ' ').toUpperCase(),
      onLogout: () {
        auth.logout();
        Navigator.pushReplacementNamed(context, '/login');
        NotificationService.info(context, '👋 Déconnecté avec succès');
      },
      child: _pages[_currentIndex],
    );
  }
}
