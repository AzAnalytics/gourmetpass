import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gourmetpass/providers/user_provider.dart';
import 'package:gourmetpass/models/user_model.dart';
import 'package:intl/intl.dart';

class SubscriptionManagementScreen extends StatelessWidget {
  const SubscriptionManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion des Abonnements"),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder(
        future: userProvider.fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = userProvider.users;
          if (users.isEmpty) {
            return const Center(child: Text("Aucun utilisateur trouvé."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final isSubscribed = user.hasValidSubscription;
              final expirationDate = user.subscriptionExpiresAt != null
                  ? DateFormat('dd/MM/yyyy').format(user.subscriptionExpiresAt!)
                  : "Non abonné";

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    backgroundColor: isSubscribed ? Colors.green.shade100 : Colors.red.shade100,
                    child: Icon(
                      isSubscribed ? Icons.check_circle : Icons.cancel,
                      color: isSubscribed ? Colors.green : Colors.red,
                    ),
                  ),
                  title: Text(user.displayName), // ✅ Suppression de "?? 'Utilisateur Inconnu'"
                  subtitle: Text("Expire le : $expirationDate"),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => _updateSubscription(context, user),
                    child: const Text("Mettre à jour"),
                  ),
                ),
              );

            },
          );
        },
      ),
    );
  }

  /// 🔹 Mettre à jour l'abonnement d'un utilisateur
  void _updateSubscription(BuildContext context, UserModel user) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final newExpiration = DateTime.now().add(const Duration(days: 365));

    await userProvider.updateSubscription(user.id, newExpiration);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("✅ Abonnement de ${user.displayName} mis à jour !"),
        backgroundColor: Colors.green,
      ),
    );
  }
}
