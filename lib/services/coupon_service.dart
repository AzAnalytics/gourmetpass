import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/coupon_model.dart';

class CouponService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Récupérer les coupons pour un restaurant spécifique
  Future<List<Coupon>> fetchCoupons(String restaurantId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('coupons')
          .get();

      return snapshot.docs.map((doc) {
        return Coupon.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des coupons : $e');
    }
  }

  /// Valider un coupon spécifique
  Future<bool> validateCoupon(String restaurantId, String couponId) async {
    try {
      final DocumentReference couponRef = _firestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('coupons')
          .doc(couponId);

      final DocumentSnapshot couponSnapshot = await couponRef.get();

      if (couponSnapshot.exists) {
        final data = couponSnapshot.data() as Map<String, dynamic>;
        final bool isUsed = data['isUsed'] ?? false;

        if (isUsed) {
          return false; // Le coupon a déjà été utilisé
        } else {
          await couponRef.update({'isUsed': true}); // Marquer comme utilisé
          return true;
        }
      } else {
        throw Exception('Coupon introuvable.');
      }
    } catch (e) {
      throw Exception('Erreur lors de la validation du coupon : $e');
    }
  }

  /// Ajouter un coupon (fonctionnalité facultative)
  Future<void> addCoupon(String restaurantId, Coupon coupon) async {
    try {
      final DocumentReference couponRef = _firestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('coupons')
          .doc(coupon.id);

      await couponRef.set(coupon.toJson());
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout du coupon : $e');
    }
  }

  /// Supprimer un coupon (fonctionnalité facultative)
  Future<void> deleteCoupon(String restaurantId, String couponId) async {
    try {
      final DocumentReference couponRef = _firestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('coupons')
          .doc(couponId);

      await couponRef.delete();
    } catch (e) {
      throw Exception('Erreur lors de la suppression du coupon : $e');
    }
  }
}
