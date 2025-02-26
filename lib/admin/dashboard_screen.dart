import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gourmetpass/providers/user_provider.dart';
import 'package:gourmetpass/admin/screens/users/list_users_screen.dart';
import 'package:gourmetpass/admin/screens/restaurants/list_restaurants_screen.dart';
import 'package:gourmetpass/admin/screens/coupons/list_coupons_screen.dart';
import 'package:gourmetpass/admin/subscription_management_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userCount = userProvider.users.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tableau de Bord"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDashboardCard(
              title: "Utilisateurs",
              subtitle: "$userCount enregistrés",
              icon: Icons.people,
              color: Colors.blue,
              onTap: () => _navigateTo(context, const ListUsersScreen()),
            ),
            _buildDashboardCard(
              title: "Restaurants",
              subtitle: "Gérer les restaurants",
              icon: Icons.restaurant,
              color: Colors.green,
              onTap: () => _navigateTo(context, const ListRestaurantsScreen()),
            ),
            _buildDashboardCard(
              title: "Coupons",
              subtitle: "Gérer les coupons",
              icon: Icons.local_offer,
              color: Colors.purple,
              onTap: () => _navigateTo(context, const ListCouponsScreen()),
            ),
            _buildDashboardCard(
              title: "Abonnements",
              subtitle: "Gérer les abonnements",
              icon: Icons.credit_card,
              color: Colors.orange,
              onTap: () => _navigateTo(context, const SubscriptionManagementScreen()),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Génère une carte pour chaque section du tableau de bord
  Widget _buildDashboardCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: color.withValues(red: 255, green: 255, blue: 255, alpha: 10),
          child: Icon(icon, color: color),
        ),

        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  /// 🔹 Navigation vers un écran spécifique
  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }
}
