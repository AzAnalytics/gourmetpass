import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gourmetpass/providers/coupon_provider.dart';
import 'package:gourmetpass/models/coupon_model.dart';
import 'package:gourmetpass/admin/screens/coupons/add_coupon_screen.dart';
import 'package:gourmetpass/admin/screens/coupons/edit_coupon_screen.dart';

class ListCouponsScreen extends StatelessWidget {
  const ListCouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Liste des Coupons',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddCouponScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<CouponProvider>(
        builder: (context, couponProvider, child) {
          if (couponProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (couponProvider.coupons.isEmpty) {
            return const Center(
              child: Text(
                'Aucun coupon disponible.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(10),
            child: ListView.builder(
              itemCount: couponProvider.coupons.length,
              itemBuilder: (context, index) {
                final CouponModel coupon = couponProvider.coupons[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                      '${coupon.discountPercentage}% de réduction',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          value: coupon.isActive,
                          activeColor: Colors.green,
                          onChanged: (value) async {
                            final updatedCoupon = coupon.copyWith(isActive: value);
                            await couponProvider.updateCoupon(updatedCoupon);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(value
                                    ? 'Coupon activé.'
                                    : 'Coupon désactivé.'),
                                backgroundColor: value ? Colors.green : Colors.red,
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditCouponScreen(coupon: coupon),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _confirmDelete(context, couponProvider, coupon);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  /// 🔹 Boîte de dialogue pour confirmation de suppression
  void _confirmDelete(BuildContext context, CouponProvider couponProvider, CouponModel coupon) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Voulez-vous vraiment supprimer "${coupon.description}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await couponProvider.deleteCoupon(coupon.restaurantId, coupon.id);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Coupon "${coupon.description}" supprimé.'),
                  backgroundColor: Colors.redAccent,
                ),
              );
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
