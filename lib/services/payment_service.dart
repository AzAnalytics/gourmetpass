import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

class PaymentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger logger = Logger();

  /// 🔹 Processus de paiement via Stripe
  Future<bool> processPayment(String userId, int amount) async {
    try {
      // 🔥 Étape 1 : Demander un PaymentIntent à notre backend Firebase
      final response = await http.post(
        Uri.parse('https://your-cloud-function-url/create-payment-intent'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"amount": amount, "currency": "eur"}),
      );

      if (response.statusCode != 200) {
        throw Exception("Erreur lors de la création du PaymentIntent");
      }

      final paymentIntentData = jsonDecode(response.body);
      final clientSecret = paymentIntentData['clientSecret'];

      // 🔥 Étape 2 : Ouvrir l'interface Stripe pour finaliser le paiement
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: "GourmetPass",
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      // ✅ Paiement réussi, on met à jour l'abonnement
      final newExpiration = DateTime.now().add(const Duration(days: 365)); // Abonnement 1 an
      await _firestore.collection('users').doc(userId).update({
        "subscriptionExpiresAt": Timestamp.fromDate(newExpiration),
      });

      return true;
    } catch (e) {
      logger.e("❌ Erreur de paiement : $e");
      return false;
    }
  }
}
