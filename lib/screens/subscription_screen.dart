import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gourmetpass/providers/user_provider.dart';
import 'package:gourmetpass/services/payment_service.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final bool isSubscribed = user?.hasValidSubscription ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Abonnement"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Votre abonnement",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              isSubscribed
                  ? "🎉 Actif jusqu'au ${user?.subscriptionExpiresAt?.toLocal().toString().split(' ')[0]}"
                  : "🚨 Expiré ! Renouvelez-le pour profiter des offres.",
              style: TextStyle(
                fontSize: 16,
                color: isSubscribed ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 20),

            /// 🔹 Bouton de paiement
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.payment),
                label: Text(isSubscribed ? "Renouveler l'abonnement" : "S'abonner maintenant"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () async {
                  final success = await PaymentService().processPayment(
                    user!.id, // ✅ 1er argument : ID de l'utilisateur
                    80, // ✅ 2e argument : Montant du paiement
                  );

                  if (!success) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("❌ Paiement annulé."),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    return;
                  }

                  // Mise à jour de l'abonnement
                  final newExpiration = DateTime.now().add(const Duration(days: 365));
                  await userProvider.updateSubscription(user.id, newExpiration);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("✅ Abonnement mis à jour avec succès !"),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
