import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool showSubtitle;

  const AppLogo({
    super.key,
    this.size = 40,
    this.showText = true,
    this.showSubtitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icône
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(size * 0.25),
          ),
          child: Icon(Icons.check_circle_outline, color: Colors.white, size: size * 0.55),
        ),
        
        if (showText) ...[
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                  children: [
                    TextSpan(text: 'WorkTrack', style: TextStyle(color: AppColors.primary)),
                    TextSpan(text: 'Pro', style: TextStyle(color: AppColors.secondary)),
                  ],
                ),
              ),
              if (showSubtitle)
                const Text(
                  'GESTION DE PRÉSENCE & RH',
                  style: TextStyle(fontSize: 8, color: AppColors.textSecondary, letterSpacing: 1.2, fontWeight: FontWeight.w500),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

// Logo pour l'écran de connexion (plus grand)
class AppLogoLarge extends StatelessWidget {
  const AppLogoLarge({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8)),
            ],
          ),
          child: const Icon(Icons.check_circle_outline, color: Colors.white, size: 44),
        ),
        const SizedBox(height: 16),
        RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -1),
            children: [
              TextSpan(text: 'WorkTrack', style: TextStyle(color: AppColors.primary)),
              TextSpan(text: 'Pro', style: TextStyle(color: AppColors.secondary)),
            ],
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'GESTION DE PRÉSENCE & RH',
          style: TextStyle(fontSize: 9, color: AppColors.textSecondary, letterSpacing: 1.5, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

// Logo compact pour sidebar
class AppLogoCompact extends StatelessWidget {
  final bool isExpanded;
  const AppLogoCompact({super.key, required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return isExpanded
        ? const AppLogo(size: 32, showText: true, showSubtitle: true)
        : Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.primary, AppColors.secondary], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
          );
  }
}
