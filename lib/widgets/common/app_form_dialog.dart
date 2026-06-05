import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';

class FormSection {
  final String title;
  final IconData icon;
  final List<Widget> fields;

  const FormSection({
    required this.title,
    required this.icon,
    required this.fields,
  });
}

class AppFormDialog extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData headerIcon;
  final Color headerColor;
  final List<FormSection> sections;
  final GlobalKey<FormState> formKey;
  final VoidCallback? onCancel;
  final VoidCallback? onSubmit;
  final String submitLabel;
  final String cancelLabel;
  final bool isLoading;
  final String? helpText;
  final Widget? extraHeader;

  const AppFormDialog({
    super.key,
    required this.title,
    this.subtitle,
    required this.headerIcon,
    required this.headerColor,
    required this.sections,
    required this.formKey,
    this.onCancel,
    this.onSubmit,
    this.submitLabel = 'Enregistrer',
    this.cancelLabel = 'Annuler',
    this.isLoading = false,
    this.helpText,
    this.extraHeader,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700, maxHeight: 800),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [headerColor, headerColor.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(headerIcon, color: Colors.white, size: 32),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  if (extraHeader != null) ...[
                    const SizedBox(height: 8),
                    extraHeader!,
                  ],
                ],
              ),
            ),

            // Body avec sections
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      if (helpText != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: AppColors.info.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.info.withOpacity(0.2)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline, color: AppColors.info, size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  helpText!,
                                  style: const TextStyle(color: AppColors.info, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Sections
                      ...sections.map((section) => _buildSection(section, sections.indexOf(section))),
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onCancel,
                      icon: const Icon(Icons.close, size: 18),
                      label: Text(cancelLabel),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: const BorderSide(color: AppColors.border),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : onSubmit,
                      icon: isLoading
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Icon(Icons.arrow_forward, size: 18),
                      label: Text(submitLabel, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: headerColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(FormSection section, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (index > 0) const SizedBox(height: 8),
        // Titre de section
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(section.icon, size: 16, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Text(
                section.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Champs
        ...section.fields.map((field) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: field,
        )),
        const Divider(height: 1),
      ],
    );
  }
}

// Widget de champ avec label et astérisque
class LabeledField extends StatelessWidget {
  final String label;
  final bool required;
  final Widget child;
  final String? helpText;

  const LabeledField({
    super.key,
    required this.label,
    this.required = false,
    required this.child,
    this.helpText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (required)
                  const Text(
                    ' *',
                    style: TextStyle(color: AppColors.error, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
        child,
        if (helpText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              helpText!,
              style: const TextStyle(color: AppColors.textHint, fontSize: 11),
            ),
          ),
      ],
    );
  }
}
