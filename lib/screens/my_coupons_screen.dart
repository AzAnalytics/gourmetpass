import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/coupon_provider.dart';
import '../providers/user_provider.dart';

class MyCouponsScreen extends StatelessWidget {
  const MyCouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final couponProvider = Provider.of<CouponProvider>(context);
    final user = userProvider.user;

    final bool hasSubscription = user?.hasValidSubscription ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes Coupons"),
        backgroundColor: Colors.orange,
      ),
      body: hasSubscription
          ? FutureBuilder(
        future: couponProvider.fetchUserCoupons(user!.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (couponProvider.coupons.isEmpty) {
            return const Center(
              child: Text(
                "Vous n'avez aucun coupon actif pour le moment.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: couponProvider.coupons.length,
            itemBuilder: (context, index) {
              final coupon = couponProvider.coupons[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    backgroundColor: Colors.orange.shade100,
                    child: const Icon(Icons.local_offer, color: Colors.orange),
                  ),
                  title: Text(
                    coupon.description,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "${coupon.discountPercentage}% de réduction",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                ),
              );
            },
          );
        },
      )
          : const Center(
        child: Text(
          "Vous devez avoir un abonnement actif pour voir vos coupons.",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.red),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
