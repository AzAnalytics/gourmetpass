import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:gourmetpass/providers/coupon_provider.dart";
import 'add_coupon_screen.dart';
import 'edit_coupon_screen.dart';

class ListCouponsScreen extends StatelessWidget {
  const ListCouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final couponProvider = Provider.of<CouponProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Coupons'),
      ),
      body: couponProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : couponProvider.coupons.isEmpty
          ? const Center(child: Text('Aucun coupon disponible.'))
          : ListView.builder(
        itemCount: couponProvider.coupons.length,
        itemBuilder: (context, index) {
          final coupon = couponProvider.coupons[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(coupon.description),
              subtitle: Text('${coupon.discountPercentage}% de réduction'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditCouponScreen(coupon: coupon),
                        ),
                      );
                    },
                  ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await couponProvider.deleteCoupon(coupon.restaurantId, coupon.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Coupon "${coupon.description}" supprimé.'),
                  ),
                );
              },
            ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCouponScreen(restaurantId: '',)),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
