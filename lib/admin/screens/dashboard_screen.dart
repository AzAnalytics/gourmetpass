import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/user_provider.dart';
import '../../providers/restaurant_provider.dart';
import '../../providers/coupon_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final restaurantProvider = Provider.of<RestaurantProvider>(context);
    final couponProvider = Provider.of<CouponProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin - Tableau de Bord'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenue dans l\'interface admin 👋',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Vue d\'ensemble des statistiques :',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),

            // ✅ Cartes de statistiques
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard(
                  title: 'Restaurants',
                  count: restaurantProvider.restaurants.length,
                  color: Colors.orange,
                  icon: Icons.restaurant,
                ),
                _buildStatCard(
                  title: 'Coupons',
                  count: couponProvider.coupons.length,
                  color: Colors.blue,
                  icon: Icons.local_offer,
                ),
                _buildStatCard(
                  title: 'Utilisateurs',
                  count: userProvider.users.length,
                  color: Colors.green,
                  icon: Icons.people,
                ),
              ],
            ),

            const SizedBox(height: 30),

            // ✅ Graphique sur la répartition des utilisateurs
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        "Répartition des Utilisateurs",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 20),
                      Expanded(child: _buildUserPieChart(userProvider)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Carte pour afficher une statistique
  Widget _buildStatCard({required String title, required int count, required Color color, required IconData icon}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              count.toString(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
            Text(title, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  /// 🔹 Graphique en camembert pour la répartition des utilisateurs
  Widget _buildUserPieChart(UserProvider userProvider) {
    int adminCount = userProvider.users.where((user) => user.isAdmin).length;
    int userCount = userProvider.users.length - adminCount;

    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            color: Colors.orange,
            value: adminCount.toDouble(),
            title: 'Admins',
            radius: 60,
            titleStyle: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          PieChartSectionData(
            color: Colors.blue,
            value: userCount.toDouble(),
            title: 'Utilisateurs',
            radius: 60,
            titleStyle: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
