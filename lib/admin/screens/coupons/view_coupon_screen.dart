import 'package:flutter/material.dart';
import '../../../models/coupon_model.dart';

class ViewCouponScreen extends StatelessWidget {
  final Coupon coupon;

  const ViewCouponScreen({super.key, required this.coupon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du Coupon'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description : ${coupon.description}',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Réduction : ${coupon.discountPercentage}%'),
            const SizedBox(height: 8),
            Text('Valide pour : ${coupon.maxPeople} personnes'),
            const SizedBox(height: 8),
            Text(coupon.isActive ? 'Statut : Actif' : 'Statut : Désactivé',
                style: TextStyle(
                    color: coupon.isActive ? Colors.green : Colors.red)),
          ],
        ),
      ),
    );
  }
}
