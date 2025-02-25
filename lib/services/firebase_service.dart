import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/restaurant_model.dart';
import '../models/coupon_model.dart';
import '../utils/constants.dart';


class FirebaseService {
  final FirebaseFirestore _firestore;

  FirebaseService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// 🔹 **Récupérer tous les restaurants**
  Future<List<Restaurant>> fetchRestaurants() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('restaurants').get();
      return snapshot.docs.map((doc) => Restaurant.fromJson(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('❌ Erreur lors de la récupération des restaurants : $e');
    }
  }

  /// 🔹 **Récupérer les coupons d'un restaurant spécifique**
  Future<List<Coupon>> fetchCoupons(String restaurantId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('coupons')
          .get();
      return snapshot.docs.map((doc) => Coupon.fromJson(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('❌ Erreur lors de la récupération des coupons : $e');
    }
  }

  /// 🔹 **Désactiver un coupon**
  Future<void> disableCoupon(String restaurantId, String couponId) async {
    try {
      await _firestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('coupons')
          .doc(couponId)
          .update({'isActive': false});
    } catch (e) {
      throw Exception('❌ Erreur lors de la désactivation du coupon : $e');
    }
  }

  /// 🔹 **Ajouter des coupons immuables avec des valeurs prédéfinies**
  Future<void> addDefaultCoupons(String restaurantId) async {
    try {
      final List<Coupon> defaultCoupons = [
        Coupon(
          id: couponId2People,
          restaurantId: restaurantId,
          description: description2People,
          discountPercentage: discount2People,
          maxPeople: maxPeople2, uniqueCode: '',
        ),
        Coupon(
          id: couponId4People,
          restaurantId: restaurantId,
          description: description4People,
          discountPercentage: discount4People,
          maxPeople: maxPeople4, uniqueCode: '',
        ),
        Coupon(
          id: couponId6People,
          restaurantId: restaurantId,
          description: description6People,
          discountPercentage: discount6People,
          maxPeople: maxPeople6, uniqueCode: '',
        ),
      ];

      for (final coupon in defaultCoupons) {
        await _firestore
            .collection(restaurantsCollection)
            .doc(restaurantId)
            .collection(couponsCollection)
            .doc(coupon.id)
            .set(coupon.toJson());
      }
    } catch (e) {
      throw Exception('❌ Erreur lors de l\'ajout des coupons par défaut : $e');
    }
  }

  /// 🔹 **Ajouter un restaurant (Administration)**
  Future<void> addRestaurant(Restaurant restaurant) async {
    try {
      await _firestore.collection('restaurants').doc(restaurant.id).set(restaurant.toJson());
    } catch (e) {
      throw Exception('❌ Erreur lors de l\'ajout du restaurant : $e');
    }
  }

  /// 🔹 **Supprimer un restaurant (Administration)**
  Future<void> deleteRestaurant(String restaurantId) async {
    try {
      await _firestore.collection('restaurants').doc(restaurantId).delete();
    } catch (e) {
      throw Exception('❌ Erreur lors de la suppression du restaurant : $e');
    }
  }
}
