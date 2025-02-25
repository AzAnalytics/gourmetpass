/// Fonctions utilitaires pour la validation des formulaires
library;

bool validateEmail(String email) {
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  return emailRegex.hasMatch(email);
}

String? validateNonEmpty(String? value, String fieldName) {
  if (value == null || value.trim().isEmpty) {
    return '$fieldName ne peut pas être vide.';
  }
  return null;
}

String? validatePercentage(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Le pourcentage est requis.';
  }
  final parsed = int.tryParse(value);
  if (parsed == null || parsed < 0 || parsed > 100) {
    return 'Veuillez entrer un pourcentage valide entre 0 et 100.';
  }
  return null;
}
