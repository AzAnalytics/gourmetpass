import 'package:flutter/material.dart';

/// Afficher un message SnackBar
void showSnackBar(BuildContext context, String message, {bool isError = false}) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: isError ? Colors.red : Colors.green,
    duration: Duration(seconds: 3),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

/// Calculer la note moyenne d'une liste de notes
double calculateAverageRating(List<double> ratings) {
  if (ratings.isEmpty) return 0.0;
  return ratings.reduce((a, b) => a + b) / ratings.length;
}

/// Vérifier si une adresse email est valide
bool isValidEmail(String email) {
  final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return regex.hasMatch(email);
}

/// Formater un pourcentage
String formatPercentage(int percentage) {
  return '$percentage%';
}

/// Limiter un texte à une longueur maximale
String truncateText(String text, int maxLength) {
  if (text.length <= maxLength) return text;
  return '${text.substring(0, maxLength)}...';
}

/// Convertir une couleur hexadécimale en objet Color
Color hexToColor(int hex) {
  return Color(hex).withAlpha(255);
}

/// Afficher une boîte de dialogue simple
Future<void> showSimpleDialog(
    BuildContext context, {
      required String title,
      required String content,
      required String confirmText,
      VoidCallback? onConfirm,
    }) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (onConfirm != null) onConfirm();
              Navigator.of(context).pop();
            },
            child: Text(confirmText),
          ),
        ],
      );
    },
  );
}
