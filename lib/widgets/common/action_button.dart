import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../services/notification_service.dart';

class ActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color? color;
  final VoidCallback? onPressed;
  final Future<bool> Function()? onAsyncPressed;
  final String? successMessage;
  final String? errorMessage;
  final bool isOutlined;
  final Size? size;

  const ActionButton({
    super.key,
    required this.label,
    required this.icon,
    this.color,
    this.onPressed,
    this.onAsyncPressed,
    this.successMessage,
    this.errorMessage,
    this.isOutlined = false,
    this.size,
  });

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  bool _isLoading = false;

  Future<void> _handlePress() async {
    if (_isLoading) return;

    if (widget.onAsyncPressed != null) {
      setState(() => _isLoading = true);
      try {
        final success = await widget.onAsyncPressed!();
        if (mounted) {
          if (success) {
            NotificationService.success(context, widget.successMessage ?? 'Action réussie ✅');
          } else {
            NotificationService.error(context, widget.errorMessage ?? 'Action échouée ❌');
          }
        }
      } catch (e) {
        if (mounted) {
          NotificationService.error(context, widget.errorMessage ?? 'Erreur: $e');
        }
      }
      if (mounted) setState(() => _isLoading = false);
    } else {
      widget.onPressed?.call();
      if (widget.successMessage != null) {
        NotificationService.success(context, widget.successMessage!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.primary;

    if (widget.isOutlined) {
      return OutlinedButton.icon(
        onPressed: _isLoading ? null : _handlePress,
        icon: _isLoading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : Icon(widget.icon, size: 18),
        label: Text(_isLoading ? 'Chargement...' : widget.label),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: _isLoading ? null : _handlePress,
      icon: _isLoading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Icon(widget.icon, size: 18),
      label: Text(_isLoading ? 'Chargement...' : widget.label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        elevation: 0,
      ),
    );
  }
}

// Boutons d'action rapides
class DeleteButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? confirmMessage;
  final String itemName;

  const DeleteButton({super.key, this.onPressed, this.confirmMessage, this.itemName = 'cet élément'});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              icon: const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 40),
              title: const Text('Confirmer la suppression'),
              content: Text(confirmMessage ?? 'Voulez-vous vraiment supprimer $itemName ?'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    onPressed?.call();
                    NotificationService.error(context, 'Supprimé avec succès 🗑️');
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: const Text('Supprimer'),
                ),
              ],
            ),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppColors.error.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.delete_outlined, size: 18, color: AppColors.error),
        ),
      ),
    );
  }
}

class EditButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const EditButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppColors.secondary.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.edit_outlined, size: 18, color: AppColors.secondary),
        ),
      ),
    );
  }
}

class ViewButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const ViewButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppColors.info.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.visibility_outlined, size: 18, color: AppColors.info),
        ),
      ),
    );
  }
}

class ValidateButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const ValidateButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppColors.success.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.check_circle_outline, size: 18, color: AppColors.success),
        ),
      ),
    );
  }
}
