import 'package:flutter/material.dart';
import 'package:gourmetpass/models/coupon_model.dart';

class CouponTile extends StatelessWidget {
  final CouponModel coupon;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final ValueChanged<bool>? onToggleActive;

  const CouponTile({
    super.key,
    required this.coupon,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onToggleActive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
          "${coupon.discountPercentage}% de réduction - Valable pour ${coupon.maxPeople} personne(s)",
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✅ Switch pour activer/désactiver un coupon (admin uniquement)
            if (onToggleActive != null)
              Switch(
                value: coupon.isActive,
                activeColor: Colors.green,
                onChanged: onToggleActive,
              ),

            // ✏️ Bouton Modifier (admin)
            if (onEdit != null)
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: onEdit,
              ),

            // ❌ Bouton Supprimer (admin)
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
