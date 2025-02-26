import 'package:cloud_firestore/cloud_firestore.dart';

/// Convertir une erreur Firebase en message utilisateur
String parseFirebaseError(FirebaseException error) {
  switch (error.code) {
    case 'permission-denied':
      return 'Vous n\'avez pas la permission d\'effectuer cette action.';
    case 'not-found':
      return 'L\'élément demandé est introuvable.';
    default:
      return 'Une erreur inconnue est survenue. Veuillez réessayer.';
  }
}

/// Ajouter un document à une collection avec un ID généré
Future<void> addDocument({
  required String collectionPath,
  required Map<String, dynamic> data,
  FirebaseFirestore? firestore,
}) async {
  final firestoreInstance = firestore ?? FirebaseFirestore.instance; // ✅ Correction ici
  try {
    final docRef = firestoreInstance.collection(collectionPath).doc();
    await docRef.set(data);
  } catch (e) {
    rethrow;
  }
}


/// Supprimer un document de Firestore
Future<void> deleteDocument(
    String path, {
      FirebaseFirestore? firestore,
    }) async {
  final firestoreInstance = firestore ?? FirebaseFirestore.instance; // ✅ Correction ici
  try {
    final docRef = firestoreInstance.doc(path);
    await docRef.delete();
  } catch (e) {
    rethrow;
  }
}

