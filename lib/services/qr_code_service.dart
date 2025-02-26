import 'package:cloud_firestore/cloud_firestore.dart';

class QRCodeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔹 Vérifie si un coupon scanné est valide
  Future<String> validateCoupon(String scannedCode) async {
    try {
      final snapshot = await _firestore
          .collectionGroup('coupons')
          .where('uniqueCode', isEqualTo: scannedCode)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return "❌ Coupon invalide ou inexistant.";
      }

      final couponDoc = snapshot.docs.first;
      final couponData = couponDoc.data();

      if (!(couponData['isActive'] ?? false)) {
        return "⚠️ Ce coupon est désactivé.";
      }

      // 🔥 Désactivation du coupon après validation (si utilisation unique)
      await couponDoc.reference.update({'isActive': false});

      return "✅ Coupon validé avec succès !";
    } catch (e) {
      return "❌ Erreur de validation : $e";
    }
  }
}
