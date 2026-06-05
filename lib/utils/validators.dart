import 'package:flutter/material.dart';

class AppValidators {
  // Email
  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'L\'email est requis';
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) return 'Format email invalide (ex: nom@domaine.com)';
    if (value.length > 254) return 'Email trop long (max 254 caractères)';
    return null;
  }

  // Mot de passe
  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Le mot de passe est requis';
    if (value.length < 8) return 'Minimum 8 caractères';
    if (!value.contains(RegExp(r'[A-Z]'))) return 'Au moins une majuscule';
    if (!value.contains(RegExp(r'[a-z]'))) return 'Au moins une minuscule';
    if (!value.contains(RegExp(r'[0-9]'))) return 'Au moins un chiffre';
    if (!value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) return 'Au moins un caractère spécial';
    return null;
  }

  // Nom/Prénom
  static String? name(String? value, String fieldName) {
    if (value == null || value.isEmpty) return '$fieldName est requis';
    if (value.length < 2) return '$fieldName trop court (min 2 caractères)';
    if (value.length > 50) return '$fieldName trop long (max 50 caractères)';
    if (!RegExp(r'^[a-zA-ZÀ-ÿ\s\-]+$').hasMatch(value)) return '$fieldName contient des caractères invalides';
    return null;
  }

  // Téléphone
  static String? phone(String? value) {
    if (value == null || value.isEmpty) return 'Le téléphone est requis';
    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)\.]'), '');
    if (!RegExp(r'^\+?[0-9]{8,15}$').hasMatch(cleaned)) return 'Format téléphone invalide (ex: +2250100000000)';
    return null;
  }

  // Matricule
  static String? matricule(String? value) {
    if (value == null || value.isEmpty) return null; // Optionnel, auto-généré
    if (value.length < 3) return 'Matricule trop court (min 3 caractères)';
    if (value.length > 20) return 'Matricule trop long (max 20 caractères)';
    if (!RegExp(r'^[A-Z0-9\-_]+$').hasMatch(value)) return 'Format invalide (lettres majuscules, chiffres, -, _)';
    return null;
  }

  // Date
  static String? date(DateTime? value) {
    if (value == null) return 'La date est requise';
    if (value.isAfter(DateTime.now().add(const Duration(days: 365)))) return 'Date trop éloignée';
    if (value.isBefore(DateTime(1900))) return 'Date invalide';
    return null;
  }

  // Date future
  static String? futureDate(DateTime? value) {
    if (value == null) return 'La date est requise';
    if (value.isBefore(DateTime.now())) return 'La date doit être dans le futur';
    return null;
  }

  // Plage de dates
  static String? dateRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) return 'Les dates sont requises';
    if (end.isBefore(start)) return 'La date de fin doit être après la date de début';
    if (end.difference(start).inDays > 365) return 'La période ne peut pas dépasser 1 an';
    return null;
  }

  // Nombre
  static String? number(String? value, {double? min, double? max, String label = 'Valeur'}) {
    if (value == null || value.isEmpty) return '$label est requis';
    final number = double.tryParse(value);
    if (number == null) return '$label doit être un nombre';
    if (min != null && number < min) return '$label minimum: $min';
    if (max != null && number > max) return '$label maximum: $max';
    return null;
  }

  // Heure
  static String? time(String? value) {
    if (value == null || value.isEmpty) return 'L\'heure est requise';
    if (!RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$').hasMatch(value)) return 'Format heure invalide (HH:MM)';
    return null;
  }

  // URL
  static String? url(String? value) {
    if (value == null || value.isEmpty) return null; // Optionnel
    final uri = Uri.tryParse(value);
    if (uri == null || !uri.hasAbsolutePath) return 'URL invalide';
    return null;
  }

  // Texte requis
  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return '$fieldName est requis';
    if (value.trim().length < 2) return '$fieldName trop court';
    return null;
  }

  // Code postal
  static String? postalCode(String? value) {
    if (value == null || value.isEmpty) return null;
    if (!RegExp(r'^[0-9]{4,10}$').hasMatch(value)) return 'Code postal invalide';
    return null;
  }

  // Montant
  static String? amount(String? value, {double min = 0, String label = 'Montant'}) {
    if (value == null || value.isEmpty) return '$label requis';
    final amount = double.tryParse(value.replaceAll(',', '.'));
    if (amount == null) return '$label invalide';
    if (amount < min) return '$label minimum: $min';
    if (amount > 999999999) return '$label trop élevé';
    return null;
  }
}

// Extension pour validation de formulaire
extension FormValidation on GlobalKey<FormState> {
  bool validateAndSave() {
    final form = currentState;
    if (form == null) return false;
    if (!form.validate()) return false;
    form.save();
    return true;
  }
}
