/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/coupon_model.dart';
import 'package:logger/logger.dart';

class CouponProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore;
  final Logger logger = Logger();

  List<Coupon> _coupons = [];
  bool _isLoading = false;
  String? _errorMessage;

  CouponProvider({FirebaseFirestore? fakeFirestore})
      : _firestore = fakeFirestore ?? FirebaseFirestore.instance;

  List<Coupon> get coupons => List.unmodifiable(_coupons);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Charger les coupons d'un restaurant spécifique
  Future<void> fetchCoupons(String restaurantId) async {
    _setLoadingState(true);
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('coupons')
          .get();

      _coupons = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Coupon.fromJson(data);
      }).toList();

      logger.i('✅ Coupons pour le restaurant $restaurantId chargés avec succès.');
    } catch (e, stackTrace) {
      logger.e('❌ Erreur lors de la récupération des coupons : $e', stackTrace: stackTrace);
      _coupons = [];
      setErrorState('Erreur lors du chargement des coupons.');
    } finally {
      _setLoadingState(false);
    }
  }

  /// Utiliser un coupon (le marquer comme utilisé)
  Future<void> useCoupon(String restaurantId, String couponId) async {
    try {
      await _firestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('coupons')
          .doc(couponId)
          .update({'isUsed': true});

      final index = _coupons.indexWhere((coupon) => coupon.id == couponId);
      if (index != -1) {
        _coupons[index] = _coupons[index].copyWith(isUsed: true);
        notifyListeners();
      }

      logger.i('✅ Coupon $couponId utilisé avec succès.');
    } catch (e, stackTrace) {
      logger.e('❌ Erreur lors de l\'utilisation du coupon : $e', stackTrace: stackTrace);
    }
  }

  /// Valider un coupon
  Future<bool> validateCoupon(String restaurantId, String couponId) async {
    try {
      final couponRef = _firestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('coupons')
          .doc(couponId);

      final couponSnapshot = await couponRef.get();

      if (couponSnapshot.exists) {
        final data = couponSnapshot.data() as Map<String, dynamic>;
        final bool isUsed = data['isUsed'] ?? false;

        if (isUsed) {
          logger.w('⚠️ Le coupon $couponId est déjà utilisé.');
          return false;
        }

        await couponRef.update({'isUsed': true});

        final index = _coupons.indexWhere((coupon) => coupon.id == couponId);
        if (index != -1) {
          _coupons[index] = _coupons[index].copyWith(isUsed: true);
          notifyListeners();
        }

        logger.i('✅ Coupon $couponId validé avec succès.');
        return true;
      } else {
        logger.e('❌ Le coupon $couponId est introuvable.');
        return false;
      }
    } catch (e, stackTrace) {
      logger.e('❌ Erreur lors de la validation du coupon $couponId : $e', stackTrace: stackTrace);
      return false;
    }
  }

  /// Ajouter un coupon
  Future<void> addCoupon(String restaurantId, Coupon coupon) async {
    try {
      final docRef = _firestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('coupons')
          .doc();

      final couponWithId = coupon.copyWith(id: docRef.id);

      await docRef.set(couponWithId.toJson());

      _coupons.add(couponWithId);
      notifyListeners();

      // Délai pour éviter d'éventuels conflits lors des tests
      await Future.delayed(const Duration(milliseconds: 300));

      logger.i('✅ Coupon ajouté avec succès : ${couponWithId.toJson()}');
    } catch (e, stackTrace) {
      logger.e('❌ Erreur lors de l\'ajout du coupon', error: e, stackTrace: stackTrace);
      setErrorState('Erreur lors de l\'ajout du coupon.');
    }
  }

  /// Mettre à jour un coupon
  Future<void> updateCoupon(Coupon updatedCoupon) async {
    try {
      final couponRef = _firestore
          .collection('restaurants')
          .doc(updatedCoupon.restaurantId)
          .collection('coupons')
          .doc(updatedCoupon.id);

      await couponRef.update(updatedCoupon.toJson());

      final index = _coupons.indexWhere((coupon) => coupon.id == updatedCoupon.id);
      if (index != -1) {
        _coupons[index] = updatedCoupon;
        notifyListeners();
      }

      logger.i('✅ Le coupon ${updatedCoupon.id} a été mis à jour.');
    } catch (e, stackTrace) {
      logger.e('❌ Erreur lors de la mise à jour du coupon ${updatedCoupon.id} : $e', stackTrace: stackTrace);
    }
  }

  /// Supprimer un coupon
  Future<void> deleteCoupon(String restaurantId, String couponId) async {
    try {
      final couponRef = _firestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('coupons')
          .doc(couponId);

      await couponRef.delete();

      _coupons.removeWhere((coupon) => coupon.id == couponId);
      notifyListeners();

      logger.i('✅ Le coupon $couponId a été supprimé avec succès.');
    } catch (e, stackTrace) {
      logger.e('❌ Erreur lors de la suppression du coupon $couponId : $e', stackTrace: stackTrace);
    }
  }

  /// Réinitialiser les données des coupons
  void reset() {
    _coupons = [];
    _errorMessage = null;
    notifyListeners();
  }

  /// Définir des coupons pour les tests
  void setCouponsForTest(List<Coupon> testCoupons) {
    _coupons = List.from(testCoupons);
    notifyListeners();
  }

  /// Mettre à jour l'état de chargement
  void _setLoadingState(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Gérer l'état d'erreur
  void setErrorState(String errorMessage) {
    _errorMessage = errorMessage;
    notifyListeners();
    // Ce délai permet de s'assurer que l'état est bien pris en compte (pour les tests)
    Future.delayed(const Duration(milliseconds: 300));
  }
}
*/

import 'package:flutter/material.dart';
import '../models/coupon_model.dart';

class CouponProvider with ChangeNotifier {
  final List<Coupon> _coupons = [
    Coupon(
      id: 'coupon_1',
      restaurantId: 'restaurant_1',
      description: 'Promo 20% sur le menu',
      discountPercentage: 20,
      maxPeople: 4, uniqueCode: Coupon.generateUniqueCode(),
    ),
    Coupon(
      id: 'coupon_2',
      restaurantId: 'restaurant_2',
      description: '10€ de réduction',
      discountPercentage: 10,
      maxPeople: 6, uniqueCode: Coupon.generateUniqueCode(),
    ),
  ];

  List<Coupon> get coupons => List.unmodifiable(_coupons);

  /// Ajouter un coupon (en local)
  Future<void> addCoupon(String restaurantId, Coupon coupon) async {
    final newCoupon = coupon.copyWith(id: 'coupon_${_coupons.length + 1}');
    _coupons.add(newCoupon);
    notifyListeners();
  }

  /// Mettre à jour un coupon (en local)
  Future<void> updateCoupon(Coupon updatedCoupon) async {
    int index = _coupons.indexWhere((c) => c.id == updatedCoupon.id);
    if (index != -1) {
      _coupons[index] = updatedCoupon;
      notifyListeners();
    }
  }

  /// Supprimer un coupon (en local)
  Future<void> deleteCoupon(String couponId) async {
    _coupons.removeWhere((coupon) => coupon.id == couponId);
    notifyListeners();
  }
}
