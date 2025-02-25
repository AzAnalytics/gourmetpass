import 'package:flutter/material.dart';

/// Afficher un dialogue de confirmation
Future<bool> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
}) async {
  return (await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: const Text('Annuler'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text('Confirmer'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  )) ??
      false;
}

/// Afficher une barre de notification
void showSnackbar({
  required BuildContext context,
  required String message,
  Color backgroundColor = Colors.green,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ),
  );
}
