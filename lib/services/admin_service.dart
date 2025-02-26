import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AdminService {
  final FirebaseFirestore _firestore;

  AdminService({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  /// 🔹 Récupérer tous les utilisateurs
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      final users = snapshot.docs.map((doc) => {"id": doc.id, ...doc.data()}).toList();

      debugPrint("✅ ${users.length} utilisateurs récupérés.");
      return users;
    } catch (e) {
      debugPrint("❌ Erreur lors de la récupération des utilisateurs : $e");
      throw Exception("Erreur lors de la récupération des utilisateurs.");
    }
  }

  /// 🔹 Mettre à jour le rôle d'un utilisateur
  Future<void> updateUserRole(String userId, String newRole) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);
      final userDoc = await userRef.get();

      if (!userDoc.exists) {
        throw Exception("L'utilisateur n'existe pas.");
      }

      await userRef.update({"role": newRole});
      debugPrint("✅ Rôle mis à jour pour l'utilisateur $userId.");
    } catch (e) {
      debugPrint("❌ Erreur lors de la mise à jour du rôle : $e");
      throw Exception("Erreur lors de la mise à jour du rôle.");
    }
  }

  /// 🔹 Mettre à jour les informations d'un utilisateur
  Future<void> updateUser(String userId, Map<String, dynamic> updatedData) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);
      final userDoc = await userRef.get();

      if (!userDoc.exists) {
        throw Exception("L'utilisateur n'existe pas.");
      }

      await userRef.update(updatedData);
      debugPrint("✅ Utilisateur $userId mis à jour.");
    } catch (e) {
      debugPrint("❌ Erreur lors de la mise à jour de l'utilisateur : $e");
      throw Exception("Erreur lors de la mise à jour de l'utilisateur.");
    }
  }

  /// 🔹 Ajouter un utilisateur manuellement (Admin)
  Future<void> addUser(Map<String, dynamic> userData) async {
    try {
      if (!userData.containsKey("email") || !userData.containsKey("name")) {
        throw Exception("Les informations utilisateur sont incomplètes.");
      }

      final docRef = _firestore.collection('users').doc();
      await docRef.set(userData);

      debugPrint("✅ Utilisateur ajouté avec succès : ${userData['name']} (${userData['email']}).");
    } catch (e) {
      debugPrint("❌ Erreur lors de l'ajout de l'utilisateur : $e");
      throw Exception("Erreur lors de l'ajout de l'utilisateur.");
    }
  }

  /// 🔹 Supprimer un utilisateur
  Future<void> deleteUser(String userId) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);
      final userDoc = await userRef.get();

      if (!userDoc.exists) {
        throw Exception("L'utilisateur n'existe pas.");
      }

      await userRef.delete();
      debugPrint("✅ Utilisateur $userId supprimé.");
    } catch (e) {
      debugPrint("❌ Erreur lors de la suppression de l'utilisateur : $e");
      throw Exception("Erreur lors de la suppression de l'utilisateur.");
    }
  }

  Future<void> updateUserStatus(String userId, bool isActive) async {
    try {
      await _firestore.collection('users').doc(userId).update({"isActive": isActive});
      debugPrint("✅ Utilisateur $userId ${isActive ? 'activé' : 'désactivé'}.");
    } catch (e) {
      debugPrint("❌ Erreur mise à jour du statut : $e");
      throw Exception("Erreur lors de la mise à jour du statut.");
    }
  }


}
