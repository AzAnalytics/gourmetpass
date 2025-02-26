import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gourmetpass/models/coupon_model.dart';

class CouponProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<CouponModel> _coupons = []; // ✅ Correction ici
  bool _isLoading = false;
  String? _errorMessage;

  List<CouponModel> get coupons => _coupons; // ✅ Correction ici
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// 🔹 Récupérer tous les coupons d'un restaurant
  Future<void> fetchCoupons(String restaurantId) async {
    _setLoading(true);
    try {
      final snapshot = await _firestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('coupons')
          .get();

      _coupons = snapshot.docs
          .map((doc) => CouponModel.fromJson(doc.data())) // ✅ Suppression du cast inutile
          .toList();

      notifyListeners();
    } catch (e) {
      _errorMessage = "Erreur lors de la récupération des coupons.";
      debugPrint("❌ fetchCoupons() : $e");
    } finally {
      _setLoading(false);
    }
  }


  /// 🔹 Ajouter un coupon à un restaurant
  Future<void> addCoupon(String restaurantId, CouponModel coupon) async { // ✅ Correction ici
    _setLoading(true);
    try {
      await _firestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('coupons')
          .doc(coupon.id.isNotEmpty ? coupon.id : null) // ✅ Vérification de `id`
          .set(coupon.toJson());

      _coupons.add(coupon);
      notifyListeners();
    } catch (e) {
      _errorMessage = "Erreur lors de l'ajout du coupon.";
      debugPrint("❌ addCoupon() : $e");
    } finally {
      _setLoading(false);
    }
  }

  /// 🔹 Mettre à jour un coupon
  Future<void> updateCoupon(CouponModel updatedCoupon) async { // ✅ Correction ici
    _setLoading(true);
    try {
      await _firestore
          .collection('restaurants')
          .doc(updatedCoupon.restaurantId)
          .collection('coupons')
          .doc(updatedCoupon.id)
          .update(updatedCoupon.toJson());

      int index = _coupons.indexWhere((c) => c.id == updatedCoupon.id);
      if (index != -1) {
        _coupons[index] = updatedCoupon;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = "Erreur lors de la mise à jour du coupon.";
      debugPrint("❌ updateCoupon() : $e");
    } finally {
      _setLoading(false);
    }
  }

  /// 🔹 Supprimer un coupon
  Future<void> deleteCoupon(String restaurantId, String couponId) async {
    _setLoading(true);
    try {
      await _firestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('coupons')
          .doc(couponId)
          .delete();

      _coupons.removeWhere((c) => c.id == couponId);
      notifyListeners();
    } catch (e) {
      _errorMessage = "Erreur lors de la suppression du coupon.";
      debugPrint("❌ deleteCoupon() : $e");
    } finally {
      _setLoading(false);
    }
  }

  /// 🔹 Récupérer les coupons actifs d'un utilisateur
  Future<void> fetchUserCoupons(String userId) async {
    _setLoading(true);
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('coupons')
          .where('isActive', isEqualTo: true)
          .get();

      _coupons = snapshot.docs
          .map((doc) => CouponModel.fromJson(doc.data())) // ✅ Correction ici
          .toList();

      notifyListeners();
    } catch (e) {
      _errorMessage = "Erreur lors de la récupération des coupons utilisateur.";
      debugPrint("❌ fetchUserCoupons() : $e");
    } finally {
      _setLoading(false);
    }
  }

  /// 🔹 Désactiver un coupon
  Future<void> disableCoupon(String restaurantId, String couponId) async {
    _setLoading(true);
    try {
      await _firestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('coupons')
          .doc(couponId)
          .update({'isActive': false});

      int index = _coupons.indexWhere((c) => c.id == couponId);
      if (index != -1) {
        _coupons[index] = _coupons[index].copyWith(isActive: false);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = "Erreur lors de la désactivation du coupon.";
      debugPrint("❌ disableCoupon() : $e");
    } finally {
      _setLoading(false);
    }
  }

  /// 🔹 Gérer l'état de chargement
  void _setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }
}
