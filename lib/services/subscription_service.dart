import 'package:cloud_firestore/cloud_firestore.dart';


class SubscriptionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔹 Vérifie si l'utilisateur a un abonnement valide
  Future<bool> hasValidSubscription(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) return false;

      final userData = userDoc.data();
      if (userData == null || !userData.containsKey('subscriptionExpiresAt')) {
        return false;
      }

      final expirationDate = (userData['subscriptionExpiresAt'] as Timestamp).toDate();
      return expirationDate.isAfter(DateTime.now());
    } catch (e) {
      throw Exception("❌ Erreur lors de la vérification de l'abonnement : $e");
    }
  }

  /// 🔹 Met à jour la date d'expiration de l'abonnement d'un utilisateur
  Future<void> updateSubscription(String userId, DateTime newExpiration) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        "subscriptionExpiresAt": Timestamp.fromDate(newExpiration),
      });
    } catch (e) {
      throw Exception("❌ Erreur lors de la mise à jour de l'abonnement : $e");
    }
  }

  /// 🔹 Annule l'abonnement d'un utilisateur
  Future<void> cancelSubscription(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        "subscriptionExpiresAt": null,
      });
    } catch (e) {
      throw Exception("❌ Erreur lors de l'annulation de l'abonnement : $e");
    }
  }
}
