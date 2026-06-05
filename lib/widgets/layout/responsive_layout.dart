import 'package:flutter/material.dart';
import '../../utils/responsive.dart';
import '../../config/theme/app_colors.dart';
import '../sidebar/app_sidebar.dart';
import 'responsive_header.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget child;
  final int currentIndex;
  final Function(int) onItemSelected;
  final String userName;
  final String userRole;
  final VoidCallback onLogout;

  const ResponsiveLayout({
    super.key,
    required this.child,
    required this.currentIndex,
    required this.onItemSelected,
    required this.userName,
    required this.userRole,
    required this.onLogout,
  });

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: (!isDesktop && !isTablet) ? Drawer(
        child: AppSidebar(
          currentIndex: widget.currentIndex,
          onItemSelected: (index) {
            widget.onItemSelected(index);
            Navigator.pop(context);
          },
          isCompact: true,
        ),
      ) : null,
      body: Row(
        children: [
          if (isDesktop)
            AppSidebar(currentIndex: widget.currentIndex, onItemSelected: widget.onItemSelected, isCompact: false)
          else if (isTablet)
            AppSidebar(currentIndex: widget.currentIndex, onItemSelected: widget.onItemSelected, isCompact: true),
          Expanded(
            child: Column(
              children: [
                ResponsiveHeader(
                  userName: widget.userName,
                  userRole: widget.userRole,
                  onMenuTap: () {
                    if (!isDesktop && !isTablet) _scaffoldKey.currentState?.openDrawer();
                  },
                  onLogout: widget.onLogout,
                  showMenuButton: !isDesktop && !isTablet,
                ),
                Expanded(child: widget.child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
