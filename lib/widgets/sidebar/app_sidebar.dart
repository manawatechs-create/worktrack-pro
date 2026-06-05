import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';

class AppSidebar extends StatefulWidget {
  final Function(int) onItemSelected;
  final int currentIndex;
  final bool isCompact;
  const AppSidebar({super.key, required this.onItemSelected, required this.currentIndex, this.isCompact = false});
  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  bool _isExpanded = true;

  final List<Map<String, dynamic>> _menu = const [
    {'icon': Icons.dashboard, 'label': 'Tableau de bord', 'badge': null},
    {'icon': Icons.fingerprint, 'label': 'Pointage', 'badge': null},
    {'icon': Icons.people, 'label': 'Employés', 'badge': '50'},
    {'icon': Icons.business, 'label': 'Départements', 'badge': null},
    {'icon': Icons.schedule, 'label': 'Horaires', 'badge': null},
    {'icon': Icons.check_circle, 'label': 'Présences', 'badge': null},
    {'icon': Icons.warning, 'label': 'Retards', 'badge': '3'},
    {'icon': Icons.cancel, 'label': 'Absences', 'badge': null},
    {'icon': Icons.beach_access, 'label': 'Congés', 'badge': '2'},
    {'icon': Icons.flight, 'label': 'Missions', 'badge': null},
    {'icon': Icons.add_alarm, 'label': 'Heures Sup.', 'badge': null},
    {'icon': Icons.fact_check, 'label': 'Validation', 'badge': '5'},
    {'icon': Icons.assessment, 'label': 'Rapports', 'badge': null},
    {'icon': Icons.analytics, 'label': 'Analytics', 'badge': null},
    {'icon': Icons.settings, 'label': 'Paramètres', 'badge': null},
    {'icon': Icons.admin_panel_settings, 'label': 'Admin', 'badge': null},
  ];

  @override
  void initState() {
    super.initState();
    _isExpanded = !widget.isCompact;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: _isExpanded ? 260 : 70,
      color: AppColors.sidebarColor,
      child: Column(children: [
        // Logo
        Container(
          padding: EdgeInsets.all(_isExpanded ? 20 : 14),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1))),
          ),
          child: _isExpanded
              ? Row(children: [
                  Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.check_circle_outline, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                    const Text('WorkTrack', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold, height: 1.1)),
                    Text('Pro', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 17, fontWeight: FontWeight.bold, height: 1.1)),
                    const SizedBox(height: 2),
                    Text('PRÉSENCE & RH', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 8, letterSpacing: 1.2)),
                  ]),
                ])
              : Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.check_circle_outline, color: Colors.white, size: 22),
                ),
        ),
        // Menu
        Expanded(
          child: ListView.builder(
            itemCount: _menu.length,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (ctx, i) {
              final item = _menu[i];
              final selected = widget.currentIndex == i;
              final label = item['label'] as String;
              final icon = item['icon'] as IconData;
              final badge = item['badge'] as String?;
              
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => widget.onItemSelected(i),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: _isExpanded ? 14 : 0, vertical: 11),
                      decoration: BoxDecoration(
                        color: selected ? Colors.white.withOpacity(0.12) : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: selected ? Border.all(color: Colors.white.withOpacity(0.2)) : null,
                      ),
                      child: Row(
                        mainAxisAlignment: _isExpanded ? MainAxisAlignment.start : MainAxisAlignment.center,
                        children: [
                          Icon(icon, color: selected ? Colors.white : Colors.white.withOpacity(0.65), size: 20),
                          if (_isExpanded) ...[
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                label,
                                style: TextStyle(
                                  color: selected ? Colors.white : Colors.white.withOpacity(0.8),
                                  fontSize: 13.5,
                                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                                ),
                              ),
                            ),
                            if (badge != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                decoration: BoxDecoration(
                                  color: selected ? Colors.white.withOpacity(0.2) : AppColors.error.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Toggle
        InkWell(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1)))),
            child: Icon(_isExpanded ? Icons.chevron_left : Icons.chevron_right, color: Colors.white.withOpacity(0.6)),
          ),
        ),
      ]),
    );
  }
}
