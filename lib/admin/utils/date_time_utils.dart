import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

/// Convertir un `Timestamp` Firestore en une chaîne formatée
String formatFirestoreTimestamp(Timestamp timestamp) {
  final dateTime = timestamp.toDate();
  final formatter = DateFormat('dd/MM/yyyy à HH:mm');
  return formatter.format(dateTime);
}

/// Retourner une date formatée
String formatDate(DateTime date) {
  final formatter = DateFormat('dd MMM yyyy');
  return formatter.format(date);
}

/// Formater une durée en heures et minutes
String formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes % 60;
  return '${hours}h ${minutes}min';
}
