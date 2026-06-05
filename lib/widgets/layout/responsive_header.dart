import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../utils/responsive.dart';

class ResponsiveHeader extends StatelessWidget {
  final String userName;
  final String userRole;
  final VoidCallback? onMenuTap;
  final VoidCallback? onLogout;
  final bool showMenuButton;

  const ResponsiveHeader({super.key, required this.userName, required this.userRole, this.onMenuTap, this.onLogout, this.showMenuButton = false});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 20, vertical: isMobile ? 8 : 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(children: [
        if (showMenuButton)
          IconButton(icon: const Icon(Icons.menu, color: AppColors.textPrimary), onPressed: onMenuTap),
        Expanded(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 350),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher...',
                hintStyle: TextStyle(color: AppColors.textHint, fontSize: 13),
                prefixIcon: Icon(Icons.search, size: 20, color: AppColors.textHint),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                isDense: true,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        _iconBtn(Icons.notifications_outlined, '3'),
        if (!isMobile) ...[
          const SizedBox(width: 4),
          _iconBtn(Icons.message_outlined, '2'),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              CircleAvatar(radius: 14, backgroundColor: AppColors.sidebarColor, child: Text(userName.isNotEmpty ? userName[0].toUpperCase() : '?', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
              const SizedBox(width: 8),
              Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(userName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: AppColors.textPrimary)),
                Text(userRole, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
              ]),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_drop_down, size: 18, color: AppColors.textSecondary),
            ]),
          ),
          const SizedBox(width: 4),
          IconButton(icon: const Icon(Icons.logout, size: 18, color: AppColors.textSecondary), onPressed: onLogout, tooltip: 'Déconnexion'),
        ],
      ]),
    );
  }

  Widget _iconBtn(IconData icon, String badge) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(icon: Icon(icon, size: 20, color: AppColors.textSecondary), onPressed: () {}),
        Positioned(right: 4, top: 4, child: Container(
          padding: const EdgeInsets.all(3),
          decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
          child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
        )),
      ],
    );
  }
}
