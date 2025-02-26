import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gourmetpass/providers/user_provider.dart';
import 'package:gourmetpass/screens/restaurant_list_screen.dart';
import 'package:gourmetpass/screens/my_coupons_screen.dart';
import 'package:gourmetpass/screens/subscription_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final bool isSubscribed = user?.hasValidSubscription ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text("GourmetPass"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => _showUserProfile(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Bienvenue sur GourmetPass !",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              isSubscribed
                  ? "🎉 Votre abonnement est actif jusqu'au ${user?.subscriptionExpiresAt?.toLocal().toString().split(' ')[0]}"
                  : "🚨 Votre abonnement a expiré. Renouvelez-le pour profiter des avantages.",
              style: TextStyle(
                fontSize: 16,
                color: isSubscribed ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 20),

            /// 🔹 Bouton Accès Restaurants
            _buildMenuButton(
              icon: Icons.restaurant,
              label: "Voir les restaurants",
              color: Colors.orange,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RestaurantListScreen()),
              ),
            ),

            /// 🔹 Bouton Voir les Coupons (si abonné)
            if (isSubscribed)
              _buildMenuButton(
                icon: Icons.local_offer,
                label: "Mes coupons",
                color: Colors.blue,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyCouponsScreen()),
                ),
              ),

            /// 🔹 Bouton S'abonner (si abonnement expiré)
            if (!isSubscribed)
              _buildMenuButton(
                icon: Icons.payment,
                label: "S'abonner maintenant",
                color: Colors.green,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SubscriptionScreen()),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Affichage du profil utilisateur
  void _showUserProfile(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Mon Profil", textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.account_circle, size: 60, color: Colors.orange),
            const SizedBox(height: 10),
            Text(user?.displayName ?? "Utilisateur"),
            Text(user?.email ?? "Email inconnu", style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout),
              label: const Text("Déconnexion"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Déconnexion utilisateur
  void _logout(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.logout();
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  /// 🔹 Génération des boutons du menu
  Widget _buildMenuButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 28, color: Colors.white),
        label: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
