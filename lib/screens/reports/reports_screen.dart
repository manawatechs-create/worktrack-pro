import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.assessment, size: 80, color: AppColors.primary),
        SizedBox(height: 16),
        Text('Module Rapports', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text('Génération de rapports', style: TextStyle(color: Colors.grey)),
      ]),
    );
  }
}
