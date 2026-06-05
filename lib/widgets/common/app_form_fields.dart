import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';

// Widget LabeledField (dans le même fichier)
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
                Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                if (required) const Text(' *', style: TextStyle(color: AppColors.error, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        child,
        if (helpText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(helpText!, style: const TextStyle(color: AppColors.textHint, fontSize: 11)),
          ),
      ],
    );
  }
}

class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? initialValue;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final int? maxLines;
  final TextEditingController? controller;
  final bool required;
  final String? helpText;
  final Widget? suffixIcon;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.initialValue,
    this.prefixIcon,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.obscureText = false,
    this.maxLines = 1,
    this.controller,
    this.required = false,
    this.helpText,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return LabeledField(
      label: label,
      required: required,
      helpText: helpText,
      child: TextFormField(
        controller: controller,
        initialValue: controller == null ? initialValue : null,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 18) : null,
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: AppColors.background,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.error)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          isDense: true,
        ),
      ),
    );
  }
}

class AppDropdown<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final IconData? prefixIcon;
  final bool required;
  final String? helpText;

  const AppDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    this.onChanged,
    this.prefixIcon,
    this.required = false,
    this.helpText,
  });

  @override
  Widget build(BuildContext context) {
    return LabeledField(
      label: label,
      required: required,
      helpText: helpText,
      child: DropdownButtonFormField<T>(
        value: value,
        items: items,
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 18) : null,
          filled: true,
          fillColor: AppColors.background,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          isDense: true,
        ),
        icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
        borderRadius: BorderRadius.circular(10),
        dropdownColor: Colors.white,
      ),
    );
  }
}

class AppDateField extends StatelessWidget {
  final String label;
  final DateTime value;
  final ValueChanged<DateTime>? onChanged;
  final IconData? prefixIcon;
  final bool required;

  const AppDateField({
    super.key,
    required this.label,
    required this.value,
    this.onChanged,
    this.prefixIcon,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return LabeledField(
      label: label,
      required: required,
      child: InkWell(
        onTap: () async {
          final date = await showDatePicker(context: context, initialDate: value, firstDate: DateTime(1900), lastDate: DateTime(2100));
          if (date != null) onChanged?.call(date);
        },
        borderRadius: BorderRadius.circular(10),
        child: InputDecorator(
          decoration: InputDecoration(
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 18) : null,
            suffixIcon: const Icon(Icons.calendar_today, size: 16),
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            isDense: true,
          ),
          child: Text('${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}', style: const TextStyle(fontSize: 14)),
        ),
      ),
    );
  }
}

class AppFilePicker extends StatefulWidget {
  final String label;
  final bool required;
  final String? selectedFileName;
  final ValueChanged<String>? onFileSelected;

  const AppFilePicker({super.key, required this.label, this.required = false, this.selectedFileName, this.onFileSelected});

  @override
  State<AppFilePicker> createState() => _AppFilePickerState();
}

class _AppFilePickerState extends State<AppFilePicker> {
  String? _fileName;

  @override
  void initState() {
    super.initState();
    _fileName = widget.selectedFileName;
  }

  @override
  Widget build(BuildContext context) {
    return LabeledField(
      label: widget.label,
      required: widget.required,
      child: InkWell(
        onTap: () {
          setState(() => _fileName = 'photo_profil.jpg');
          widget.onFileSelected?.call(_fileName!);
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.upload_file, size: 16, color: AppColors.primary),
                SizedBox(width: 6),
                Text('Parcourir', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
              ]),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(_fileName ?? 'Aucun fichier choisi', style: TextStyle(color: _fileName != null ? AppColors.textPrimary : AppColors.textHint, fontSize: 13, fontStyle: _fileName != null ? FontStyle.normal : FontStyle.italic), overflow: TextOverflow.ellipsis)),
          ]),
        ),
      ),
    );
  }
}

class AppCheckboxGroup extends StatefulWidget {
  final String label;
  final List<String> options;
  final List<String> selectedValues;
  final ValueChanged<List<String>>? onChanged;
  final bool required;

  const AppCheckboxGroup({super.key, required this.label, required this.options, this.selectedValues = const [], this.onChanged, this.required = false});

  @override
  State<AppCheckboxGroup> createState() => _AppCheckboxGroupState();
}

class _AppCheckboxGroupState extends State<AppCheckboxGroup> {
  late List<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return LabeledField(
      label: widget.label,
      required: widget.required,
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        children: widget.options.map((option) {
          final checked = _selected.contains(option);
          return InkWell(
            onTap: () {
              setState(() {
                checked ? _selected.remove(option) : _selected.add(option);
                widget.onChanged?.call(_selected);
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Container(
                width: 20, height: 20,
                decoration: BoxDecoration(
                  color: checked ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: checked ? AppColors.primary : AppColors.border, width: 2),
                ),
                child: checked ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
              ),
              const SizedBox(width: 6),
              Text(option, style: const TextStyle(fontSize: 13)),
            ]),
          );
        }).toList(),
      ),
    );
  }
}
