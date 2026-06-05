import 'package:flutter/material.dart';

class Responsive {
  // Points de rupture
  static const double mobileMax = 600;
  static const double tabletMax = 1024;
  static const double desktopMin = 1025;
  static const double wideMin = 1440;

  // Vérifier le type d'écran
  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < mobileMax;
  static bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= mobileMax && MediaQuery.of(context).size.width < tabletMax;
  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= desktopMin;
  static bool isWide(BuildContext context) => MediaQuery.of(context).size.width >= wideMin;

  // Obtenir le nombre de colonnes pour les grilles
  static int getGridColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 1;
    if (width < 900) return 2;
    if (width < 1200) return 3;
    if (width < 1600) return 4;
    return 6;
  }

  // Obtenir le nombre de colonnes pour les KPIs
  static int getKpiColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 1;
    if (width < 900) return 2;
    if (width < 1400) return 4;
    return 4;
  }

  // Padding responsive
  static EdgeInsets getPadding(BuildContext context) {
    if (isMobile(context)) return const EdgeInsets.all(12);
    if (isTablet(context)) return const EdgeInsets.all(18);
    return const EdgeInsets.all(24);
  }

  // Taille de police responsive
  static double getFontSize(BuildContext context, double base) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return base * 0.8;
    if (width < 1024) return base * 0.9;
    return base;
  }
}

// Widget responsive builder
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context) mobile;
  final Widget Function(BuildContext context)? tablet;
  final Widget Function(BuildContext context)? desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (Responsive.isDesktop(context) && desktop != null) {
      return desktop!(context);
    }
    if (Responsive.isTablet(context) && tablet != null) {
      return tablet!(context);
    }
    return mobile(context);
  }
}
